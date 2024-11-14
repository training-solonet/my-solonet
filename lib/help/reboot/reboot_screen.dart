import 'package:flutter/material.dart';

class RebootScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF8CA2F8), 
      appBar: AppBar(
        title: const Text('Gangguan Koneksi', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
        backgroundColor: const Color(0xFF8CA2F8),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomRebootCard(
                title: 'INTERNET LEMOT, WI-FI TIDAK CONNECT SINYAL PUTUS-PUTUS?',
                icon: Icons.wifi_off_rounded,
                iconColor: Colors.white,
                iconSize: 200.0,
                iconPosition: IconPosition.center,
                description:
                    'Lakukan reboot wifi mandiri, dengan mengikuti langkah-langkah berikut',
                buttonText: 'Next',
                onButtonPressed: () {
                  
                }
              )
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
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final IconPosition iconPosition;
  final String description;
  final String buttonText;
  final VoidCallback onButtonPressed;

  CustomRebootCard({
    required this.title,
    this.titleAlign = TextAlign.center,
    required this.icon,
    this.iconColor = Colors.redAccent,
    this.iconSize = 100.0,
    this.iconPosition = IconPosition.center,
    required this.description,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            if (iconPosition == IconPosition.left || iconPosition == IconPosition.right)
              Row(
                mainAxisAlignment: iconPosition == IconPosition.left
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: [
                  Icon(
                    icon,
                    color: iconColor,
                    size: iconSize,
                  ),
                ],
              )
            else
              Center(
                child: Icon(
                  icon,
                  color: iconColor,
                  size: iconSize,
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
    );
  }
}

enum IconPosition {
  left,
  right,
  center,
}
