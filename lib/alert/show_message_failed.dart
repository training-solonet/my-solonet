import 'package:flutter/material.dart';

void showFailedMessage(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_rounded, // Menggunakan ikon checklist
          color: Colors.white, // Warna putih untuk ikon
          size: 20, // Ukuran ikon
        ),
        const SizedBox(width: 10), // Jarak antara ikon dan teks
        Text(
          message,
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
    backgroundColor: Colors.red,
    behavior: SnackBarBehavior.floating, // Membuat SnackBar mengambang
    margin: const EdgeInsets.only(
      bottom: 40.0, // Atur jarak dari bawah
      left: 90.0, //atur sebelah kiri
      right: 90.0, //atur sebelah kanan
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30), // Memberikan border radius
    ),
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
    duration: const Duration(seconds: 3), // Durasi tampil SnackBar
  );

  // Menampilkan SnackBar
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
