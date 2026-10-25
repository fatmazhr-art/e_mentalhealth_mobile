import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../pop_up/komponen_hasil.dart';
import 'package:e_mentalhealth_mobile/models/hasil_asesmen.dart';
import '0010_jadwal_konselor.dart';

const Color _latar = Color(0xFFFCFAF8);
const Color _teksGelap = Color(0xFF222222);
const Color _teksAbu = Color(0xFF666666);
const Color _kartu = Color(0xFFFEF5EC);
const Color _garis = Color(0xFFEBD9C6);

class DetailHasilScreen extends StatelessWidget {
  final HasilAsesmen hasil;
  final VoidCallback? onChatKonselor;

  const DetailHasilScreen({
    super.key,
    required this.hasil,
    this.onChatKonselor,
  });

  static const List<_RekomendasiData> _rekomendasi = [
    _RekomendasiData(
      'Tenangkan Diri dengan Latihan Pernapasan Sederhana',
      'assets/images/rehat1.png',
    ),
    _RekomendasiData(
      'Meditasi Singkat untuk Meredakan Pikiran yang Penat',
      'assets/images/rehat2.png',
    ),
    _RekomendasiData(
      'Peregangan Ringan di Sela Waktu Belajar',
      'assets/images/rehat3.png',
    ),
  ];

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Render 3 Subskala Dinamis (Depresi, Kecemasan, Stress)
                          for (final s in hasil.subskala) ...[
                            _KartuMetrik(
                              data: _MetrikData(
                                judul: s.nama,
                                skor: s.skor,
                                status: s.tingkat,
                                deskripsi: s.deskripsi.isNotEmpty
                                    ? s.deskripsi
                                    : _getDeskripsiDefault(s.nama, s.tingkat),
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],
                          const SizedBox(height: 4),
                          _KartuDeskripsi(
                            deskripsi: hasil.deskripsiLengkap,
                            isTinggi: hasil.isTinggi,
                            onChatKonselor: onChatKonselor,
                          ),
                          const SizedBox(height: 28),
                          const Text(
                            'Rekomendasi Rehat Untukmu',
                            style: TextStyle(
                              color: _teksGelap,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                    // Daftar rekomendasi horizontal
                    SizedBox(
                      height: 250,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _rekomendasi.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, index) =>
                            _KartuRekomendasi(data: _rekomendasi[index]),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _getDeskripsiDefault(String nama, String tingkat) {
    if (nama.toLowerCase() == 'depresi') {
      return 'Suasana hati Anda dalam keadaan terkelola dengan baik. Tekanan perkuliahan dan aktivitas harian masih berada di batas normal.';
    } else if (nama.toLowerCase() == 'kecemasan') {
      return 'Anda merasakan ketakutan atau panik berlebih terkait tantangan aktivitas atau persaingan dunia kerja.';
    }
    return 'Beban akumulasi dari tugas akhir dan tekanan harian membuat Anda merasa berada di titik jenuh.';
  }
}

// ---------------- Data Model Internal ----------------
class _MetrikData {
  final String judul;
  final int skor;
  final String status;
  final String deskripsi;

  const _MetrikData({
    required this.judul,
    required this.skor,
    required this.status,
    required this.deskripsi,
  });
}

class _RekomendasiData {
  final String judul;
  final String gambar;

  const _RekomendasiData(this.judul, this.gambar);
}

// ---------------- Kartu metrik (lingkaran + deskripsi) ----------------
class _KartuMetrik extends StatelessWidget {
  final _MetrikData data;

  const _KartuMetrik({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kartu,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _garis),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LingkaranSkor(skor: data.skor, ukuran: 78, tebal: 8),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.judul,
                  style: const TextStyle(
                    color: _teksGelap,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.status,
                  style: const TextStyle(
                    color: AppColors.maroon,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.deskripsi,
                  style: const TextStyle(
                    color: _teksAbu,
                    fontSize: 12.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Kartu deskripsi rangkuman + Tombol Chat Konselor ----------------
class _KartuDeskripsi extends StatelessWidget {
  final String deskripsi;
  final bool isTinggi;
  final VoidCallback? onChatKonselor;

  const _KartuDeskripsi({
    required this.deskripsi,
    required this.isTinggi,
    this.onChatKonselor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.maroon.withAlpha(70)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deskripsi',
            style: TextStyle(
              color: _teksGelap,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            deskripsi,
            style: const TextStyle(color: _teksAbu, fontSize: 13, height: 1.5),
          ),

          // Jika Status Tinggi/Berat/Perlu Pendamping -> Tampilkan Tombol Chat Konselor
          if (isTinggi) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onChatKonselor ??
                    () {
                      Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JadwalKonselorScreen(), // Ganti dengan nama Class Layar Jadwal kamu
                    ),
                  );
                },
                icon: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                label: const Text(
                  'Chat dengan Konselor',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.maroon,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------- Kartu rekomendasi ----------------
class _KartuRekomendasi extends StatelessWidget {
  final _RekomendasiData data;

  const _KartuRekomendasi({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  data.gambar,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    width: double.infinity,
                    color: _kartu,
                    child: const Icon(
                      Icons.self_improvement,
                      color: AppColors.maroon,
                      size: 48,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  data.judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _teksGelap,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}