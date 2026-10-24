import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'buat_password_baru_screen.dart';

// Warna
const _primary = Color(0xFF7B1E2B);
const _textDark = Color(0xFF4A1420);
const _textMuted = Color(0xFF7A5A5F);
const _border = Color(0xFFEBD8CB);

TextStyle _t(double size,
        {FontWeight weight = FontWeight.w400, Color color = _textDark}) =>
    GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);

class OtpScreen extends StatefulWidget {
  final String maskedEmail;

  const OtpScreen({super.key, required this.maskedEmail});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  Timer? _timer;
  int _secondsLeft = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _resendOtp() {
    setState(() => _secondsLeft = 60);
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _verifikasi() {
    if (_otp.length < 6) return;
    // TODO: validasi OTP dengan API Laravel
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BuatPasswordBaruScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mm = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final ss = (_secondsLeft % 60).toString().padLeft(2, '0');

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
              Text('Masukkan Kode OTP',
                  style: _t(26, weight: FontWeight.w800)),
              const SizedBox(height: 14),

              // Deskripsi
              RichText(
                text: TextSpan(
                  style: _t(14.5, color: _textMuted),
                  children: [
                    const TextSpan(
                        text:
                            'Kami telah mengirimkan 6 digit kode verifikasi ke email kamu '),
                    TextSpan(
                      text: widget.maskedEmail,
                      style:
                          _t(14.5, weight: FontWeight.w600, color: _textDark),
                    ),
                    const TextSpan(
                        text:
                            '. Masukkan kode tersebut untuk melanjutkan reset password.'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Label
              Text('Kode Keamanan (6 Digit)',
                  style: _t(14, weight: FontWeight.w600)),
              const SizedBox(height: 16),

              // 6 kotak OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    List.generate(6, (i) => _buildOtpBox(i)),
              ),
              const SizedBox(height: 22),

              // Countdown / resend
              Center(
                child: _secondsLeft > 0
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time,
                              color: _textMuted, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Kirim ulang kode dalam $mm.$ss',
                            style: _t(13.5, color: _textMuted),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: _resendOtp,
                        child: Text(
                          'Kirim ulang kode',
                          style: _t(13.5,
                                  weight: FontWeight.w600,
                                  color: _primary)
                              .copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: _primary,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 44),

              // Tombol verifikasi
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _otp.length == 6 ? _verifikasi : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        _primary.withValues(alpha: 0.5),
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: Text('Verifikasi',
                      style: _t(16,
                          weight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int i) {
    return SizedBox(
      width: 50,
      height: 60,
      child: TextField(
        controller: _controllers[i],
        focusNode: _focusNodes[i],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: _t(24, weight: FontWeight.w700),
        onChanged: (v) {
          if (v.isNotEmpty && i < 5) {
            _focusNodes[i + 1].requestFocus();
          } else if (v.isEmpty && i > 0) {
            _focusNodes[i - 1].requestFocus();
          }
          setState(() {});
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _border, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _primary, width: 2),
          ),
        ),
      ),
    );
  }
}
