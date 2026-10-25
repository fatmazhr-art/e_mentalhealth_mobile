import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'komponen_profil.dart';

class ManagePasswordScreen extends StatefulWidget {
  const ManagePasswordScreen({super.key});

  @override
  State<ManagePasswordScreen> createState() => _ManagePasswordScreenState();
}

class _ManagePasswordScreenState extends State<ManagePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _lamaCtrl = TextEditingController();
  final _baruCtrl = TextEditingController();
  final _konfirmasiCtrl = TextEditingController();

  // Toggle visibilitas (true = tersembunyi)
  bool isObscureLama = true;
  bool isObscureBaru = true;
  bool isObscureKonfirmasi = true;

  @override
  void dispose() {
    _lamaCtrl.dispose();
    _baruCtrl.dispose();
    _konfirmasiCtrl.dispose();
    super.dispose();
  }

  // ---------------- Aturan kekuatan password ----------------
  String get _baru => _baruCtrl.text;

  bool get _minDelapan => _baru.length >= 8;

  bool get _kompleks =>
      RegExp(r'[A-Z]').hasMatch(_baru) &&
      RegExp(r'\d').hasMatch(_baru) &&
      RegExp(r'[^A-Za-z0-9]').hasMatch(_baru);

  bool get _berbedaDariLama => _baru.isNotEmpty && _baru != _lamaCtrl.text;

  int get _skor =>
      [_minDelapan, _kompleks, _berbedaDariLama].where((e) => e).length;

  String get _labelKekuatan {
    switch (_skor) {
      case 1:
        return 'Lemah';
      case 2:
        return 'Sedang';
      case 3:
        return 'Kuat';
      default:
        return '';
    }
  }

  void _simpan() {
    final formValid = _formKey.currentState!.validate();
    if (!formValid || _skor < 3) {
      if (_skor < 3) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Password baru belum memenuhi semua syarat.'),
            ),
          );
      }
      return;
    }

    // TODO: kirim password lama & baru ke backend
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Password berhasil diperbarui!')),
      );
    Navigator.pop(context);
  }

  Widget _toggleMata(bool tersembunyi, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        tersembunyi
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        color: kProfilTeksAbu,
        size: 22,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFAF8),
      body: SafeArea(
        child: Column(
          children: [
            const ProfilTopBar(judul: 'Kelola Kata Sandi'),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gunakan password yang kuat supaya akunmu tetap aman.',
                        style: TextStyle(
                          color: kProfilTeksAbu,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 22),
                      ProfilField(
                        label: 'Password lama',
                        controller: _lamaCtrl,
                        hint: 'Masukkan password lama',
                        obscureText: isObscureLama,
                        onChanged: (_) => setState(() {}),
                        suffix: _toggleMata(
                          isObscureLama,
                          () => setState(() => isObscureLama = !isObscureLama),
                        ),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Password lama wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 18),
                      ProfilField(
                        label: 'Password baru',
                        controller: _baruCtrl,
                        hint: 'Masukkan password baru',
                        obscureText: isObscureBaru,
                        onChanged: (_) => setState(() {}),
                        suffix: _toggleMata(
                          isObscureBaru,
                          () => setState(() => isObscureBaru = !isObscureBaru),
                        ),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Password baru wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _indikatorKekuatan(),
                      const SizedBox(height: 12),
                      _ItemSyarat(
                        teks: 'Minimal 8 karakter',
                        terpenuhi: _minDelapan,
                      ),
                      _ItemSyarat(
                        teks: 'Ada huruf besar, angka, karakter spesial',
                        terpenuhi: _kompleks,
                      ),
                      _ItemSyarat(
                        teks: 'Berbeda dari Password lama',
                        terpenuhi: _berbedaDariLama,
                      ),
                      const SizedBox(height: 18),
                      ProfilField(
                        label: 'Konfirmasi password baru',
                        controller: _konfirmasiCtrl,
                        hint: 'Ulangi password baru',
                        obscureText: isObscureKonfirmasi,
                        suffix: _toggleMata(
                          isObscureKonfirmasi,
                          () => setState(
                            () => isObscureKonfirmasi = !isObscureKonfirmasi,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Konfirmasi password wajib diisi';
                          }
                          if (v != _baruCtrl.text) {
                            return 'Konfirmasi tidak sama dengan password baru';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),
                      TombolUtama(label: 'Simpan Password', onPressed: _simpan),
                      const SizedBox(height: 12),
                      TombolBatal(onPressed: () => Navigator.maybePop(context)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Strength bar (3 segmen) ----------------
  Widget _indikatorKekuatan() {
    return Row(
      children: [
        for (var i = 0; i < 3; i++) ...[
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 6,
              decoration: BoxDecoration(
                color: i < _skor ? AppColors.maroon : kProfilGaris,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          if (i < 2) const SizedBox(width: 6),
        ],
        SizedBox(
          width: 56,
          child: Text(
            _labelKekuatan,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AppColors.maroon,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------- Baris checklist syarat ----------------
class _ItemSyarat extends StatelessWidget {
  final String teks;
  final bool terpenuhi;

  const _ItemSyarat({required this.teks, required this.terpenuhi});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            terpenuhi ? Icons.check_circle_rounded : Icons.check_circle_outline,
            size: 18,
            color: terpenuhi ? AppColors.maroon : kProfilTeksAbu,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              teks,
              style: TextStyle(
                color: terpenuhi ? kProfilTeksGelap : kProfilTeksAbu,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}