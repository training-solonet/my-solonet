import 'package:flutter/material.dart';

class InstallationInfoSection extends StatelessWidget {
  final VoidCallback? onClose;

  const InstallationInfoSection({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 48, 157, 69),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informasi Pemasangan',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Pemasangan layanan Anda akan dilakukan pada tanggal:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '1 Desember 2024',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Anda akan mendapatkan trial selama 3 hari untuk menikmati layanan ini.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Hubungi kami untuk informasi lebih lanjut:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: 17,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '0815-4201-7888',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.email,
                    color: Colors.white,
                    size: 17,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'solonet@solonet.net.id',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: -15,
            right: -10,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: onClose,
            ),
          ),
        ],
      ),
    );
  }
}
