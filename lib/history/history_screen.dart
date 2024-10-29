import 'package:flutter/material.dart';
import 'package:mysolonet/detail/history/detail_history_screen.dart';
import 'package:mysolonet/alert/confirm_popup.dart';
import 'package:mysolonet/auth/login.dart';
import 'package:mysolonet/pembayaran/payment_method.dart';
import 'package:mysolonet/auth/service/service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<Map<String, dynamic>> transactions = [
    {
      'transactionName': 'Langganan Wifi 50 Mbps',
      'date': '17 Nov 2024',
      'totalAmount': '150,000',
      'status': 'belum dibayar',
    },
    {
      'transactionName': 'Langganan Wifi 50 Mbps',
      'date': '17 Okt 2024',
      'totalAmount': '200,000',
      'status': 'success',
    },
  ];

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final authService = AuthService();
    final userData = await authService.getUserData();
    setState(() {
      isLoggedIn = userData != null; // Check if user data is available
    });

    if (!isLoggedIn) {
      // Redirect to LoginScreen if not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Riwayat',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoggedIn
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return _buildItem(transaction);
                      },
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Anda harus login untuk melihat riwayat transaksi.',
                      textAlign: TextAlign
                          .center, // Center the text within its container
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Button color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                      ),
                    ),
                    child: const Text(
                      'Login Sekarang',
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontFamily: 'Poppins', // Font family
                        fontSize: 16, // Font size
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildItem(Map<String, dynamic> transaction) {
    IconData icon;
    Color iconColor;
    String statusText;

    switch (transaction['status']) {
      case 'success':
        icon = Icons.check_circle_outline;
        iconColor = Colors.green;
        statusText = 'Berhasil';
        break;
      default:
        icon = Icons.pending_actions_outlined;
        iconColor = Colors.grey;
        statusText = 'Belum Dibayar';
        break;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () {
          if (transaction['status'] == 'belum dibayar') {
            confirmPopup(
              context,
              'Konfirmasi Pembayaran',
              'Apakah Anda ingin melanjutkan untuk membayar transaksi ini?',
              'Bayar Sekarang',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentMethodScreen(),
                  ),
                );
              },
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailHistoryScreen(),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(
                icon,
                size: 30,
                color: iconColor,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction['transactionName'],
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      transaction['date'],
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Text(
                      'Total: Rp${transaction['totalAmount']}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status: $statusText',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: iconColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}
