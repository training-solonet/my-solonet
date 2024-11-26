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

  bool _isResendOtp = false;
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
    String otp = _controllers.map((controller) => controller.text).join();

    if (otp.length < 6) {
      showFailedMessage(context, "Kode OTP harus terdiri dari 6 digit.");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingScreen();
      },
    );

    final url = Uri.parse("$baseUrl/verify-otp");
    final headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    final body = json.encode({
      "phone_number": "62${widget.phone}",
      "otp": otp,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        showSuccessMessage(context, responseData['message']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      } else {
        final responseData = json.decode(response.body);
        showFailedMessage(context, responseData['message']);
      }
    } catch (e) {
      Navigator.of(context).pop();
      showFailedMessage(context, "Terjadi kesalahan saat memverifikasi OTP.");
    }
  }

  void _handleResendOtp() async {
    setState(() {
      _start = 60;
      _isResendOtp = false;
    });
    _startTimer();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingScreen();
      },
    );

    final url = Uri.parse('$baseUrl/send-otp');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    final body = json.encode({
      "phone_number": "62${widget.phone}",
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        showSuccessMessage(context, responseData['message']);
      } else {
        final responseData = json.decode(response.body);
        showFailedMessage(context, responseData['message']);
      }
    } catch (e) {
      Navigator.of(context).pop();
      showFailedMessage(context, "Terjadi kesalahan saat mengirim ulang OTP.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
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
                  onPressed: () => _submitOtp(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BCD4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Kirim Kode',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_isResendOtp)
                  TextButton(
                    onPressed: _handleResendOtp,
                    child: const Text(
                      "Kirim Ulang OTP",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                if (!_isResendOtp)
                  Text(
                    "Kirim ulang dalam ${_start}s",
                    style: const TextStyle(color: Colors.grey),
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
      height: 50,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: "",
          hintText: "•",
          filled: true,
          fillColor: const Color(0xFFE0E0E0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
      ),
    );
  }
}
