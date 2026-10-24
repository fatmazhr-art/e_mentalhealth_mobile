import 'package:flutter/material.dart';

/// Palet warna bersama untuk seluruh aplikasi Curhatin.
/// Simpan di: lib/theme/app_colors.dart
class AppColors {
  // ===== Warna lama (onboarding, login, register, dll) =====
  static const Color cream = Color(0xFFF5E6D3);
  static const Color maroon = Color(0xFF7D0020);
  static const Color coral = Color(0xFFD6525E);
  static const Color hint = Color(0xFF757575);

  // ===== Forum & asesmen =====
  static const Color primary = maroon; // alias, mengikuti maroon lama
  static const Color background = Color(0xFFFFFBF5);
  static const Color card = Color(0xFFFFF8F0);
  static const Color border = Color(0xFFEBD5CC);
  static const Color cardBorder = Color(0xFFE8A9B5);
  static const Color softPink = Color(0xFFF9DDE2);
  static const Color tag = Color(0xFFC45B6E);
  static const Color text = Color(0xFF222222);
  static const Color muted = Color(0xFF888888);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // ===== Lupa password (BARU) =====
  static const Color fieldPink = Color(0xFFFEEAE6);
  static const Color mutedMaroon = Color(0xFF800020);
  static const Color success = Color(0xFF3C9A5F);
  static const Color warning = Color(0xFFE0A030);
}