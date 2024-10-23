import 'package:flutter/material.dart';

class DetailHistoryScreen extends StatelessWidget {
  const DetailHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Data statis
    final String date = '12 Oktober 2024';
    final String totalAmount = '1.500.000';
    final List<Map<String, dynamic>> items = [
      {'period': 'September 2024'},
      {'paymentMethod': 'Transfer Bank'},
      {'tax': '150.000'},
      {'amount': '1.350.000'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Detail Riwayat Transaksi',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage(
                    'https://icon2.cleanpng.com/20190218/tsh/kisspng-checkbox-vector-graphics-computer-icons-check-mark-toodoo-ocr-to-do-and-task-list-apps-on-google-1713906799832.webp',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pembayaran Berhasil',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                date,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Rp $totalAmount',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              _buildItemList(items),
              const SizedBox(height: 20),
              _buildTotalAmount(totalAmount),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  print('Button pressed');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Download',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemList(List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItemRow('Periode Tagihan', items[0]['period']),
        _buildItemRow('Metode Pembayaran', items[1]['paymentMethod']),
        _buildItemRow('PPN', 'Rp ${items[2]['tax']}'),
        _buildItemRow('Nominal', 'Rp ${items[3]['amount']}'),
      ],
    );
  }

  Widget _buildItemRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAmount(String totalAmount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Text(
          'Rp $totalAmount',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
