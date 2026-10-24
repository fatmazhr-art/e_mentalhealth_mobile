import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';

// Pintu masuk app KONSELOR (sementara, sampai role dari server tersedia).
// Jalankan dengan: flutter run -t lib/main_konselor.dart
void main() {
  runApp(const KonselorApp());
}

class KonselorApp extends StatelessWidget {
  const KonselorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CURHATIN Konselor',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const SplashScreen(),
    );
  }
}