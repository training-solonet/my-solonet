import 'package:flutter/material.dart';
import 'package:mysolonet/forgot_pass/new_password.dart';
import 'package:mysolonet/home/register.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
                    "Please enter your number whatsapp and we will \nsend you a link to return to your account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF757575),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  const ForgotPasswordForm(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  const NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  onSaved: (phone) {},
                  onChanged: (phone) {},
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
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
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
                    border: authOutlineInputBorder,
                    enabledBorder: authOutlineInputBorder,
                    focusedBorder: authOutlineInputBorder.copyWith(
                      borderSide: const BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8), // Space between the fields
              Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Dapatkan OTP",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8), 
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) => _buildOtpField(context, index)),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ElevatedButton(
            onPressed: () {
               Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewPasswordScreen()),
            );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            child: const Text(
              "Continue",
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpField(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 40,
      height: 40,
      child: TextFormField(
        onChanged: (value) {
          if (value.length == 1) {
            // Move to the next field when one character is entered
            FocusScope.of(context).nextFocus();
          }  else if (value.isEmpty) {
            // Move to the previous field when one character is deleted
            if (index > 0) {
              FocusScope.of(context).previousFocus();
            }
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          counterText: "",
          hintText: "",
          hintStyle: const TextStyle(
            fontSize: 20,
            fontFamily: 'Poppins',
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 20,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}


class NoAccountText extends StatelessWidget {
  const NoAccountText({super.key});

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
