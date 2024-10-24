import 'dart:math';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final String bankName;

  PaymentScreen({Key? key, required this.bankName}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? virtualAccount;
  double amount = 0.0;
  DateTime? expirationDate;

  // Generate random virtual account number
  String generateVirtualAccount() {
    Random random = Random();
    return 'VA${random.nextInt(1000000000).toString().padLeft(10, '0')}';
  }

  @override
  void initState() {
    super.initState();
    virtualAccount = generateVirtualAccount();
    amount = 150000; // Contoh nominal
    expirationDate = DateTime.now().add(Duration(days: 1)); // Expired dalam 1 hari
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Pembayaran untuk ${widget.bankName}', style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Nomor Virtual Account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
            Text('-----------------------------------------', style: TextStyle(fontFamily: 'Poppins')),
            SizedBox(height: 5),
            Text('$virtualAccount', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w400)),
            SizedBox(height: 15),
            Text('Rp${amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Lakukan Pembayaran\nSebelum: ${expirationDate!.toLocal().toString().split(' ')[0]}', style: TextStyle(fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
              ),
            ),
            SizedBox(height: 25),
            Text('Cara Membayar:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
            SizedBox(height: 10),
            // Cara Membayar melalui ATM
            ExpansionTile(
              title: Text('1. Melalui ATM', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
              children: [
                ListTile(
                  title: Text('- Masukkan kartu ATM dan PIN.', style: TextStyle(fontFamily: 'Poppins')),
                ),
                ListTile(
                  title: Text('- Pilih menu “Transfer”.', style: TextStyle(fontFamily: 'Poppins')),
                ),
                ListTile(
                  title: Text('- Pilih “Virtual Account” dan masukkan nomor VA.', style: TextStyle(fontFamily: 'Poppins')),
                ),
                ListTile(
                  title: Text('- Masukkan nominal pembayaran.', style: TextStyle(fontFamily: 'Poppins')),
                ),
                ListTile(
                  title: Text('- Ikuti instruksi untuk menyelesaikan pembayaran.', style: TextStyle(fontFamily: 'Poppins')),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Cara Membayar melalui Mobile Banking
            ExpansionTile(
              title: Text('2. Melalui Mobile Banking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
              children: [
                ListTile(
                  title: Text('- Buka aplikasi mobile banking.', style: TextStyle(fontFamily: 'Poppins')),
                ),
                ListTile(
                  title: Text('- Pilih menu “Transfer”.', style: TextStyle(fontFamily: 'Poppins')),
                ),
                ListTile(
                  title: Text('- Pilih “Virtual Account” dan masukkan nomor VA.', style: TextStyle(fontFamily: 'Poppins')),
                ),
                ListTile(
                  title: Text('- Masukkan nominal pembayaran.', style: TextStyle(fontFamily: 'Poppins')),
                ),
                ListTile(
                  title: Text('- Konfirmasi pembayaran.', style: TextStyle(fontFamily: 'Poppins')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
