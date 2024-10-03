import 'package:flutter/material.dart';
import 'package:mysolonet/auth/register.dart';
import 'package:mysolonet/home/home_screen.dart';
import 'package:mysolonet/forgot_pass/forgot_password.dart';

class SignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Image.asset(
                    "assets/images/solonet.png",
                    height: 100,
                    width: 180,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  const Text(
                    "Login",
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
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Email',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14.5,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter Email',
                            hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Poppins', fontSize: 13.5),
                            filled: true,
                            fillColor: Color(0xFFF5FCF9),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 10.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (email) {},
                        ),
                        const SizedBox(height: 16.0),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14.5,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Enter Password',
                            hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Poppins', fontSize: 13.5),
                            filled: true,
                            fillColor: Color(0xFFF5FCF9),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 10.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          onSaved: (password) {
                            // Simpan data password
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPasswordScreen()),
                              );
                            },
                            child: const Text('Forgot Password?',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.lightBlue,
                                )),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()),
                              );
                            },
                            child: const Text.rich(
                              TextSpan(
                                text: "Don’t have an account? ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign Up",
                                    style: TextStyle(
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
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
                            "Login",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                        ElevatedButton.icon(
                          onPressed: () {
                            // Fungsi login dengan Google
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                            side: const BorderSide(color: Colors.black12),
                          ),
                          icon: Image.asset(
                            "assets/images/google.png",
                            bundle: null,
                            scale: 1.0,
                            height: 24,
                          ),
                          label: const Text(
                            "Sign In with Google",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          
                        ),
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
}
