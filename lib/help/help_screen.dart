import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mysolonet/detail/help/nearest_service_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              _buildHelpCard(
                  'assets/images/1.png', 'Setel Ulang Modem', 0, () {}),
              _buildHelpCard(
                  'assets/images/2.png', 'Lihat Pertanyaan', 1, () {}),
              _buildHelpCard('assets/images/3.png', 'Pengaduan Layanan', 2, () {
                _launchWhatsApp('+6281542017888');
              }),
              _buildHelpCard('assets/images/4.png', 'Cari SoloNet Terdekat', 3,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NearestServiceScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final url = 'https://wa.me/$phoneNumber'; // Format WhatsApp API link
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildHelpCard(
      String imagePath, String buttonText, int index, VoidCallback onPress) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              height: 190,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 10,
            left: index % 2 == 0 ? 20 : null,
            right: index % 2 != 0 ? 20 : null,
            child: ElevatedButton(
              onPressed: onPress,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
