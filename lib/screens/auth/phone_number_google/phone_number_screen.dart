import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:mysolonet/alert/show_message_failed.dart';
// import 'package:mysolonet/auth/login.dart';
// import 'package:mysolonet/Otp/otp_screen.dart';
// import 'package:mysolonet/constants.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _whatsappController = TextEditingController();
  final bool _isLoading = false;

  @override
  void dispose() {
    _whatsappController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context)
                  .unfocus(); 
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/solonet.png",
                        height: 100,
                        width: 180,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.025),
                      const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 32.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 16.0),
                            _buildLabel('Whatsapp Number'),
                            _buildWhatsappTextField(),
                            const SizedBox(height: 16.0),
                            _buildButton(context),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ));
  }

  Padding _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14.5,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  TextFormField _buildWhatsappTextField() {
    return TextFormField(
      controller: _whatsappController,
      decoration: const InputDecoration(
        filled: true,
        fillColor: Color(0xFFF5FCF9),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: 12.0,
          fontFamily: 'Poppins',
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 12.0, right: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "+62",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 8.0),
              Text(
                "|",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value!.isEmpty) {
          return "No. Whatsapp harus diisi";
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(15),
      ],
    );
  }

  ElevatedButton _buildButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
        }
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: const StadiumBorder(),
      ),
      child: Text(
        _isLoading ? "Loading..." : "Register",
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}