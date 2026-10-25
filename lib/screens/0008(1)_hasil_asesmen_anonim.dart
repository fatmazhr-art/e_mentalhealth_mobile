import 'package:flutter/material.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';
import 'package:e_mentalhealth_mobile/models/hasil_asesmen.dart';
import 'package:e_mentalhealth_mobile/widgets/circle_back_button.dart';
import '0002_register_akun.dart'; // Sesuaikan lokasi file RegisterScreen kamu

class HasilAsesmenAnonimScreen extends StatelessWidget {
  final HasilAsesmen hasil;

  const HasilAsesmenAnonimScreen({
    super.key,
    required this.hasil,
  });

  @override
  Widget build(BuildContext context) {
    const kBgColor = Color(0xFFFFFBF5);
    const kCreamFill = Color(0xFFFFFDF9);
    final kBorderMaroon = AppColors.maroon.withAlpha(40);
    final isTinggi = hasil.isTinggi;

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
        title: const Text(
          'Hasil Asesmen Online DASS-21',
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.bold,
            color: AppColors.maroon,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.headphones_outlined, color: AppColors.maroon, size: 22),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge "• RINGKASAN HASIL"
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E7E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '• RINGKASAN HASIL',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.maroon,
                ),
              ),
            ),
            const SizedBox(height: 10),

            Text(
              isTinggi
                  ? 'Halo, berikut kesimpulan awal dari asesmen psikologis yang baru saja kamu selesaikan.'
                  : 'Halo, berikut rangkuman hasil asesmen psikologis terbarumu dengan gambaran kondisi terkendali.',
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF444444),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            // ---------------- Card Utama Gauge ----------------
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kCreamFill,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kBorderMaroon),
              ),
              child: Column(
                children: [
                  Container(
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.maroon,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: isTinggi ? const Color(0xFFFCDAD7) : const Color(0xFFF9EBEA),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            isTinggi ? 'Perlu Perhatian Khusus' : 'Kondisi Ringan – Sedang',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.maroon,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 115,
                              height: 115,
                              child: CircularProgressIndicator(
                                value: hasil.skorUtama / 42.0,
                                strokeWidth: 12,
                                backgroundColor: const Color(0xFFF2D7D5),
                                color: AppColors.maroon,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${hasil.skorUtama}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF222222),
                                  ),
                                ),
                                const Text(
                                  'DARI SKOR 0–42',
                                  style: TextStyle(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF888888),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          hasil.labelUtama,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF222222),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text.rich(
                          TextSpan(
                            text: hasil.tingkatUtama,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.maroon,
                            ),
                            children: [
                              TextSpan(
                                text: isTinggi ? ' • Tingkat Tertinggi' : ' • Tingkat Hampir Tinggi',
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF777777),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          hasil.deskripsiSingkat,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ---------------- Kategori Lainnya ----------------
            const Text(
              'KATEGORI LAINNYA',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF888888),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildMiniCategoryCard(
                    'Kecemasan',
                    hasil.skorKecemasan,
                    hasil.labelKecemasan,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMiniCategoryCard(
                    'Depresi',
                    hasil.skorDepresi,
                    hasil.labelDepresi,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ---------------- Apa Artinya Bagi Kamu ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCreamFill,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kBorderMaroon),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline_rounded, color: AppColors.maroon, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Apa Artinya Bagi Kamu?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF222222),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hasil.penjelasanApaArtinya,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF555555),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ---------------- Tips Relaksasi Card ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: kCreamFill,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kBorderMaroon),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5E6DA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.access_time_filled_rounded, color: AppColors.maroon, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isTinggi ? 'Tarik Napas Sejenak' : 'Tips Relaksasi Rutin',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF222222),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isTinggi
                              ? 'Latihan napas 2 menit dapat menurunkan detak jantung.'
                              : 'Luangkan 5 menit relaksasi untuk menjaga pikiran tetap jernih.',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Coba',
                      style: TextStyle(
                        color: AppColors.maroon,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ---------------- TOMBOL UTAMA (DAFTAR UNTUK LIHAT DETAIL HASIL) ----------------
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Langsung Arahkan Pengguna Anonim ke Halaman Register
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.maroon,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Daftar untuk Lihat Detail Hasil',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniCategoryCard(String title, int score, String level) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.maroon.withAlpha(40)),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 38,
                height: 38,
                child: CircularProgressIndicator(
                  value: score / 42.0,
                  strokeWidth: 4,
                  backgroundColor: const Color(0xFFF2D7D5),
                  color: AppColors.maroon,
                ),
              ),
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF222222)),
                ),
                Text(
                  level,
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.maroon),
                ),
                Text(
                  'Skor: $score/42',
                  style: const TextStyle(fontSize: 9, color: Color(0xFF888888)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}