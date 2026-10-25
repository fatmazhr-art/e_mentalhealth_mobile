import 'package:flutter/material.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';

/// Foto profil bulat dengan ikon pensil + teks "Ganti Foto Profil".
class ProfilePhotoEditor extends StatelessWidget {
  final VoidCallback onTap;
  const ProfilePhotoEditor({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            children: [
              // TODO: ganti Icon dengan foto asli (Image / NetworkImage)
              const CircleAvatar(
                radius: 54,
                backgroundColor: AppColors.softPink,
                child: Icon(Icons.person, size: 60, color: AppColors.primary),
              ),
              Positioned(
                right: 0,
                bottom: 2,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: AppColors.background, width: 3),
                  ),
                  child: const Icon(Icons.edit, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Ganti Foto Profil',
              style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary)),
        ],
      ),
    );
  }
}