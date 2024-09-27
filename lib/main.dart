import 'package:flutter/material.dart';
import 'package:mysolonet/home/splash/splash_screen.dart';
import 'constants.dart'; // Update dengan path yang benar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Solonet',
      theme: ThemeData(
        fontFamily: 'Poppins',
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(), // Pastikan ini adalah SplashScreen yang diperbarui
    );
  }
}
