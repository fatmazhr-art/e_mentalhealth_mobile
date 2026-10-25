import 'package:flutter/material.dart';
import '../widgets/circle_back_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_mentalhealth_mobile/theme/app_colors.dart';

// Halaman hasil SEMENTARA. Ganti dengan halaman hasil asli (0008_hasil_asesmen...)

/// ====== Halaman hasil (placeholder, belum ada perhitungan skor) ======
class HasilAsesmenSementara extends StatelessWidget {
  final String nama;
  final String nim;
  final String prodi;
  final Map<int, int> jawaban;

  const HasilAsesmenSementara({
    super.key,
    required this.nama,
    required this.nim,
    required this.prodi,
    required this.jawaban,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const CircleBackButton(),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.maroon,
        elevation: 0,
        title: Text('Hasil Asesmen',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: $nama', style: GoogleFonts.nunito(fontSize: 16)),
            Text('NIM: $nim', style: GoogleFonts.nunito(fontSize: 16)),
            Text('Program Studi: ${prodi.isEmpty ? "-" : prodi}',
                style: GoogleFonts.nunito(fontSize: 16)),
            const SizedBox(height: 16),
            Text('Jawaban (indeks -> skor): $jawaban',
                style: GoogleFonts.nunito(fontSize: 14)),
            // TODO: hitung skor Depresi/Kecemasan/Stres per subskala DASS-21
          ],
        ),
      ),
    );
  }
}