import 'package:flutter/material.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';
import 'package:e_mentalhealth_mobile/models/hasil_asesmen.dart';

/// Kartu hasil satu aspek: nama, label tingkat, dan (opsional) bar + skor.
/// [showDetail] = false untuk mode tamu (hanya nama dan tingkat).
class SkorCard extends StatelessWidget {
  final SubskalaHasil data;
  final bool showDetail;
  const SkorCard({super.key, required this.data, this.showDetail = true});

  static const int _skorMaks = 42;

  Color get _warna {
    switch (data.tingkat) {
      case 'Normal':
        return AppColors.success;
      case 'Ringan':
        return AppColors.warning;
      case 'Sedang':
        return AppColors.coral;
      default: // Berat, Sangat Berat
        return AppColors.maroon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (data.skor / _skorMaks).clamp(0.0, 1.0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.nama,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _warna,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data.tingkat,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          if (showDetail) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(_warna),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Skor ${data.skor} dari $_skorMaks',
              style: const TextStyle(fontSize: 12, color: AppColors.muted),
            ),
          ],
        ],
      ),
    );
  }
}