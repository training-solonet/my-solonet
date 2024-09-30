import 'package:flutter/material.dart';

class DetailPromoScreen extends StatefulWidget {
  const DetailPromoScreen({Key? key}) : super(key: key);

  @override
  _DetailPromoScreenState createState() => _DetailPromoScreenState();
}

class _DetailPromoScreenState extends State<DetailPromoScreen> {
  bool _isExpanded = false; // State untuk dropdown syarat dan ketentuan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Promo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke layar sebelumnya
          },
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Promo
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://via.placeholder.com/150',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10), // Jarak antara gambar dan keterangan

            // Keterangan Promo
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Promo Spesial: Paket Internet Unlimited',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Nikmati kecepatan internet tanpa batas dengan paket ini!',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),

             const Divider(
              thickness: 1, // Ketebalan garis
              color: Colors.grey, // Warna garis
            ),
            const SizedBox(height: 20),

            // Dropdown untuk syarat dan ketentuan
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded; // Toggle dropdown
                });
              },
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Syarat dan Ketentuan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Icon(_isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  '1. Paket berlaku untuk pengguna baru.\n'
                  '2. Pembayaran harus dilakukan sebelum akhir bulan.\n'
                  '3. Tidak dapat digabung dengan promo lainnya.',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
