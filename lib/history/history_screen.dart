import 'package:flutter/material.dart';
import 'package:mysolonet/detail/history/detail_history_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<Map<String, dynamic>> transactions = [
    {
      'transactionName': 'Pasang Wifi 50 Mbps',
      'date': '17 Okt 2024',
      'totalAmount': '150,000',
      'status': 'success',
    },
    {
      'transactionName': 'Tagihan Internet',
      'date': '17 Nov 2024',
      'totalAmount': '200,000',
      'status': 'belum dibayar',
    },
    {
      'transactionName': 'Pengiriman Barang',
      'date': '18 Nov 2024',
      'totalAmount': '75,000',
      'status': 'failed',
    },
  ];

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
      body: Padding(
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
      case 'failed':
        icon = Icons.error_outline;
        iconColor = Colors.red;
        statusText = 'Gagal';
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailHistoryScreen(),
            ),
          );
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
