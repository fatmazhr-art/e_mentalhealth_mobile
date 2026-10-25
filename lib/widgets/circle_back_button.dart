import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CircleBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;

  const CircleBackButton({
    super.key,
    this.onPressed,
    this.size = 32.0,
    this.iconSize = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      widthFactor: 1.0,
      heightFactor: 1.0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed ?? () => Navigator.maybePop(context),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.maroon, // Warna outline maroon
              width: 2.0,
            ),
          ),
          child: Icon(
            Icons.arrow_back,
            color: AppColors.maroon,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}

