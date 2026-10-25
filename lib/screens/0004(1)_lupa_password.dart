import 'package:flutter/material.dart';
import '../widgets/circle_back_button.dart';
import '../theme/app_colors.dart';
import '0004(2)_otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _kirimKodeOtp() {
    if (_formKey.currentState!.validate()) {
      // TODO: Panggil API untuk mengirim kode OTP ke email
      
      // Navigasi lanjut ke layar verifikasi OTP
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(
            email: _emailController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const kBgColor = Color(0xFFFFFBF5);
    const kCreamFill = Color(0xFFFFFDF9);
    final kBorderMaroon = AppColors.maroon.withAlpha(80);

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
              const SizedBox(height: 16),
              // ---------------- Header Title & Subtitle ----------------
              const Text(
                'Lupa Kata Sandi?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.maroon,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Masukkan email terdaftar kamu. Kami akan mengirimkan 6 digit kode OTP untuk memverifikasi akunmu.',
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.4,
                  color: AppColors.maroon.withAlpha(200),
                ),
              ),
              const SizedBox(height: 32),

              // ---------------- Input Field: Email ----------------
              const Text(
                'Email Terdaftar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.maroon,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF222222),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Contoh: nama@gmail.com',
                  hintStyle: TextStyle(
                    color: AppColors.maroon.withAlpha(100),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: kCreamFill,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: kBorderMaroon, width: 1.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.maroon,
                      width: 1.8,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.coral),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.coral,
                      width: 1.8,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // ---------------- Tombol Kirim Kode OTP ----------------
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _kirimKodeOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.maroon,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Kirim Kode OTP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}