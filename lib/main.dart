import 'package:flutter/material.dart';

import 'screens/0001_on_boarding.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curhatin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.maroon),
        scaffoldBackgroundColor: AppColors.cream,
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}