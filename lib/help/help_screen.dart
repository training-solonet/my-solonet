import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bantuan',
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
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHelpCard('assets/images/1.png'),
              _buildHelpCard('assets/images/2.png'),
              _buildHelpCard('assets/images/3.png'),
              _buildHelpCard('assets/images/4.png'),
              _buildHelpCard('assets/images/5.jpg'),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk card bantuan
  Widget _buildHelpCard(String imagePath) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // Membuat gambar mengikuti bentuk card
        child: Image.asset(
          imagePath,
          height: 190, // Ukuran gambar lebih kecil
          width: double.infinity,
          fit: BoxFit.cover, // Gambar akan menyesuaikan card secara proporsional
        ),
      ),
    );
  }
}
