import 'package:flutter/material.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';

class RuleItem extends StatelessWidget {
  final bool ok;
  final String text;
  const RuleItem({required this.ok, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(ok ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 17, color: ok ? AppColors.success : AppColors.muted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 12.5,
                    color: ok ? AppColors.text : AppColors.muted)),
          ),
        ],
      ),
    );
  }
}