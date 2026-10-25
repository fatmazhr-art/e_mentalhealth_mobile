import 'package:flutter/material.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';

/// Label + kolom isian untuk form profil.
class ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final Widget? suffixIcon;
  final String? helper; // keterangan kecil di bawah kolom
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLength;
  final Color fillColor;
  final Color borderColor;

  const ProfileField({
    super.key,
    required this.label,
    required this.controller,
    this.enabled = true,
    this.suffixIcon,
    this.helper,
    this.keyboardType,
    this.validator,
    this.maxLength,
    this.fillColor = AppColors.card,
    this.borderColor = AppColors.border,
  });

  OutlineInputBorder _border(Color c, double w) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: c, width: w),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.text)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          validator: validator,
          maxLength: maxLength,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          cursorColor: AppColors.primary,
          style: TextStyle(
              fontSize: 15,
              color: enabled ? AppColors.text : AppColors.muted),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: enabled ? fillColor : AppColors.cream,
            suffixIcon: suffixIcon,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            enabledBorder: _border(borderColor, 1),
            disabledBorder: _border(AppColors.cream, 1),
            focusedBorder: _border(AppColors.primary, 1.6),
            errorBorder: _border(AppColors.coral, 1.2),
            focusedErrorBorder: _border(AppColors.coral, 1.6),
          ),
        ),
        if (helper != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(helper!,
                style: const TextStyle(fontSize: 11.5, color: AppColors.muted)),
          ),
        ],
      ],
    );
  }
}