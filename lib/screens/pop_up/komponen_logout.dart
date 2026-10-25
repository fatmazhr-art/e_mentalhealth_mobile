import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../auth/0003_login.dart';

const Color _kartuPutih = Color(0xFFFFFFFF);
const Color _kotakIkon = Color(0xFFFEEAE6);
const Color _tombolSekunder = Color(0xFFFDE2E2);
const Color _teksGelap = Color(0xFF222222);
const Color _teksAbu = Color(0xFF777777);

/// Menampilkan dialog konfirmasi keluar.
///
/// [onConfirm] dipanggil saat "Ya, Keluar" ditekan, sebelum pindah ke halaman
/// login. Isi dengan penghapusan sesi, misalnya clear token / reset state.
///
/// Setelah itu aplikasi menjalankan:
///   Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false)
/// sehingga route '/login' HARUS terdaftar di MaterialApp (lihat catatan).
Future<void> showLogoutDialog(
  BuildContext context, {
  Future<void> Function()? onConfirm,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: const Color(0x803A0A18), // overlay gelap / dusty pink
    builder: (_) => LogoutConfirmationDialog(onConfirm: onConfirm),
  );
}

class LogoutConfirmationDialog extends StatelessWidget {
  final Future<void> Function()? onConfirm;

  const LogoutConfirmationDialog({super.key, this.onConfirm});

  Future<void> _keluar(BuildContext context) async {
    // Ambil navigator sebelum await agar aman dipakai setelahnya.
    final navigator = Navigator.of(context);

    // TODO: hapus sesi login di sini (token, SharedPreferences, state, dll.)
    await onConfirm?.call();

    // Hapus semua halaman dari tumpukan, lalu buka Login.
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _kartuPutih,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ikon di kotak melengkung
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: _kotakIkon,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: AppColors.maroon,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Yakin ingin Keluar?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _teksGelap,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Kamu bisa masuk kembali kapan saja. Kami tetap di sini kalau '
              'kamu butuh cerita.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _teksAbu,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 26),
            // Tombol konfirmasi
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => _keluar(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.maroon,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Ya, Keluar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Tombol batal
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _tombolSekunder,
                  foregroundColor: AppColors.maroon,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Batal',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}