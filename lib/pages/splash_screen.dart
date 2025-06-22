import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_app/pages/onboarding_screen.dart';
import 'package:lottie/lottie.dart';

const Color primaryColor = Colors.white;
const Color textColor = Colors.black;

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Lottie.asset(
            'assets/lottie/Animation - 1736691275981.json',
            fit: BoxFit.contain,
          ),
          Text(
            'ShareBites',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w600,
              fontFamily: "Poppins",
              color: textColor,
              letterSpacing: 10,
            ),
          )
        ],
      ),
      nextScreen: OnboardingScreen(),
      splashIconSize: 500,
      splashTransition: SplashTransition.scaleTransition,
      backgroundColor: primaryColor,
    );
  }
}