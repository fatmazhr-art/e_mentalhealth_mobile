import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';

class OpsiJawaban extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const OpsiJawaban({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.maroon : AppColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 44,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: selected ? AppColors.white : AppColors.black,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}