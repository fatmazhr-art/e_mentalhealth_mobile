import 'package:flutter/material.dart';
import '../services/auth_storage.dart';
import '../theme.dart';
import 'konselor_chat_screen.dart';
import 'konselor_login_screen.dart';

// Background terang (sama dengan onboarding lama). Cocokkan hex dengan Figma.
const Color _kBackgroundLight = Color(0xFFFBF7F4);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(seconds: 2)); // lama splash
    final loggedIn = await AuthStorage.isLoggedIn();
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
        loggedIn ? const KonselorChatScreen() : const KonselorLoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: _kBackgroundLight,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _BlobPainter()),
          ),
          Center(
            child: Image.asset('assets/images/logo.png', width: width * 0.42),
          ),
        ],
      ),
    );
  }
}

class _BlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final pink = Paint()..color = kAccent;
    final maroon = Paint()..color = kPrimary;

    // Cincin marun kiri atas
    final ring = Paint()
      ..color = kPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.115;
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.365, 0)
        ..cubicTo(w * 0.29, h * 0.07, w * 0.14, h * 0.14, 0, h * 0.15),
      ring,
    );

    // Blob pink kanan atas
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.727, 0)
        ..cubicTo(w * 0.76, h * 0.08, w * 0.88, h * 0.095, w, h * 0.093)
        ..lineTo(w, 0)
        ..close(),
      pink,
    );

    // Blob pink kiri bawah
    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.88)
        ..cubicTo(w * 0.12, h * 0.84, w * 0.40, h * 0.82, w * 0.58, h * 0.90)
        ..cubicTo(w * 0.66, h * 0.94, w * 0.75, h * 0.97, w * 0.90, h)
        ..lineTo(0, h)
        ..close(),
      pink,
    );

    // Blob marun kanan bawah (digambar setelah pink, jadi menimpa)
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.64, h * 0.94)
        ..cubicTo(w * 0.68, h * 0.90, w * 0.74, h * 0.875, w * 0.80, h * 0.876)
        ..cubicTo(w * 0.88, h * 0.88, w * 0.95, h * 0.87, w, h * 0.85)
        ..lineTo(w, h)
        ..lineTo(w * 0.88, h)
        ..cubicTo(w * 0.78, h * 0.98, w * 0.70, h * 0.96, w * 0.64, h * 0.94)
        ..close(),
      maroon,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}