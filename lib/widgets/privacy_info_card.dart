import 'package:flutter/material.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';

/// Kartu info privasi (pink muda dengan ikon perisai).
class PrivacyInfoCard extends StatelessWidget {
  const PrivacyInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.fieldPink,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, size: 22, color: AppColors.primary),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Data pribadi kamu terlindungi enkripsi end-to-end. Curhatin menjamin kerahasiaan identitas dalam setiap sesi konseling.',
              style: TextStyle(
                  fontSize: 12.5, height: 1.45, color: AppColors.mutedMaroon),
            ),
          ),
        ],
      ),
    );
  }
}