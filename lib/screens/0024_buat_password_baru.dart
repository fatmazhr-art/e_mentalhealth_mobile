import 'package:flutter/material.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';
import 'package:e_mentalhealth_mobile/models/password_rules.dart';
import 'package:e_mentalhealth_mobile/widgets/circle_icon_button.dart';
import 'package:e_mentalhealth_mobile/widgets/primary_button.dart';
import 'package:e_mentalhealth_mobile/widgets/password_field.dart';
import 'package:e_mentalhealth_mobile/widgets/strength_bar.dart';
import 'package:e_mentalhealth_mobile/widgets/rule_item.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _oldC = TextEditingController();
  final _newC = TextEditingController();
  final _confirmC = TextEditingController();

  // Visibilitas password (true = tersembunyi)
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    // Perbarui indikator kekuatan setiap input berubah
    _oldC.addListener(() => setState(() {}));
    _newC.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _oldC.dispose();
    _newC.dispose();
    _confirmC.dispose();
    super.dispose();
  }

  PasswordRules get _rules => PasswordRules.check(_newC.text, _oldC.text);

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  void _save() {
    if (_oldC.text.isEmpty) {
      _snack('Isi password lama dulu ya');
      return;
    }
    if (!_rules.allPassed) {
      _snack('Password baru belum memenuhi semua syarat');
      return;
    }
    if (_confirmC.text != _newC.text) {
      _snack('Konfirmasi password tidak sama');
      return;
    }
    // TODO: kirim password baru ke backend
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).popUntil((r) => r.isFirst);
    messenger.showSnackBar(
      const SnackBar(content: Text('Password berhasil diubah')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rules = _rules;
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
                  const SizedBox(height: 24),
                  const Center(
                    child: Text('Buat Password Baru',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.maroon)),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Pastikan kata sandi baru Anda kuat, unik, dan belum pernah digunakan untuk menjaga kerahasiaan ruang konseling pribadi Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, height: 1.5, color: AppColors.mutedMaroon),
                  ),
                  const SizedBox(height: 28),

                  // Password lama
                  PasswordField(
                    label: 'Password lama',
                    hint: 'Masukkan password lama',
                    controller: _oldC,
                    obscure: _obscureOld,
                    onToggle: () =>
                        setState(() => _obscureOld = !_obscureOld),
                  ),
                  const SizedBox(height: 18),

                  // Password baru + indikator
                  PasswordField(
                    label: 'Password baru',
                    hint: 'Masukkan password baru',
                    controller: _newC,
                    obscure: _obscureNew,
                    onToggle: () =>
                        setState(() => _obscureNew = !_obscureNew),
                  ),
                  const SizedBox(height: 12),
                  StrengthBar(score: rules.score),
                  const SizedBox(height: 12),
                  RuleItem(ok: rules.minLength, text: 'Minimal 8 karakter'),
                  RuleItem(
                      ok: rules.complexity,
                      text: 'Ada huruf besar, angka, karakter spesial'),
                  RuleItem(
                      ok: rules.differentFromOld,
                      text: 'Berbeda dari Password lama'),
                  const SizedBox(height: 18),

                  // Konfirmasi
                  PasswordField(
                    label: 'Konfirmasi password baru',
                    hint: 'Ulangi password baru',
                    controller: _confirmC,
                    obscure: _obscureConfirm,
                    onToggle: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  const SizedBox(height: 28),

                  PrimaryButton(label: 'Simpan Password', onPressed: _save),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => Navigator.maybePop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.maroon,
                        backgroundColor: AppColors.cream,
                        side: const BorderSide(color: AppColors.cream),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Batal',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}