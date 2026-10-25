import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/circle_back_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiController = TextEditingController();
  
  bool _sembunyikanPassword = true;
  bool _sembunyikanKonfirmasi = true;
  bool _setuju = false;
  bool _setujuError = false;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  void _daftar() {
    final formValid = _formKey.currentState!.validate();
    setState(() => _setujuError = !_setuju);

    if (formValid && _setuju) {
      // TODO: ganti dengan pemanggilan API Laravel (registrasi)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Validasi berhasil! Akun Anda siap dibuat.'),
          backgroundColor: AppColors.maroon,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- Header Title & Subtitle ----------------
              const Center(
                child: Text(
                  'Buat Akun Baru',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.maroon,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Mulai perjalananmu untuk lebih memahami dan menjaga kesehatan mentalmu.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.4,
                  color: AppColors.maroon.withAlpha(200),
                ),
              ),
              const SizedBox(height: 28),

              // ---------------- Field: Nama Lengkap ----------------
              _buildInputField(
                label: 'Nama Lengkap',
                hint: 'Masukkan nama lengkap',
                controller: _namaController,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama lengkap wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              // ---------------- Field: Email ----------------
              _buildInputField(
                label: 'Email',
                hint: 'Masukkan email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email wajib diisi';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              // ---------------- Field: Kata Sandi ----------------
              _buildInputField(
                label: 'Kata Sandi',
                hint: 'Masukkan kata sandi',
                controller: _passwordController,
                obscureText: _sembunyikanPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _sembunyikanPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.maroon.withAlpha(150),
                    size: 22,
                  ),
                  onPressed: () => setState(
                      () => _sembunyikanPassword = !_sembunyikanPassword),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kata sandi wajib diisi';
                  }
                  if (value.length < 8) {
                    return 'Kata sandi minimal 8 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              // ---------------- Field: Konfirmasi Kata Sandi ----------------
              _buildInputField(
                label: 'Konfirmasi Kata Sandi',
                hint: 'Ulangi kata sandi',
                controller: _konfirmasiController,
                obscureText: _sembunyikanKonfirmasi,
                suffixIcon: IconButton(
                  icon: Icon(
                    _sembunyikanKonfirmasi
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.maroon.withAlpha(150),
                    size: 22,
                  ),
                  onPressed: () => setState(
                      () => _sembunyikanKonfirmasi = !_sembunyikanKonfirmasi),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi kata sandi wajib diisi';
                  }
                  if (value != _passwordController.text) {
                    return 'Kata sandi tidak sama';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ---------------- Checkbox Syarat & Privasi ----------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _setuju,
                      activeColor: AppColors.maroon,
                      side: BorderSide(
                        color: _setujuError
                            ? AppColors.coral
                            : AppColors.maroon.withAlpha(150),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (nilai) => setState(() {
                        _setuju = nilai ?? false;
                        if (_setuju) _setujuError = false;
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Saya setuju dengan ',
                        style: TextStyle(color: AppColors.maroon, fontSize: 12.5),
                        children: [
                          TextSpan(
                            text: 'Syarat & Privasi',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (_setujuError)
                const Padding(
                  padding: EdgeInsets.only(top: 6, left: 34),
                  child: Text(
                    'Kamu harus menyetujui Syarat & Privasi',
                    style: TextStyle(
                      color: AppColors.coral,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const SizedBox(height: 28),

              // ---------------- Tombol Daftar ----------------
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _daftar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.maroon,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ---------------- Footer Navigasi Masuk ----------------
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Text.rich(
                    TextSpan(
                      text: 'Sudah punya akun? ',
                      style: TextStyle(
                        color: AppColors.maroon.withAlpha(200),
                        fontSize: 13.5,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Masuk disini',
                          style: TextStyle(
                            color: AppColors.maroon,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Custom Field dengan Label Maroon & Border Maroon Halus
  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Widget? suffixIcon,
    String? Function(String?)? validator,
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
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          validator: validator,
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
            suffixIcon: suffixIcon,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.coral),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.coral, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }
}