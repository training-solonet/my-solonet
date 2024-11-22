import 'package:flutter/material.dart';
import 'package:mysolonet/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mysolonet/splash/splash_slide.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _showSplashScreen();
  }

  Future<void> _showSplashScreen() async {
    // Tambahkan durasi 3 detik
    await Future.delayed(const Duration(seconds: 1));
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      // Jika ini adalah peluncuran pertama, navigasi ke SplashSlide
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashSlide()),
      );
    } else {
      // Jika bukan peluncuran pertama, navigasi ke halaman utama
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()), // Ganti dengan layar utama Anda
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF27B2D1), // Latar belakang biru
      body: Center(
        child: Image.asset(
          'assets/images/solonet_logo.png', // Gambar logo Anda
          height: 200, // Sesuaikan ukuran logo sesuai kebutuhan
          width: 200,
        ),
      ),
    );
  }
}
