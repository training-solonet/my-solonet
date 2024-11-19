import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          height: 200,
          width: 200,
          child: Lottie.asset(
            'assets/loading/loading.json',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}