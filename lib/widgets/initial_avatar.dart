import 'package:flutter/material.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';

class InitialAvatar extends StatelessWidget {
  final String initial;
  final double size;
  const InitialAvatar({required this.initial, this.size = 38});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: AppColors.primary, shape: BoxShape.circle),
      child: Text(initial.toUpperCase(),
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: size * 0.42)),
    );
  }
}