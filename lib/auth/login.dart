import 'package:flutter/material.dart';
import 'package:mysolonet/auth/service/service.dart';
import 'package:mysolonet/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mysolonet/auth/register.dart';
import 'package:mysolonet/alert/show_message_failed.dart';
import 'package:mysolonet/alert/show_message_success.dart';
import 'package:mysolonet/home/home_screen.dart';
import 'package:mysolonet/forgot_pass/forgot_password.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mysolonet/loading/loading_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          '216357245101-3704ig9b328jphh1pv7pqjc2m6r4h5q2.apps.googleusercontent.com',
      scopes: [
        'email',
        'openid',
        'profile',
      ]);

  Future<void> _loginUser(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

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

    final url = Uri.parse('${baseUrl}/login');
    final headers = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    final body = json.encode({
      "email": _emailController.text,
      "password": _passwordController.text,
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        final authService = AuthService();
        await authService.saveToken(responseData['token']);
        print(responseData['token']);

        showSuccessMessage(context, responseData['message']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        final responseData = json.decode(response.body)['message'];
        showFailedMessage(context, responseData);
      }
    } catch (e) {
      // Tutup LoadingScreen jika terjadi error
      Navigator.of(context).pop();
      showFailedMessage(context, 'An error occurred: $e');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
          // print('ID Token: ${googleAuth.id}');
      print('ID Token: ${googleAuth.idToken}');
      print('email: ${googleUser.email}');
      print('displayName: ${googleUser.displayName}');

      final String? idToken = googleAuth.idToken;
      if (idToken != null) {
        // await _sendTokenToServer(idToken);
      } else {
        print('ID Token is null');
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: 'Masukkan Email',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                                fontSize: 13.5,
                              ),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Kata Sandi',
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
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible, // Change here
                            decoration: InputDecoration(
                              hintText: 'Masukkan Kata Sandi',
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                                fontSize: 13.5,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF5FCF9),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 10.0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible =
                                        !_isPasswordVisible; // Toggle visibility
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen()),
                                );
                              },
                              child: const Text(
                                'Lupa Kata Sandi?',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.lightBlue,
                                ),
                              ),
                            ),
                          ),
                          _buildSignUpLink(context),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _loginUser(context);
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
                                    'Login',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18.0,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Atau',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          _buildGoogleSignUpButton()
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "Belum punya akun? ",
          style: TextStyle(
            fontSize: 12.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
            );
          },
          child: const Text(
            'Daftar Sekarang',
            style: TextStyle(
              fontSize: 12.0,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Colors.lightBlue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleSignUpButton() {
    return OutlinedButton.icon(
      onPressed: () {
        _handleGoogleSignIn();
      },
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
        "Login dengan Google",
        style: TextStyle(fontSize: 14.5, fontFamily: 'Poppins'),
      ),
    );
  }
}
