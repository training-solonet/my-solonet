import 'package:flutter/material.dart';
import 'package:mysolonet/detail/history/detail_history_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Data dummy untuk contoh transaksi
  final List<Map<String, dynamic>> transactions = [
    {
      'transactionId': 'TRX12345',
      'date': '17 Okt 2024',
      'totalAmount': '150,000',
      'items': [
        {'name': 'Produk A', 'price': '50,000'},
        {'name': 'Produk B', 'price': '100,000'},
      ],
    },
    {
      'transactionId': 'TRX12346',
      'date': '18 Okt 2024',
      'totalAmount': '200,000',
      'items': [
        {'name': 'Produk C', 'price': '200,000'},
      ],
    },
    {
      'transactionId': 'TRX12347',
      'date': '19 Okt 2024',
      'totalAmount': '75,000',
      'items': [
        {'name': 'Produk D', 'price': '75,000'},
      ],
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
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return _buildItem(
            Icons.history,
            'Transaksi ID: ${transaction['transactionId']}',
            'Tanggal: ${transaction['date']}',
            transaction, // Mengirim data transaksi ke _buildItem
          );
        },
      ),
    );
  }

  Widget _buildItem(IconData? icon, String title, String? subtitle, Map<String, dynamic> transaction) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          // Navigasi ke DetailHistoryScreen dan mengirim parameter yang diperlukan
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailHistoryScreen(
                transactionId: transaction['transactionId'],
                date: transaction['date'],
                totalAmount: transaction['totalAmount'],
                items: transaction['items'],
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: 24,
                  color: Colors.blue,
                ),
              if (icon != null) const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey,
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