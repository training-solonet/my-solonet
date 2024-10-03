import 'package:flutter/material.dart';

void showSuccessMessage(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Row(
      mainAxisSize: MainAxisSize.min, // Sesuaikan panjang row dengan konten
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle,  // Menggunakan ikon checklist
          color: Colors.white,  // Warna putih untuk ikon
          size: 20,  // Ukuran ikon
        ),
        const SizedBox(width: 10), // Jarak antara ikon dan teks
        Text(
          message, // Respon dari API
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating, // Membuat SnackBar mengambang
    margin: const EdgeInsets.only(
      bottom: 40.0,
      left: 20.0,
      right: 20.0, // Atur jarak dari bawah
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30), // Memberikan border radius
    ),
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
    duration: const Duration(seconds: 3), // Durasi tampil SnackBar
  );

  // Menampilkan SnackBar
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
