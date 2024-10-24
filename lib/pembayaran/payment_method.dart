import 'package:flutter/material.dart';
import 'payment_screen.dart'; // Pastikan untuk mengimpor PaymentScreen

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({Key? key}) : super(key: key);

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Metode Pembayaran',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih metode pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Bank',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),
            // Single card for multiple banks using ExpansionTile
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/bri.png',
                      width: 40,
                      height: 25,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 20),
                    Image.asset(
                      'assets/images/bni.png',
                      width: 40,
                      height: 25,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                children: [
                  // When expanded, show each bank in a row with image, name, and chevron
                  _buildBankRow('assets/images/bri.png', 'BRI'),
                  const Divider(),  // Optional: add a divider between banks
                  _buildBankRow('assets/images/bni.png', 'BNI'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for each bank row with image, name, and chevron icon
  Widget _buildBankRow(String imagePath, String bankName) {
    return GestureDetector(
      onTap: () {
        // Navigate to PaymentScreen with the selected bank name
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(bankName: bankName),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            // Bank logo on the left
            Image.asset(
              imagePath,
              width: 40,
              height: 25,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 20),
            // Bank name in the middle
            Expanded(
              child: Text(
                bankName,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            // Chevron icon on the right
            const Icon(
              Icons.chevron_right,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
