import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'screens/auth/0001_on_boarding.dart';

void main() {
  runApp(const CurhatinApp());
}

class CurhatinApp extends StatelessWidget {
  const CurhatinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CURHATIN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFCFAF8),
        primaryColor: AppColors.maroon,
        fontFamily: 'Poppins',
      ),
      // Pintu masuk utama: Splash Screen -> Onboarding Screen -> Login
      home: const OnboardingScreen(),
    );
  }
}