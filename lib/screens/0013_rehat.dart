import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

const Color _latar = Color(0xFFFCFAF8);
const Color _teksGelap = Color(0xFF222222);
const Color _teksAbu = Color(0xFF666666);
const Color _kartu = Color(0xFFFEF5EC);
const Color _garis = Color(0xFFEBD9C6);

// ---------------- Data ----------------
class _VideoData {
  final String judul;
  final String gambar;

  const _VideoData(this.judul, this.gambar);
}

class _LaguData {
  final String judul;
  final String artis;
  final String cover;

  const _LaguData(this.judul, this.artis, this.cover);
}

class _ArtikelData {
  final String judul;
  final String gambar;

  const _ArtikelData(this.judul, this.gambar);
}

class RehatScreen extends StatefulWidget {
  const RehatScreen({super.key});

  @override
  State<RehatScreen> createState() => _RehatScreenState();
}

class _RehatScreenState extends State<RehatScreen> {
  static const String _musik = 'Musik';
  static const String _artikel = 'Artikel';
  static const String _video = 'Video';

  static const List<String> _filter = [_musik, _artikel, _video];

  // Data contoh. Gambar: export dari Figma ke assets/images/.
  // Ganti dengan data dari API nanti.
  static const List<_VideoData> _daftarVideo = [
    _VideoData(
      'GUIDED MEDITATION FOR RELEASING STRESS & ANXIETY',
      'assets/images/rehat_video1.png',
    ),
    _VideoData(
      'DEEP BREATHING FOR CALM & FOCUS',
      'assets/images/rehat_video2.png',
    ),
    _VideoData(
      'BODY SCAN MEDITATION FOR BETTER SLEEP',
      'assets/images/rehat_video3.png',
    ),
  ];

  static const List<_LaguData> _daftarLagu = [
    _LaguData('Weightless', 'Marconi Union', 'assets/images/cover_weightless.png'),
    _LaguData('Gymnopédie No. 1', 'Erik Satie', 'assets/images/cover_gymnopedie.png'),
    _LaguData('Clair de Lune', 'Claude Debussy', 'assets/images/cover_clair.png'),
    _LaguData('Aqua', 'Ryuichi Sakamoto', 'assets/images/cover_aqua.png'),
    _LaguData('River Flows in You', 'Yiruma', 'assets/images/cover_river.png'),
    _LaguData(
      "Comptine d'un autre été",
      'Yann Tiersen',
      'assets/images/cover_comptine.png',
    ),
  ];

  static const List<_ArtikelData> _daftarArtikel = [
    _ArtikelData(
      'Saat Pikiran Terasa Penuh, Cobalah Berhenti Sejenak',
      'assets/images/rehat_artikel1.png',
    ),
    _ArtikelData(
      '5 Kebiasaan Kecil untuk Menenangkan Pikiran',
      'assets/images/rehat_artikel2.png',
    ),
    _ArtikelData(
      'Tidur Cukup Bukan Kemewahan, Tapi Kebutuhan',
      'assets/images/rehat_artikel3.png',
    ),
  ];

  // null = tampilkan semua seksi
  String? _filterAktif;

  bool _tampil(String seksi) => _filterAktif == null || _filterAktif == seksi;

  void _pilihFilter(String nama) {
    setState(() => _filterAktif = _filterAktif == nama ? null : nama);
  }

  void _bukaItem(String judul, String jenis) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _latar,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          jenis,
          style: const TextStyle(
            color: AppColors.maroon,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          judul,
          style: const TextStyle(color: _teksGelap, fontSize: 15, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: TextButton.styleFrom(foregroundColor: _teksAbu),
            child: const Text('Tutup'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // TODO: buka tautan media / halaman detail
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.maroon),
            child: const Text(
              'Buka',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _latar,
      body: SafeArea(
        child: Column(
          children: [
            _barAtas(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _seksiFilter(),
                    if (_tampil(_video)) ...[
                      const SizedBox(height: 28),
                      _seksiVideo(),
                    ],
                    if (_tampil(_musik)) ...[
                      const SizedBox(height: 28),
                      _seksiMusik(),
                    ],
                    if (_tampil(_artikel)) ...[
                      const SizedBox(height: 28),
                      _seksiArtikel(),
                    ],
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

  // ---------------- Top bar ----------------
  Widget _barAtas() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: [
          Material(
            color: AppColors.maroon,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.maybePop(context),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.arrow_back, color: Colors.white, size: 22),
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Rehat',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _teksGelap,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          // Penyeimbang agar judul tepat di tengah
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _judulSeksi(String teks) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        teks,
        style: const TextStyle(
          color: _teksGelap,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // ---------------- Filter ----------------
  Widget _seksiFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        _judulSeksi('Rekomendasi Untukmu'),
        const SizedBox(height: 14),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _filter.length,
            itemBuilder: (context, index) {
              final nama = _filter[index];
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _ChipFilter(
                  label: nama,
                  aktif: _filterAktif == nama,
                  onTap: () => _pilihFilter(nama),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------------- Video ----------------
  Widget _seksiVideo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _judulSeksi('Video'),
        const SizedBox(height: 14),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _daftarVideo.length,
            itemBuilder: (context, index) {
              final data = _daftarVideo[index];
              return Padding(
                padding: const EdgeInsets.only(right: 14),
                child: _KartuVideo(
                  data: data,
                  onTap: () => _bukaItem(data.judul, 'Video'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------------- Musik ----------------
  Widget _seksiMusik() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _judulSeksi('Musik & Instrumental'),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: _daftarLagu.length,
          // Tinggi tetap agar tidak overflow
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 76,
          ),
          itemBuilder: (context, index) {
            final lagu = _daftarLagu[index];
            return _KartuLagu(
              data: lagu,
              onTap: () => _bukaItem('${lagu.judul} – ${lagu.artis}', 'Musik'),
            );
          },
        ),
      ],
    );
  }

  // ---------------- Artikel ----------------
  Widget _seksiArtikel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _judulSeksi('Artikel'),
        const SizedBox(height: 14),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _daftarArtikel.length,
            itemBuilder: (context, index) {
              final data = _daftarArtikel[index];
              return Padding(
                padding: const EdgeInsets.only(right: 14),
                child: _KartuArtikel(
                  data: data,
                  onTap: () => _bukaItem(data.judul, 'Artikel'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ---------------- Chip filter ----------------
class _ChipFilter extends StatelessWidget {
  final String label;
  final bool aktif;
  final VoidCallback onTap;

  const _ChipFilter({
    required this.label,
    required this.aktif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: aktif ? AppColors.maroon : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.maroon, width: 1.4),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: aktif ? Colors.white : AppColors.maroon,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ---------------- Kartu video ----------------
class _KartuVideo extends StatelessWidget {
  final _VideoData data;
  final VoidCallback onTap;

  const _KartuVideo({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: _kartu,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  data.gambar,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.maroon.withAlpha(40),
                    child: const Icon(
                      Icons.self_improvement,
                      color: AppColors.maroon,
                      size: 56,
                    ),
                  ),
                ),
                // Gradasi gelap agar teks terbaca
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xB3000000)],
                    ),
                  ),
                ),
                const Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 52,
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 12,
                  child: Text(
                    data.judul,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- Kartu lagu ----------------
class _KartuLagu extends StatelessWidget {
  final _LaguData data;
  final VoidCallback onTap;

  const _KartuLagu({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _garis),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  data.cover,
                  width: 58,
                  height: 58,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 58,
                    height: 58,
                    color: _kartu,
                    child: const Icon(
                      Icons.music_note,
                      color: AppColors.maroon,
                      size: 26,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.judul,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _teksGelap,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.artis,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _teksAbu, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- Kartu artikel ----------------
class _KartuArtikel extends StatelessWidget {
  final _ArtikelData data;
  final VoidCallback onTap;

  const _KartuArtikel({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  data.gambar,
                  height: 155,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 155,
                    width: double.infinity,
                    color: _kartu,
                    child: const Icon(
                      Icons.image_outlined,
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