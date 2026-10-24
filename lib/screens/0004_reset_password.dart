import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';
import 'package:e_mentalhealth_mobile/widgets/circle_icon_button.dart';
import 'package:e_mentalhealth_mobile/widgets/primary_button.dart';
import 'package:e_mentalhealth_mobile/screens/0024_buat_password_baru.dart';

export 'package:e_mentalhealth_mobile/screens/0024_buat_password_baru.dart';

class VerifyOtpScreen extends StatefulWidget {
  /// Email/nomor yang sudah disamarkan, mis. a*****@gmail.com
  final String maskedTarget;
  const VerifyOtpScreen({super.key, this.maskedTarget = 'a*****@gmail.com'});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  static const int _len = 6;
  static const int _startSeconds = 60;

  final List<TextEditingController> _controllers =
      List.generate(_len, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(_len, (_) => FocusNode());

  Timer? _timer;
  int _seconds = _startSeconds;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  // ----- Timer hitung mundur 60 detik -----
  void _startTimer() {
    _timer?.cancel();
    _seconds = _startSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_seconds <= 1) {
          _seconds = 0;
          t.cancel();
        } else {
          _seconds--;
        }
      });
    });
  }

  String get _timerText {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m.$s';
  }

  void _resend() {
    for (final c in _controllers) {
      c.clear();
    }
    setState(_startTimer);
    _nodes.first.requestFocus();
    _snack('Kode baru telah dikirim');
    // TODO: panggil API kirim ulang OTP
  }

  // ----- Perilaku kotak OTP -----
  void _onChanged(int i, String v) {
    if (v.length > 1) {
      // Dukungan paste: sebar digit ke kotak-kotak berikutnya
      final digits = v.replaceAll(RegExp(r'\D'), '');
      for (var k = 0; k < digits.length && i + k < _len; k++) {
        _controllers[i + k].text = digits[k];
      }
      final next = (i + digits.length).clamp(0, _len - 1);
      _nodes[next].requestFocus();
    } else if (v.isNotEmpty && i < _len - 1) {
      _nodes[i + 1].requestFocus(); // lanjut ke kotak berikutnya
    } else if (v.isEmpty && i > 0) {
      _nodes[i - 1].requestFocus(); // hapus -> mundur
    }
    setState(() {});
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  void _verify() {
    if (_code.length < _len) {
      _snack('Masukkan 6 digit kode dulu ya');
      return;
    }
    // TODO: verifikasi kode ke backend sebelum lanjut
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleIconButton(
                      icon: Icons.arrow_back,
                      onTap: () => Navigator.maybePop(context),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text('Masukkan Kode OTP',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.maroon)),
                  const SizedBox(height: 12),
                  Text(
                    'Kami telah mengirimkan 6 digit kode verifikasi ke email/nomor kamu ${widget.maskedTarget}. Masukkan kode tersebut untuk melanjutkan reset password.',
                    style: const TextStyle(
                        fontSize: 14, height: 1.5, color: AppColors.mutedMaroon),
                  ),
                  const SizedBox(height: 32),
                  const Text('Kode Keamanan (6 Digit)',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text)),
                  const SizedBox(height: 12),
                  Row(children: List.generate(_len, _buildOtpBox)),
                  const SizedBox(height: 20),
                  _buildTimerRow(),
                  const SizedBox(height: 32),
                  PrimaryButton(label: 'Verifikasi', onPressed: _verify),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int i) {
    final filled = _controllers[i].text.isNotEmpty;
    OutlineInputBorder border(Color c, double w) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c, width: w),
        );

    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: i == _len - 1 ? 0 : 8),
        child: Focus(
          // Backspace pada kotak kosong (keyboard fisik/emulator)
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.backspace &&
                _controllers[i].text.isEmpty &&
                i > 0) {
              _controllers[i - 1].clear();
              _nodes[i - 1].requestFocus();
              setState(() {});
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: SizedBox(
            height: 58,
            child: TextField(
              controller: _controllers[i],
              focusNode: _nodes[i],
              autofocus: i == 0,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              cursorColor: AppColors.maroon,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.maroon),
              onChanged: (v) => _onChanged(i, v),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.fieldPink,
                contentPadding: EdgeInsets.zero,
                enabledBorder: border(
                    filled ? AppColors.maroon : AppColors.cardBorder, 1),
                focusedBorder: border(AppColors.maroon, 2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimerRow() {
    if (_seconds > 0) {
      return Row(
        children: [
          const Icon(Icons.access_time, size: 18, color: AppColors.mutedMaroon),
          const SizedBox(width: 6),
          Text('Kirim ulang kode dalam $_timerText',
              style: const TextStyle(fontSize: 13, color: AppColors.mutedMaroon)),
        ],
      );
    }
    return GestureDetector(
      onTap: _resend,
      child: const Row(
        children: [
          Icon(Icons.refresh, size: 18, color: AppColors.maroon),
          SizedBox(width: 6),
          Text('Kirim ulang kode',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.maroon)),
        ],
      ),
    );
  }
}
