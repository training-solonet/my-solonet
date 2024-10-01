import 'package:flutter/material.dart';
import 'package:mysolonet/home/login.dart';
import 'package:mysolonet/Otp/otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
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
                        _buildLabel('Full Name'),
                        _buildTextField('Enter Your Full Name', TextInputType.text),
                        const SizedBox(height: 16.0),
                        _buildLabel('Whatsapp Number'),
                        _buildTextField('Enter Your Whatsapp Number', TextInputType.phone),
                        const SizedBox(height: 16.0),
                        _buildLabel('Email'),
                        _buildTextField('Enter Your Email', TextInputType.emailAddress),
                        const SizedBox(height: 16.0),
                        _buildLabel('Address'),
                        _buildTextField('Enter Your Address', TextInputType.text),
                        const SizedBox(height: 16.0),
                        _buildLabel('Password'),
                        _buildPasswordField('Enter Your Password'),
                        const SizedBox(height: 16.0),
                        _buildLabel('Confirm Password'),
                        _buildPasswordField('Enter Your Confirm Password'),
                        const SizedBox(height: 16.0),
                        _buildRegisterButton(context),
                        _buildSignInLink(context),
                        const SizedBox(height: 16.0),
                        _buildGoogleSignUpButton(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
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

  TextFormField _buildTextField(String hint, TextInputType type) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5FCF9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      ),
      keyboardType: type,
      onSaved: (value) {},
    );
  }

  TextFormField _buildPasswordField(String hint) {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5FCF9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      ),
      onSaved: (value) {},
    );
  }

  ElevatedButton _buildRegisterButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OtpScreen()), // Navigate to OTP Screen
          );
        }
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: const StadiumBorder(),
      ),
      child: const Text(
        "Register",
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Align _buildSignInLink(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
          );
        },
        child: const Text.rich(
          TextSpan(
            text: "Already have an account? ",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(
                text: "Sign in",
                style: TextStyle(color: Colors.lightBlue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildGoogleSignUpButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Implement Google sign-up functionality here
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        minimumSize: const Size(double.infinity, 48),
        shape: const StadiumBorder(),
        side: const BorderSide(color: Colors.black12),
      ),
      icon: Image.asset(
        "assets/images/google.png",
        scale: 1.0,
        height: 24,
      ),
      label: const Text(
        "Sign Up with Google",
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
