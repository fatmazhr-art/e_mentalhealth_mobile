import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'otp_screen.dart';

// Warna
const _primary = Color(0xFF7B1E2B);
const _textDark = Color(0xFF4A1420);
const _textMuted = Color(0xFF7A5A5F);
const _border = Color(0xFFEBD8CB);

TextStyle _t(double size,
        {FontWeight weight = FontWeight.w400, Color color = _textDark}) =>
    GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);

class LupaKataSandiScreen extends StatefulWidget {
  const LupaKataSandiScreen({super.key});

  @override
  State<LupaKataSandiScreen> createState() => _LupaKataSandiScreenState();
}

class _LupaKataSandiScreenState extends State<LupaKataSandiScreen> {
  final _emailC = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailC.dispose();
    super.dispose();
  }

  // Masking email: konselor@curhatin.id → k******@curhatin.id
  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length < 2) return email;
    final name = parts[0];
    if (name.isEmpty) return email;
    final masked = '${name[0]}${'*' * (name.length > 1 ? name.length - 1 : 5)}';
    return '$masked@${parts[1]}';
  }

  Future<void> _kirimOtp() async {
    final email = _emailC.text.trim();
    if (email.isEmpty) return;

    setState(() => _isLoading = true);
    // Simulasi network delay (frontend only)
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(maskedEmail: _maskEmail(email)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol kembali
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: _primary, size: 26),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 36),

              // Judul
              Text('Lupa Kata Sandi?',
                  style: _t(26, weight: FontWeight.w800)),
              const SizedBox(height: 14),
              Text(
                'Masukkan email akun konselormu. Kami akan mengirimkan '
                'kode OTP untuk mereset kata sandi.',
                style: _t(14.5, color: _textMuted),
              ),
              const SizedBox(height: 36),

              // Field email
              Text('Email Konselor',
                  style: _t(14, weight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _emailC,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _kirimOtp(),
                style: _t(15),
                decoration: InputDecoration(
                  hintText: 'konselor@curhatin.id',
                  hintStyle:
                      _t(15, color: _textMuted.withValues(alpha: 0.6)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: _border, width: 1.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: _primary, width: 1.2),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Tombol kirim OTP
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _kirimOtp,
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
                              strokeWidth: 2.4, color: Colors.white),
                        )
                      : Text('Kirim Kode OTP',
                          style: _t(16,
                              weight: FontWeight.w600,
                              color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
