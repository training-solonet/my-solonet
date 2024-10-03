import 'package:flutter/material.dart';
import 'package:mysolonet/forgot_pass/new_password.dart';
import 'package:mysolonet/auth/register.dart';
import 'package:mysolonet/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(baseUrl + "request-otp");
    final headers = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    final body = json.encode({
      "phone_number": "62" + _phoneController.text,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        print(responseData['message']);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
        ));

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  NewPasswordScreen(phone: _phoneController.text)),
        );
      } else {
        final responseData = json.decode(response.body);

        print(responseData['message']);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "",
          style: TextStyle(color: Color(0xFF757575), fontFamily: 'Poppins'),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please enter your number WhatsApp and we will \nsend you a link to return to your account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF757575),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  _ForgotPasswordForm(
                    formKey: _formKey,
                    controller: _phoneController,
                    isLoading: _isLoading,
                    onSubmit: _submitForm,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  const _NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ForgotPasswordForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _ForgotPasswordForm({
    super.key,
    required this.formKey,
    required this.controller,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Enter your number",
                    labelText: "Phone Number",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintStyle: const TextStyle(
                      color: Color(0xFF757575),
                      fontFamily: 'Poppins',
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 12.0, right: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "+62",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "|",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    border: _authOutlineInputBorder,
                    enabledBorder: _authOutlineInputBorder,
                    focusedBorder: _authOutlineInputBorder.copyWith(
                      borderSide: const BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ElevatedButton(
            onPressed: isLoading ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            child: Text(
              isLoading ? "Loading..." : "Submit",
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
          ),
        ],
      ),
    );
  }
}

const _authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);

class _NoAccountText extends StatelessWidget {
  const _NoAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don’t have an account? ",
          style: TextStyle(
            color: Color(0xFF757575),
            fontFamily: 'Poppins',
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
              color: Colors.blueAccent,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}
