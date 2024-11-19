import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysolonet/widgets/alert/show_message_failed.dart';
import 'package:mysolonet/screens/auth/login.dart';
import 'package:mysolonet/utils/constants.dart';
import 'package:mysolonet/widgets/alert/show_message_success.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mysolonet/widgets/loading/loading_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phone;

  const OtpScreen({super.key, required this.phone});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  bool _isLoading = false;
  bool _isResendOtp = false;
  bool _isLoadingResend = false;
  int _start = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
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

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _handlePaste(String pastedText) {
    if (pastedText.length == 6) {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = pastedText[i];
      }
      _focusNodes.last.requestFocus();
    }
  }

  Future<void> _submitOtp(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingScreen();
      },
    );
    print(widget.phone);

    String otp = _controllers.map((controller) => controller.text).join();

    final url = Uri.parse("${baseUrl}/verify-otp");
    final headers = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    final body = json.encode({
      "phone_number": "62" + widget.phone,
      "otp": otp,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData['message']);
        showSuccessMessage(context, responseData['message']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      } else {
        final responseData = json.decode(response.body);
        print(responseData['message']);
        showFailedMessage(context, responseData['message']);
      }
    } catch (e) {
      // Tutup LoadingScreen jika terjadi error
      Navigator.of(context).pop();
      showFailedMessage(context, "An error occurred while sending the OTP");
    }
  }

  void _handleResendOtp() async {
    setState(() {
      _start = 60;
      _isResendOtp = false;
      _isLoadingResend = true;
    });
    _startTimer();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingScreen();
      },
    );

    final url = Uri.parse('${baseUrl}/send-otp');
    final headers = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    final body = json.encode({
      "phone_number": "62" + widget.phone,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData['message']);
        showSuccessMessage(context, responseData['message']);
      } else {
        final responseData = json.decode(response.body);
        print(responseData['message']);
        showFailedMessage(context, responseData['message']);
      }
    } catch (e) {
      // Tutup LoadingScreen jika terjadi error
      Navigator.of(context).pop();
      showFailedMessage(context, "An error occurred while sending the OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Container(
            height: 56.0,
            color: Colors.transparent,
          ),
        ),
        body: Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/solonet.png',
                  width: 150,
                  height: 50,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Verifikasi Kode OTP",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Silakan masukkan kode 6 digit OTP yang telah dikirimkan melalui nomor Whatsapp anda",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) => _buildOtpField(index)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String otp =
                        _controllers.map((controller) => controller.text).join();
                    _submitOtp(context);
                    print("OTP entered: $otp");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BCD4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Kirim Kode',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Belum menerima kode?",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _isResendOtp
                      ? 'Minta kode baru sekarang'
                      : 'Minta kode baru dalam 00:${_start.toString().padLeft(2, '0')} detik',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: _isResendOtp ? Colors.blue : Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 10),
                if (_isResendOtp)
                  ElevatedButton(
                    onPressed: _handleResendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BCD4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 40,
      height: 40,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          // Jika field tidak kosong dan bukan di field terakhir, pindah fokus ke field berikutnya
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          }
          // Jika field kosong dan bukan di field pertama, pindah fokus ke field sebelumnya
          else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }

          // Cek apakah semua field sudah terisi
          if (value.isNotEmpty && _isOtpComplete()) {
            _submitOtp(context); // Lakukan verifikasi otomatis
          }
        },
        onTap: () async {
          ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
          if (data != null && data.text!.length == 6) {
            _handlePaste(data.text!); // Jika ada OTP di clipboard, tempelkan
          }
        },
        decoration: InputDecoration(
          counterText: "",
          hintText: "•",
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            color: Colors.grey,
          ),
          filled: true,
          fillColor: const Color(0xFFE0E0E0),
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.blue,
            ),
          ),
        ),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }

  bool _isOtpComplete() {
    for (var controller in _controllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true; // Jika semua field terisi, kembalikan true
  }
}
