import 'package:flutter/material.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';
import 'package:e_mentalhealth_mobile/services/forum_dummy_data.dart';

class LockBanner extends StatelessWidget {
  const LockBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.softPink.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.lock_outline, size: 18, color: AppColors.primary),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Utasanmu otomatis menggunakan nama samaran $kMyAlias.',
              style: TextStyle(fontSize: 12, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}