import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '0009_detail_hasil.dart';
import 'komponen_hasil.dart';

const Color _latar = Color(0xFFFCFAF8);
const Color _teksGelap = Color(0xFF222222);
const Color _teksAbu = Color(0xFF666666);
const Color _kartu = Color(0xFFFEF5EC);
const Color _garis = Color(0xFFEBD9C6);

class HasilAsesmenScreen extends StatelessWidget {
  const HasilAsesmenScreen({super.key});

  // Data contoh. Ganti dengan hasil perhitungan / API nanti.
  static const int _skorStress = 15;
  static const int _skorCemas = 12;
  static const int _skorDepresi = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _latar,
      body: SafeArea(
        child: Column(
          children: [
            const BarAtasHasil(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _badgeRingkasan(),
                    const SizedBox(height: 12),
                    const Text(
                      'Halo, berikut rangkuman hasil asesmen psikologis '
                      'terbarumu dengan gambaran kondisi terkendali.',
                      style: TextStyle(
                        color: _teksGelap,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const _KartuUtama(skor: _skorStress),
                    const SizedBox(height: 24),
                    const Text(
                      'KATEGORI LAINNYA',
                      style: TextStyle(
                        color: _teksAbu,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _KartuKategori(
                            judul: 'Kecemasan',
                            skor: _skorCemas,
                            status: 'Sedang',
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: _KartuKategori(
                            judul: 'Depresi',
                            skor: _skorDepresi,
                            status: 'Normal',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const _KartuPenjelasan(),
                    const SizedBox(height: 16),
                    _KartuTips(
                      onCoba: () {
                        // TODO: buka halaman Rehat / relaksasi
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DetailHasilScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.maroon,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Lihat Detail Hasil',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
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

  Widget _badgeRingkasan() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: _kartu,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _garis),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: AppColors.maroon, size: 8),
          SizedBox(width: 8),
          Text(
            'RINGKASAN HASIL',
            style: TextStyle(
              color: AppColors.maroon,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Kartu utama (Stress) ----------------
class _KartuUtama extends StatelessWidget {
  final int skor;

  const _KartuUtama({required this.skor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kartu,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _garis),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.maroon.withAlpha(26),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Kondisi Ringan – Sedang',
              style: TextStyle(
                color: AppColors.maroon,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 20),
          LingkaranSkor(
            skor: skor,
            ukuran: 170,
            tebal: 14,
            tengah: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$skor',
                  style: const TextStyle(
                    color: _teksGelap,
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'DARI SKOR 0–42',
                  style: TextStyle(
                    color: _teksAbu,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Stress',
            style: TextStyle(
              color: _teksGelap,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Sedang ● Tingkat Hampir Tinggi',
            style: TextStyle(
              color: AppColors.maroon,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Kamu sedang mengalami tingkat stres sedang. Ini wajar terjadi '
            'saat menghadapi dinamika tugas akhir atau rutinitas harian.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _teksAbu, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}

// ---------------- Kartu kategori kecil ----------------
class _KartuKategori extends StatelessWidget {
  final String judul;
  final int skor;
  final String status;

  const _KartuKategori({
    required this.judul,
    required this.skor,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      decoration: BoxDecoration(
        color: _kartu,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _garis),
      ),
      child: Column(
        children: [
          LingkaranSkor(skor: skor, ukuran: 84, tebal: 8),
          const SizedBox(height: 12),
          Text(
            judul,
            style: const TextStyle(
              color: _teksGelap,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            status,
            style: const TextStyle(
              color: AppColors.maroon,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Skor: $skor/42',
            style: const TextStyle(color: _teksAbu, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ---------------- Kartu penjelasan ----------------
class _KartuPenjelasan extends StatelessWidget {
  const _KartuPenjelasan();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _kartu,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _garis),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.maroon, size: 22),
              SizedBox(width: 8),
              Text(
                'Apa Artinya Bagi Kamu?',
                style: TextStyle(
                  color: _teksGelap,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Secara umum kondisimu dalam batas yang dapat dikelola dengan '
            'baik. Suasana hati cukup stabil, namun ada beberapa tekanan '
            'harian atau tugas perkuliahan yang memicu ketegangan ringan '
            'hingga sedang. Luangkan waktu sejenak untuk relaksasi teratur '
            'agar energi pikiranmu tetap prima.',
            style: TextStyle(color: _teksAbu, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ---------------- Kartu tips relaksasi ----------------
class _KartuTips extends StatelessWidget {
  final VoidCallback onCoba;

  const _KartuTips({required this.onCoba});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.maroon.withAlpha(70)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.maroon.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.timer_outlined,
              color: AppColors.maroon,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips Relaksasi Rutin',
                  style: TextStyle(
                    color: _teksGelap,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Luangkan 5 menit relaksasi untuk menjaga pikiran tetap jernih.',
                  style: TextStyle(color: _teksAbu, fontSize: 12, height: 1.3),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onCoba,
            style: TextButton.styleFrom(foregroundColor: AppColors.maroon),
            child: const Text(
              'Coba',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}