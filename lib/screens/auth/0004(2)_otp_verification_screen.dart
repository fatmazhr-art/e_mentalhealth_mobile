import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../widgets/circle_back_button.dart';
import '0004(3)_buat_password_baru.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({
    super.key,
    this.email = 'zahra@gmail.com',
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _startSeconds = 59;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _startSeconds = 59;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startSeconds > 0) {
        setState(() => _startSeconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _verifikasiOtp() {
    String otpCode = _controllers.map((c) => c.text).join();

    if (otpCode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi 6 digit kode OTP')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResetPasswordScreen(),
      ),
    );
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- Header Title & Subtitle ----------------
            const Text(
                'Masukkan Kode OTP',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.maroon,
                ),
              ),
      
            const SizedBox(height: 12),
            Text(
              'Kode verifikasi dikirim ke ${widget.email}.\nMasukkan kode untuk mengatur ulang kata sandi Anda.',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.4,
                color: AppColors.maroon.withAlpha(200),
              ),
            ),
            const SizedBox(height: 32),

            // ---------------- Label OTP ----------------
            const Text(
              'Kode Keamanan (6 Digit)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.maroon,
              ),
            ),
            const SizedBox(height: 12),

            // ---------------- 6 Digit Kotak OTP Responsif ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return Flexible(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    height: 54,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.maroon,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: kCreamFill,
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: kBorderMaroon, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.maroon,
                            width: 1.8,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // ---------------- Countdown Timer ----------------
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 18,
                    color: AppColors.maroon,
                  ),
                  const SizedBox(width: 6),
                  _startSeconds > 0
                      ? Text(
                          'Kirim ulang kode dalam 00.${_startSeconds.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.maroon.withAlpha(200),
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : GestureDetector(
                          onTap: _startTimer,
                          child: const Text(
                            'Kirim ulang kode',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.maroon,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // ---------------- Tombol Verifikasi ----------------
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _verifikasiOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.maroon,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Verifikasi',
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
    );
  }
}