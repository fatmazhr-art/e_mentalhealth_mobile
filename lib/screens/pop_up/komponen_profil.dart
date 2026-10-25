import 'package:flutter/material.dart';
import '../../widgets/circle_back_button.dart';

import '../../theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────
// Design tokens modul Profil
// ─────────────────────────────────────────────────────────────
const Color kProfilLatar = Color(0xFFFFFBF5);
const Color kProfilKartu = Color(0xFFFFF8F0);
const Color kProfilPink = Color(0xFFFEEAE6);
const Color kProfilGaris = Color(0xFFEBD9C6);
const Color kProfilTeksGelap = Color(0xFF222222);
const Color kProfilTeksAbu = Color(0xFF888888);

// ─────────────────────────────────────────────────────────────
// Model data profil
// ─────────────────────────────────────────────────────────────
class ProfilData {
  final String nama;
  final String nim;
  final String email;
  final String noHp;

  const ProfilData({
    required this.nama,
    required this.nim,
    required this.email,
    required this.noHp,
  });

  ProfilData copyWith({String? nama, String? email, String? noHp}) =>
      ProfilData(
        nama: nama ?? this.nama,
        nim: nim,
        email: email ?? this.email,
        noHp: noHp ?? this.noHp,
      );
}

// ─────────────────────────────────────────────────────────────
// Top bar (back maroon + judul tengah)
// ─────────────────────────────────────────────────────────────
class ProfilTopBar extends StatelessWidget {
  final String judul;
  const ProfilTopBar({super.key, required this.judul});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: [
          const CircleBackButton(),
          Expanded(
            child: Text(
              judul,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: kProfilTeksGelap,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 40), // penyeimbang agar judul di tengah
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Field input dengan label di atas
// ─────────────────────────────────────────────────────────────
class ProfilField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool enabled;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final String? helper;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const ProfilField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.enabled = true,
    this.obscureText = false,
    this.prefixIcon,
    this.suffix,
    this.helper,
    this.keyboardType,
    this.validator,
    this.onChanged,
  });

  OutlineInputBorder _border(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: c, width: w),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: kProfilTeksGelap,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          style: TextStyle(
            color: enabled ? kProfilTeksGelap : kProfilTeksAbu,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: kProfilTeksAbu),
            filled: true,
            fillColor: enabled ? kProfilKartu : const Color(0xFFF1ECE6),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, color: kProfilTeksAbu, size: 20),
            suffixIcon: suffix,
            enabledBorder: _border(kProfilGaris),
            disabledBorder: _border(kProfilGaris),
            focusedBorder: _border(AppColors.maroon, 1.6),
            errorBorder: _border(Colors.red.shade700),
            focusedErrorBorder: _border(Colors.red.shade700, 1.6),
          ),
        ),
        if (helper != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              helper!,
              style: const TextStyle(color: kProfilTeksAbu, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Tombol aksi
// ─────────────────────────────────────────────────────────────
class TombolUtama extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const TombolUtama({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.maroon,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class TombolBatal extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const TombolBatal({super.key, this.label = 'Batal', required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: kProfilKartu,
          foregroundColor: AppColors.maroon,
          side: const BorderSide(color: kProfilGaris),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Avatar (foto profil, fallback ikon)
// ─────────────────────────────────────────────────────────────
class ProfilAvatar extends StatelessWidget {
  final double ukuran;
  const ProfilAvatar({super.key, this.ukuran = 104});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ukuran,
      height: ukuran,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kProfilPink,
        border: Border.all(color: AppColors.maroon, width: 3),
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/avatar.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.person,
            color: AppColors.maroon,
            size: ukuran * 0.55,
          ),
        ),
      ),
    );
  }
}