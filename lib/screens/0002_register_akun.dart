import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

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
        const SnackBar(content: Text('Validasi berhasil (belum terhubung API)')),
      );
    }
  }

  InputDecoration _dekorasi(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.hint, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
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
                          const SizedBox(height: 36),
                          const Text(
                            'Buat Akun Baru',
                            style: TextStyle(
                              color: AppColors.maroon,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Mulai perjalananmu untuk lebih memahami\ndan menjaga kesehatan mentalmu.',
                            style: TextStyle(
                              color: AppColors.maroon,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 36),
                          // Nama lengkap
                          TextFormField(
                            controller: _namaController,
                            textCapitalization: TextCapitalization.words,
                            decoration: _dekorasi('Nama Lengkap'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Nama lengkap wajib diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Email
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _dekorasi('Email'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email wajib diisi';
                              }
                              if (!value.contains('@') ||
                                  !value.contains('.')) {
                                return 'Format email tidak valid';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Kata sandi
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: _dekorasi('Kata Sandi'),
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
                          const SizedBox(height: 16),
                          // Konfirmasi kata sandi
                          TextFormField(
                            controller: _konfirmasiController,
                            obscureText: true,
                            decoration: _dekorasi('Konfirmasi Kata Sandi'),
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
                          const SizedBox(height: 12),
                          // Checkbox syarat dan privasi
                          Row(
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
                                        : AppColors.maroon,
                                    width: 1.5,
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
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
                                    children: [
                                      TextSpan(
                                        text: 'Syarat & Privasi',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(
                                    color: AppColors.maroon,
                                    fontSize: 11,
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
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          const SizedBox(height: 28),
                          // Tombol daftar
                          Center(
                            child: SizedBox(
                              width: 160,
                              height: 46,
                              child: FilledButton(
                                onPressed: _daftar,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.maroon,
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text(
                                  'Daftar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Sudah punya akun
                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.maybePop(context),
                              child: const Text.rich(
                                TextSpan(
                                  text: 'Sudah punya akun? ',
                                  children: [
                                    TextSpan(
                                      text: 'Masuk disini',
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