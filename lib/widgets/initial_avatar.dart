import 'package:flutter/material.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';

class InitialAvatar extends StatelessWidget {
  final String initial;
  final double size;

  /// true = warna pastel (dipakai di detail utasan & komentar)
  final bool pastel;

  const InitialAvatar({
    super.key,
    required this.initial,
    this.size = 38,
    this.pastel = false,
  });

  static const _pastels = [
    Color(0xFFF9DDE2), // pink
    Color(0xFFD9E8F5), // biru muda
    Color(0xFFFBE7C6), // kuning lembut
    Color(0xFFDDEFD9), // hijau lembut
  ];

  Color get _bg {
    if (!pastel) return AppColors.primary;
    final c = initial.toUpperCase();
    switch (c) {
      case 'K':
        return _pastels[0];
      case 'A':
        return _pastels[1];
      case 'T':
        return _pastels[2];
      default:
        return _pastels[c.codeUnitAt(0) % _pastels.length];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: _bg, shape: BoxShape.circle),
      child: Text(
        initial.toUpperCase(),
        style: TextStyle(
          color: pastel ? AppColors.maroon : Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.42,
        ),
      ),
    );
  }
}