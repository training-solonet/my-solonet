import 'package:flutter/material.dart';
import 'package:mysolonet/home/login.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Image.asset(
                    "assets/images/solonet.png",
                    height: 100,
                    width: 180,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.025),
                  const Text(
                    "Daftar",
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
                              'Nama Lengkap',
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
                            hintText: 'Masukkan Nama Lengkap',
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
                          onSaved: (name) {},
                        ),
                        const SizedBox(height: 16.0),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Nomor Whatsapp',
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
                            hintText: 'Masukkan Nomor Whatsapp',
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
                          keyboardType: TextInputType.phone,
                          onSaved: (phone) {},
                        ),
                        const SizedBox(height: 16.0),
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
                            hintText: 'Masukkan Email',
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
                            hintText: 'Masukkan Password',
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
                          onSaved: (password) {},
                        ),
                        const SizedBox(height: 16.0),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Confirm Password',
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
                            hintText: 'Masukkan Confirm Password',
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
                          onSaved: (password) {},
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // Simpan data form di sini
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
                            "Daftar",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // const SizedBox(height: 16.0),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInScreen()),
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
                                    style: TextStyle(
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                ],
                              ),
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
