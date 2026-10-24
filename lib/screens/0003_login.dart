import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '0002_register_akun.dart';
import '0004_reset_password.dart';

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
      // TODO: ganti dengan pemanggilan API Laravel
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Validasi berhasil (belum terhubung API)')),
      );
    }
  }

  InputDecoration _dekorasi(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.hint),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.coral),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.coral),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFFCFAF8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          // Tombol kembali
                          IconButton(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                            icon: const Icon(Icons.arrow_back,
                                color: AppColors.maroon),
                            onPressed: () => Navigator.maybePop(context),
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'Selamat datang kembali!',
                            style: TextStyle(
                              color: AppColors.maroon,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Masuk untuk melanjutkan perjalananmu\nbersama E-Mental Health.',
                            style: TextStyle(
                              color: AppColors.maroon,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Email / username
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _dekorasi('Email/username'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email/username wajib diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          // Password
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _sembunyikanPassword,
                            decoration: _dekorasi(
                              'Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _sembunyikanPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.hint,
                                ),
                                onPressed: () => setState(() =>
                                    _sembunyikanPassword =
                                        !_sembunyikanPassword),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password wajib diisi';
                              }
                              return null;
                            },
                          ),
                          // Lupa password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ResetPasswordScreen(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.maroon,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Lupa Password?',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Lanjut sebagai anonim
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                // TODO: masuk sebagai anonim
                              },
                              child: const Text(
                                'Atau lanjutkan sebagai anonim',
                                style: TextStyle(
                                  color: AppColors.maroon,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Tombol masuk
                          Center(
                            child: SizedBox(
                              width: 190,
                              height: 48,
                              child: FilledButton(
                                onPressed: _login,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.maroon,
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Daftar
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text.rich(
                                TextSpan(
                                  text: 'Belum punya akun? ',
                                  children: [
                                    TextSpan(
                                      text: 'Daftar disini',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                style: TextStyle(
                                  color: AppColors.maroon,
                                  fontSize: 13,
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
              ),
            );
          },
        ),
      ),
    );
  }
}