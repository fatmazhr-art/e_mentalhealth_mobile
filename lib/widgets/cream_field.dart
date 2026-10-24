import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';

class CreamField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool enabled;
  final TextInputType? keyboardType;

  const CreamField({
    required this.controller,
    required this.hint,
    this.enabled = true,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5, // redup saat disabled (mode anonim)
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(fontSize: 13, color: AppColors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.hint),
          filled: true,
          fillColor: AppColors.cream,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                const BorderSide(color: AppColors.maroon, width: 1.2),
          ),
        ),
      ),
    );
  }
}