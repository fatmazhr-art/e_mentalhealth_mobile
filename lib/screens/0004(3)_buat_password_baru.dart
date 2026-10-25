import 'package:flutter/material.dart';
import '../widgets/circle_back_button.dart';
import '../theme/app_colors.dart';
import '../models/password_rules.dart';
import '../widgets/strength_bar.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newC = TextEditingController();
  final _confirmC = TextEditingController();

  // Visibilitas password (true = tersembunyi)
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _newC.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _newC.dispose();
    _confirmC.dispose();
    super.dispose();
  }

  // Tanpa pengecekan password lama
  PasswordRules get _rules => PasswordRules.check(_newC.text, '');

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  void _save() {
    if (_newC.text.isEmpty) {
      _snack('Isi password baru dulu ya');
      return;
    }
    if (!_rules.minLength || !_rules.complexity) {
      _snack('Password baru belum memenuhi semua syarat');
      return;
    }
    if (_confirmC.text != _newC.text) {
      _snack('Konfirmasi password tidak sama');
      return;
    }

    // 1. TODO: Panggil API Reset Password ke backend
    
    // 2. Tampilkan notifikasi sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password berhasil diperbarui! Silakan login kembali.'),
        backgroundColor: AppColors.maroon,
      ),
    );

    // 3. Kembalikan pengguna ke layar paling awal (LoginScreen)
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final rules = _rules;
    const kBgColor = Color(0xFFFFFBF5);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Center(
            child: CircleBackButton(
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- Header Title & Subtitle ----------------
                const Center(
                  child: Text(
                    'Buat Password Baru',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.maroon,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Pastikan kata sandi baru Anda kuat, unik, dan belum pernah digunakan untuk menjaga kerahasiaan ruang konseling pribadi Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.4,
                    color: AppColors.maroon.withAlpha(200),
                  ),
                ),
                const SizedBox(height: 28),

                // ---------------- Password Baru + Indikator ----------------
                _buildInputField(
                  label: 'Password baru',
                  hint: 'Masukkan password baru',
                  controller: _newC,
                  obscureText: _obscureNew,
                  onToggleObscure: () =>
                      setState(() => _obscureNew = !_obscureNew),
                ),
                const SizedBox(height: 12),
                StrengthBar(score: rules.score),
                const SizedBox(height: 12),

                // Indikator Syarat Password (Tanpa "Berbeda dari password lama")
                _buildRuleItem(ok: rules.minLength, text: 'Minimal 8 karakter'),
                const SizedBox(height: 6),
                _buildRuleItem(
                  ok: rules.complexity,
                  text: 'Ada huruf besar, angka, karakter spesial',
                ),
                const SizedBox(height: 24),

                // ---------------- Konfirmasi Password ----------------
                _buildInputField(
                  label: 'Konfirmasi password baru',
                  hint: 'Ulangi password baru',
                  controller: _confirmC,
                  obscureText: _obscureConfirm,
                  onToggleObscure: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
                const SizedBox(height: 32),

                // ---------------- Tombol Simpan Password ----------------
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.maroon,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Simpan Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ---------------- Tombol Batal ----------------
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => Navigator.maybePop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.maroon,
                      backgroundColor: const Color(0xFFFFFDF9),
                      side: BorderSide(
                        color: AppColors.maroon.withAlpha(80),
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Input Field
  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleObscure,
  }) {
    const kCreamFill = Color(0xFFFFFDF9);
    final kBorderMaroon = AppColors.maroon.withAlpha(80);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.maroon,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF222222),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.maroon.withAlpha(100),
              fontSize: 14,
            ),
            filled: true,
            fillColor: kCreamFill,
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.maroon.withAlpha(150),
                size: 22,
              ),
              onPressed: onToggleObscure,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: kBorderMaroon, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.maroon, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  // Helper Item Kriteria Password
  Widget _buildRuleItem({required bool ok, required String text}) {
    return Row(
      children: [
        Icon(
          ok ? Icons.check_circle : Icons.check_circle_outline,
          size: 18,
          color: ok ? AppColors.maroon : AppColors.maroon.withAlpha(120),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.5,
            color: ok ? AppColors.maroon : AppColors.maroon.withAlpha(160),
            fontWeight: ok ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}