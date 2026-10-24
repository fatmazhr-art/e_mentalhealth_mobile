import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 32, color: AppColors.maroon),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}