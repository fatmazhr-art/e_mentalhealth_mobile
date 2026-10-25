import 'package:flutter/material.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';

/// Kartu pengingat: detail hasil hanya untuk pengguna yang sudah daftar.
class LockedDetailCard extends StatelessWidget {
  const LockedDetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.fieldPink,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline, size: 24, color: AppColors.primary),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Detail hasil dikunci',
                    style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary)),
                SizedBox(height: 4),
                Text(
                  'Skor lengkap, penjelasan tiap aspek, dan saran tindak lanjut hanya tersedia untuk akun terdaftar. Daftar dulu, hasil asesmenmu bisa kamu lihat kapan saja.',
                  style: TextStyle(
                      fontSize: 12.5,
                      height: 1.45,
                      color: AppColors.mutedMaroon),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}