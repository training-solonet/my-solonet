import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RebootScreen extends StatefulWidget {
  @override
  _RebootScreenState createState() => _RebootScreenState();
}

class _RebootScreenState extends State<RebootScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _goToNextPage() {
    if (_currentIndex < 3) { // Since we have 3 slides (index 0, 1, 2)
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final url = 'whatsapp://send?phone=$phoneNumber';
    try {
      launch(url);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF8CA2F8),
      appBar: AppBar(
        title: const Text(
          'Gangguan Koneksi',
          style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF8CA2F8),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              CustomRebootCard(
                title: 'INTERNET LEMOT, WI-FI TIDAK CONNECT SINYAL PUTUS-PUTUS?',
                iconPath: 'assets/images/iconslide1.png',
                description: '“Lakukan reboot router wifi mandiri, dengan mengikuti langkah - langkah berikut” ',
                buttonText: 'Next',
                onButtonPressed: _goToNextPage,
              ),
              CustomRebootCard(
                title: 'Cabut Kabel LAN atau Kabel FO',
                iconPath: 'assets/images/iconslide2.png',
                description: 
                    'Jika ada kabel LAN (biasanya berwarna biru atau putih, dengan konektor RJ45), cabut kabel ini dari port di router.\n\n'
                    'Jika ada kabel Fiber Optik (FO), cabut kabel ini dengan hati-hati dari port. Pastikan tidak menarik kabel terlalu keras agar tidak merusak konektor.\n\n'
                    'Setelah menunggu, colokkan kembali kabel LAN atau FO ke port yang sesuai di router.',
                buttonText: 'Next',
                onButtonPressed: _goToNextPage,
              ),
              CustomRebootCard(
                title: 'Cabut Kabel Listrik atau adaptor router wifi',
                iconPath: 'assets/images/iconslide3.png',
                description: 'Tunggu sekitar 10-30 detik lalu hubungkan kembali kabel atau adaptor tersebut dan tunggu hingga lampu indikator router menyala secara normal lalu coba kembali internet anda.',
                buttonText: 'Next',
                onButtonPressed: _goToNextPage,
              ),
              CustomRebootCard(
                title: 'Hubungi customer support kami',
                iconPath: 'assets/images/iconslide4.png',
                description: 'Jika semua langkah di slide sebelumnya sudah dilakukan\nmasih juga terjadi error\nSilahkan',
                buttonText: 'Hubungi Kami',
                onButtonPressed: () {
                  _launchWhatsApp('6281542017888');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomRebootCard extends StatelessWidget {
  final String title;
  final TextAlign titleAlign;
  final String iconPath;
  final String description;
  final String buttonText;
  final VoidCallback onButtonPressed;

  CustomRebootCard({
    required this.title,
    this.titleAlign = TextAlign.center,
    required this.iconPath,
    required this.description,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(  // Wrap the Column with SingleChildScrollView
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                textAlign: titleAlign,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Color(0xFF8CA2F8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum IconPosition {
  left,
  right,
  center,
}
