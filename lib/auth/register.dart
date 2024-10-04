import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysolonet/alert/show_message_failed.dart';
import 'package:mysolonet/alert/show_message_success.dart';
import 'package:mysolonet/auth/login.dart';
import 'package:mysolonet/Otp/otp_screen.dart';
import 'package:mysolonet/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _whatsappController.dispose();
    _fullnameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  Future<void> _createUser(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(baseUrl + "register");
    final headers = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    final body = json.encode({
      "name": _fullnameController.text,
      "phone_number": "62" + _whatsappController.text,
      "email": _emailController.text,
      "alamat": _addressController.text,
      "password": _passwordController.text,
      "confirm_password": _confirmpasswordController.text
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData['message']);

        // showSuccessMessage(context, responseData['message']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => OtpScreen(phone: _whatsappController.text)),
        );
        print(
            "Navigating to OTP Screen with phone: ${_whatsappController.text}");

        setState(() {
          _isLoading = false;
        });
      } else {
        final responseData = json.decode(response.body);

        showFailedMessage(context, responseData['message']);

        print(responseData['message']);
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      showFailedMessage(context, '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context)
                  .unfocus(); // Menutup keyboard saat klik di luar TextField
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
                            _buildLabel('Full Name'),
                            _buildTextField(
                                _fullnameController,
                                'Enter Your Full Name',
                                TextInputType.text, (value) {
                              if (value!.isEmpty) {
                                return "Full Name cannot be empty";
                              }
                              return null;
                            }),
                            const SizedBox(height: 16.0),
                            _buildLabel('Whatsapp Number'),
                            _buildWhatsappTextField(),
                            const SizedBox(height: 16.0),
                            _buildLabel('Email'),
                            _buildTextField(
                                _emailController,
                                'Enter Your Email',
                                TextInputType.emailAddress, (value) {
                              if (value!.isEmpty) {
                                return "Email cannot be empty";
                              }
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return "Enter a valid email";
                              }
                              return null;
                            }),
                            const SizedBox(height: 16.0),
                            _buildLabel('Address'),
                            _buildTextField(
                                _addressController,
                                'Enter Your Address',
                                TextInputType.text, (value) {
                              if (value!.isEmpty) {
                                return "Address cannot be empty";
                              }
                              return null;
                            }),
                            const SizedBox(height: 16.0),
                            _buildLabel('Password'),
                            _buildPasswordField(
                                _passwordController, 'Enter Your Password',
                                (value) {
                              if (value!.isEmpty) {
                                return "Password cannot be empty";
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            }),
                            const SizedBox(height: 16.0),
                            _buildLabel('Confirm Password'),
                            _buildPasswordField(_confirmpasswordController,
                                'Enter Your Confirm Password', (value) {
                              if (value!.isEmpty) {
                                return "Confirm password cannot be empty";
                              }
                              if (value != _passwordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            }),
                            const SizedBox(height: 16.0),
                            _buildRegisterButton(context),
                            _buildSignInLink(context),
                            const SizedBox(height: 16.0),
                            const Text(
                              "or",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14.5,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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

  TextFormField _buildTextField(TextEditingController controller, String hint,
      TextInputType type, String? Function(String?)? validator) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            color: Colors.grey, fontFamily: 'Poppins', fontSize: 13.5),
        filled: true,
        fillColor: const Color(0xFFF5FCF9),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12.0,
          fontFamily: 'Poppins',
        ),
      ),
      keyboardType: type,
      validator: validator,
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
          return "Whatsapp number cannot be empty";
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(15),
      ],
    );
  }

  TextFormField _buildPasswordField(TextEditingController controller,
      String hint, String? Function(String?)? validator) {
    return TextFormField(
      obscureText: true,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            color: Colors.grey, fontFamily: 'Poppins', fontSize: 13.5),
        filled: true,
        fillColor: const Color(0xFFF5FCF9),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12.0,
          fontFamily: 'Poppins',
        ),
      ),
      validator: validator,
    );
  }

  ElevatedButton _buildRegisterButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          _createUser(context);
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
                text: "Sign In",
                style: TextStyle(
                  color: Colors.lightBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  OutlinedButton _buildGoogleSignUpButton() {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Image.asset(
        "assets/images/google.png",
        width: 18,
        height: 18,
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        shape: const StadiumBorder(),
      ),
      label: const Text(
        "Sign up with Google",
        style: TextStyle(fontSize: 14.5, fontFamily: 'Poppins'),
      ),
    );
  }
}