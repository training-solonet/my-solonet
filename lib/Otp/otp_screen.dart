import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import added

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Background color similar to #f8f9fa
      body: Center(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset( // Changed from Image.network to Image.asset
                'assets/images/solonet.png', // Replace 'your_image.png' with the actual image file name
                width: 150,
                height: 50,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                "Verifikasi Kode OTP",
                style: TextStyle(
                  fontFamily: 'Poppins', // Apply Poppins font
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Silakan masukkan kode 6 digit OTP yang telah  dikirimkan melalui nomor Whatsapp anda",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins', // Apply Poppins font
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 20),
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOtpField(context),
                  _buildOtpField(context),
                  _buildOtpField(context),
                  _buildOtpField(context),
                  _buildOtpField(context),
                  _buildOtpField(context),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle OTP verification action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BCD4),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "Verifikasi",
                  style: TextStyle(
                    fontFamily: 'Poppins', // Apply Poppins font
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Belum menerima kode?",
                style: TextStyle(
                  fontFamily: 'Poppins', // Apply Poppins font
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const Text(
                "Minta kode baru dalam 00:30 detik",
                style: TextStyle(
                  fontFamily: 'Poppins', // Apply Poppins font
                  fontSize: 14,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to create OTP text fields
  Widget _buildOtpField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 40,
      height: 40,
      child: TextFormField(
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: "",
          hintText: "•", // Set hint text to dot (•)
          hintStyle: const TextStyle(
            fontFamily: 'Poppins', // Apply Poppins font
            fontSize: 18,
            color: Colors.grey, // Set color for hint text
          ),
          filled: true,
          fillColor: const Color(0xFFE0E0E0), // Light grey color for background
          contentPadding: const EdgeInsets.all(10), // Ensures vertical centering
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.transparent, // No border
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.transparent, // No border when enabled
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.blue, // Border color when focused
            ),
          ),
        ),
        style: const TextStyle(
          fontFamily: 'Poppins', // Apply Poppins font
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }
}
