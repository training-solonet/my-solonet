import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysolonet/alert/show_message_success.dart';

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
  int _selectedTabIndex = 0;

  String generateVirtualAccount() {
    Random random = Random();
    return 'VA${random.nextInt(1000000000).toString().padLeft(10, '0')}';
  }

  @override
  void initState() {
    super.initState();
    virtualAccount = generateVirtualAccount();
    amount = 150000;
    expirationDate = DateTime.now().add(Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Pembayaran untuk ${widget.bankName}',
          style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Nomor Virtual Account',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
                const Text('-----------------------------------------',
                    style: TextStyle(fontFamily: 'Poppins')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$virtualAccount',
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy, color: Colors.black),
                      iconSize: 15,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: virtualAccount!));
                        showSuccessMessage(context, 'Nomor VA telah disalin');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Rp${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Lakukan Pembayaran Sebelum\n${expirationDate!.toLocal().toString().split(' ')[0]}',
                    textAlign: TextAlign.center, 
                    style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTabButton('ATM', 0),
                    _buildTabButton('Mobile Banking', 1),
                  ],
                ),
                const SizedBox(height: 10),
                _selectedTabIndex == 0
                    ? _buildSection([
                        '- Masukkan kartu ATM dan PIN.',
                        '- Pilih menu “Transfer”.',
                        '- Pilih “Virtual Account” dan masukkan nomor VA.',
                        '- Masukkan nominal pembayaran.',
                        '- Ikuti instruksi untuk menyelesaikan pembayaran.'
                      ])
                    : _buildSection([
                        '- Buka aplikasi mobile banking.',
                        '- Pilih menu “Transfer”.',
                        '- Pilih “Virtual Account” dan masukkan nomor VA.',
                        '- Masukkan nominal pembayaran.',
                        '- Konfirmasi pembayaran.'
                      ]),
                const SizedBox(height: 80),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Implementasi logika pembayaran di sini
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Cek Status Pembayaran',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildTabButton(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _selectedTabIndex == index ? Colors.blueAccent : Colors.grey,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 2,
            width: 50,
            color: _selectedTabIndex == index
                ? Colors.blueAccent
                : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(List<String> steps) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.1, horizontal: 20),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              steps[index],
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
            dense: true,
          ),
        );
      },
    );
  }
}