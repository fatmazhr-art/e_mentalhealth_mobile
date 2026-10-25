import 'package:flutter/material.dart';
import '../widgets/circle_back_button.dart';
import '../theme/app_colors.dart';
import '0002_register_akun.dart';
import '0004(1)_lupa_password.dart';
import '0006_assesmen.dart';
import '0005_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _sembunyikanPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // TODO: Panggil API login backend di sini nanti

      // Tampilkan feedback SnackBar singkat
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login berhasil! Selamat datang kembali.'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigasi langsung ke Dashboard dan timpa layar login (pushReplacement)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeMahasiswaScreen(),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ---------------- Header Title & Subtitle ----------------
              const Text(
                'Selamat Datang Kembali',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.maroon,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Masuk untuk melanjutkan perjalananmu bersama E-Mental Health.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.4,
                  color: AppColors.maroon.withAlpha(200),
                ),
              ),
              const SizedBox(height: 28),

              // ---------------- Input Field: Email / Username ----------------
              _buildInputField(
                label: 'Email / Username',
                hint: 'Masukkan email atau username',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email/username wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              // ---------------- Input Field: Password ----------------
              _buildInputField(
                label: 'Password',
                hint: 'Masukkan password',
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
                  onPressed: () =>
                      setState(() => _sembunyikanPassword = !_sembunyikanPassword),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password wajib diisi';
                  }
                  return null;
                },
              ),

              // ---------------- Lupa Password ----------------
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.maroon,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Lupa Password?',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ---------------- Tombol Masuk Utama ----------------
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.maroon,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ---------------- Opsi Lanjutkan Sebagai Anonim ----------------
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AsesmenScreen(),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Atau lanjutkan sebagai anonim',
                    style: TextStyle(
                      color: AppColors.maroon,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // ---------------- Footer Register Text ----------------
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RegisterScreen(),
                    ),
                  );
                },
                child: Text.rich(
                  TextSpan(
                    text: 'Belum punya akun? ',
                    style: TextStyle(
                      color: AppColors.maroon.withAlpha(200),
                      fontSize: 13.5,
                    ),
                    children: const [
                      TextSpan(
                        text: 'Daftar disini',
                        style: TextStyle(
                          color: AppColors.maroon,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Custom Field dengan Label Maroon di Atas & Border Maroon Halus
  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType? keyboardType,
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