import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/home/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  get splash => null;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(children: [
        Center(
          child: LottieBuilder.asset("assets/Animation - 1727243852673.json"),
        )
      ]),
      nextScreen: SignInScreen(),
      splashIconSize: 400,
      backgroundColor: Colors.white,
    );
  }
}
