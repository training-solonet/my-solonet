import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mysolonet/screens/auth/service/confirm_account_connection.dart';
import 'package:mysolonet/screens/auth/service/service.dart';

import 'package:mysolonet/widgets/input/otp_field.dart';

// Model untuk data customer
class CustomerData {
  final String idPelanggan;
  final String nama;
  final String? alamat;
  final Map<String, dynamic> paket;

  CustomerData({
    required this.idPelanggan,
    required this.nama,
    this.alamat,
    required this.paket,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      idPelanggan: json['id_pelanggan'],
      nama: json['nama'],
      alamat: json['alamat'],
      paket: json['paket'],
    );
  }
}

class ConnectingAccountScreen extends StatefulWidget {
  const ConnectingAccountScreen({super.key});

  @override
  State<ConnectingAccountScreen> createState() =>
      _ConnectingAccountScreenState();
}

class _ConnectingAccountScreenState extends State<ConnectingAccountScreen> {
  bool showOtpField = false;
  final TextEditingController _idPelangganController = TextEditingController();
  final List<TextEditingController> _otpcontrollers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  bool _isResendOtp = false;
  bool _isLoading = false;
  int _start = 60;
  Timer? _timer;
  String? _phoneNumber;
  CustomerData? _customerData;

  @override
  void dispose() {
    _timer?.cancel();
    _idPelangganController.dispose();
    for (var controller in _otpcontrollers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _start = 60;
    _isResendOtp = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isResendOtp = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  Future<void> _sendOtp() async {
    if (_idPelangganController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan masukkan ID Pelanggan')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = await AuthService().getToken(); // Ambil token

      final response = await http.post(
        Uri.parse('https://api.connectis.my.id/hubungkan-account'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Tambahkan token ke header
        },
        body: jsonEncode({
          'id_pelanggan': _idPelangganController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          showOtpField = true;
          _phoneNumber = data['phone_number'];
        });
        _startTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(data['message']), backgroundColor: Colors.green),
        );
      } else {
        throw Exception(data['message'] ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpcontrollers.map((c) => c.text).join();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan 6 digit kode OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = await AuthService().getToken(); // Ambil token

      final response = await http.post(
        Uri.parse('https://api.connectis.my.id/hubungkan-account'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Tambahkan token ke header
        },
        body: jsonEncode({
          'id_pelanggan': _idPelangganController.text,
          'otp': otp,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _customerData = CustomerData.fromJson(data['customer']);
        });
        Navigator.push(
          context,
            MaterialPageRoute(
            builder: (context) => ConfirmAccountConnectionScreen(
              customerData: data['customer'], 
              token: token,
              verifiedOtp: otp,  // Mengirim OTP yang sudah diverifikasi
            ),
            ),
        );
      } else {
        throw Exception(data['message'] ?? 'Kode OTP tidak valid');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void handleOtpChange(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hubungkan Sekarang',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: showOtpField
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Masukkan kode OTP',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        if (_phoneNumber != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Kode OTP telah dikirim ke $_phoneNumber',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            6,
                            (index) => OtpField(
                              controller: _otpcontrollers[index],
                              focusNode: _focusNodes[index],
                              index: index,
                              onChanged: handleOtpChange,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 12.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Verifikasi',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_isResendOtp)
                          TextButton(
                            onPressed: _isLoading ? null : _sendOtp,
                            child: const Text(
                              "Kirim Ulang OTP",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        if (!_isResendOtp)
                          Text(
                            "Kirim ulang dalam $_start detik",
                            style: const TextStyle(color: Colors.grey),
                          ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Masukkan ID Pelanggan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _idPelangganController,
                          decoration: InputDecoration(
                            hintText: 'Masukkan ID Pelanggan',
                            contentPadding: const EdgeInsets.fromLTRB(
                              20.0,
                              14.0,
                              20.0,
                              14.0,
                            ),
                            labelStyle: const TextStyle(fontFamily: 'Poppins'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          style: const TextStyle(fontFamily: 'Poppins'),
                          textCapitalization: TextCapitalization.characters,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _sendOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 12.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Hubungkan Sekarang',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
