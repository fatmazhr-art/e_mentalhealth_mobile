import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_storage.dart';
import 'konselor_chat_screen.dart';

class KonselorLoginScreen extends StatefulWidget {
  const KonselorLoginScreen({super.key});

  @override
  State<KonselorLoginScreen> createState() => _KonselorLoginScreenState();
}

class _KonselorLoginScreenState extends State<KonselorLoginScreen> {
  static const _primary = Color(0xFF7B1E2B);
  static const _textDark = Color(0xFF4A1420);
  static const _textMuted = Color(0xFF7A5A5F);
  static const _border = Color(0xFFEBD8CB);
  static const _error = Color(0xFFB3261E);

  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();

  bool _obscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  TextStyle _t(double size,
      {FontWeight weight = FontWeight.w400, Color color = _textDark}) =>
      GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);

  InputDecoration _inputDecoration({String? hint, Widget? suffix}) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: c, width: 1.2),
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: _t(15, color: _textMuted.withValues(alpha: 0.6)),
      suffixIcon: suffix,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: border(_border),
      focusedBorder: border(_primary),
      errorBorder: border(_error),
      focusedErrorBorder: border(_error),
      errorStyle: _t(12, color: _error),
    );
  }

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Email wajib diisi';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Kata sandi wajib diisi';
    return null;
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 1));

      // SEMENTARA: anggap login selalu berhasil.
      // Ganti dengan panggilan API Laravel nanti, dan hapus token palsu ini.
      await AuthStorage.saveToken('dummy-token');

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const KonselorChatScreen()),
            (route) => false,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Logo (tanpa kotak background)
                    Image.asset(
                      'assets/images/logo.png',
                      width: 260,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.favorite,
                        color: _primary,
                        size: 120,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tagline
                    Text(
                      'Portal konselor untuk pendampingan kesehatan mental mahasiswa',
                      textAlign: TextAlign.center,
                      style: _t(13, color: _textMuted),
                    ),
                    const SizedBox(height: 28),

                    // Kartu form
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 20,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email Konselor',
                              style: _t(14, weight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailC,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            style: _t(15),
                            decoration:
                            _inputDecoration(hint: 'konselor@curhatin.id'),
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 18),

                          Text('Kata Sandi',
                              style: _t(14, weight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passC,
                            obscureText: _obscure,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _login(),
                            autofillHints: const [AutofillHints.password],
                            style: _t(15),
                            decoration: _inputDecoration(
                              hint: 'Masukkan kata sandi',
                              suffix: IconButton(
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: _textMuted,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                            ),
                            validator: _validatePassword,
                          ),
                          const SizedBox(height: 12),

                          // Lupa kata sandi
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                // TODO: halaman lupa kata sandi
                              },
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  'Lupa kata sandi?',
                                  style: _t(13,
                                      weight: FontWeight.w600,
                                      color: _primary)
                                      .copyWith(
                                    decoration: TextDecoration.underline,
                                    decorationColor: _primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Tombol Masuk
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primary,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor:
                                _primary.withValues(alpha: 0.6),
                                elevation: 0,
                                shape: const StadiumBorder(),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: Colors.white,
                                ),
                              )
                                  : Text(
                                'Masuk',
                                style: _t(16,
                                    weight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Tidak ada pendaftaran publik. Akun konselor dibuat oleh Admin Curhatin.',
                      textAlign: TextAlign.center,
                      style: _t(12.5, color: _textMuted),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}