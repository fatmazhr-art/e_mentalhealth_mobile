import 'package:flutter/material.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';

/// 3 segmen kekuatan password: merah -> kuning -> hijau
class StrengthBar extends StatelessWidget {
  final int score; // 0..3
  const StrengthBar({required this.score});

  Color get _activeColor {
    if (score >= 3) return AppColors.success;
    if (score == 2) return AppColors.warning;
    return AppColors.coral;
  }

  String get _label {
    if (score >= 3) return 'Kuat';
    if (score == 2) return 'Sedang';
    return 'Lemah';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(3, (i) {
            return Expanded(
              child: Container(
                height: 5,
                margin: EdgeInsets.only(right: i == 2 ? 0 : 6),
                decoration: BoxDecoration(
                  color: i < score ? _activeColor : AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        if (score > 0) ...[
          const SizedBox(height: 4),
          Text('Kekuatan: $_label',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _activeColor)),
        ],
      ],
    );
  }
}