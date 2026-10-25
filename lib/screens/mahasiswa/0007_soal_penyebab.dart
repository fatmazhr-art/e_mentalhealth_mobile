import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '0008(1)_hasil_asesmen_anonim.dart';
import '0008(2)_hasil_asesmen_detail.dart';
import 'package:e_mentalhealth_mobile/models/hasil_asesmen.dart';

const Color _latar = Color(0xFFFCFAF8);
const Color _teksGelap = Color(0xFF1A1A1A);
const Color _kartu = Color(0xFFFEF5EC);
const Color _garis = Color(0xFFEBD9C6);

class SoalPenyebabScreen extends StatefulWidget {
  /// Parameter penanda status autentikasi.
  /// Set [isAnonim = true] jika diakses oleh Tamu/Guest.
  /// Set [isAnonim = false] jika diakses oleh Pengguna yang sudah Login.
  final bool isAnonim;

  const SoalPenyebabScreen({
    super.key,
    this.isAnonim = false,
  });

  @override
  State<SoalPenyebabScreen> createState() => _SoalPenyebabScreenState();
}

class _SoalPenyebabScreenState extends State<SoalPenyebabScreen> {
  static const int _maksKarakter = 200;

  static const List<String> _penyebab = [
    'Tugas Akhir',
    'Magang',
    'Keluarga',
    'Keuangan',
    'Hubungan',
    'Kesehatan',
    'Akademik',
    'Lainnya',
  ];

  static const List<String> _subPenyebab = [
    'Keluarga',
    'Keuangan',
    'Hubungan',
    'Kesehatan',
    'Akademik',
    'Masa depan dan karier',
  ];

  final Set<String> _penyebabTerpilih = {'Tugas Akhir', 'Lainnya'};
  String? _subTerpilih = 'Masa depan dan karier';

  late final TextEditingController _ceritaCtrl = TextEditingController(
    text: 'Takut tidak diterima kerja setelah lulus karena persaingannya '
        'ketat dan pengalamanku masih sedikit.',
  )..addListener(() => setState(() {}));

  @override
  void dispose() {
    _ceritaCtrl.dispose();
    super.dispose();
  }

  void _togglePenyebab(String nama) {
    setState(() {
      if (!_penyebabTerpilih.remove(nama)) _penyebabTerpilih.add(nama);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _latar,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saya merasa sulit bersantai karena...',
                      style: TextStyle(
                        color: _teksGelap,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _penyebab
                          .map(
                            (p) => _ChipPilihan(
                              label: p,
                              aktif: _penyebabTerpilih.contains(p),
                              onTap: () => _togglePenyebab(p),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    _kartuDetail(),
                  ],
                ),
              ),
            ),
            _barBawah(context),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
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
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'Soal Penyebab',
            style: TextStyle(
              color: _teksGelap,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuDetail() {
    final jumlah = _ceritaCtrl.text.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kartu,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _garis),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lebih spesifik soal apa?',
            style: TextStyle(
              color: AppColors.maroon,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _subPenyebab
                .map(
                  (s) => _ChipPilihan(
                    label: s,
                    aktif: _subTerpilih == s,
                    tampilCentang: false,
                    onTap: () => setState(() => _subTerpilih = s),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Ceritakan singkat *',
            style: TextStyle(
              color: _teksGelap,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _ceritaCtrl,
            minLines: 3,
            maxLines: 4,
            maxLength: _maksKarakter,
            style: const TextStyle(color: _teksGelap, fontSize: 14),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'Ceritakan singkat apa yang kamu rasakan...',
              filled: true,
              fillColor: _latar,
              contentPadding: const EdgeInsets.all(16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.maroon.withAlpha(110)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    const BorderSide(color: AppColors.maroon, width: 1.6),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kolom ini wajib diisi',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              Text(
                '$jumlah/$_maksKarakter',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _barBawah(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      decoration: const BoxDecoration(
        color: _latar,
        border: Border(top: BorderSide(color: _garis)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: () => Navigator.maybePop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.maroon,
                  backgroundColor: _kartu,
                  side: const BorderSide(color: _garis),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Kembali',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Data dummy sampel hasil kuis DASS-21
                  final dataHasil = HasilAsesmen.contoh(
                    nama: 'John Doe',
                    nim: '123456789',
                    prodi: 'Teknik Informatika',
                  );

                  // Routing otomatis berdasarkan status anonim
                  if (widget.isAnonim) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HasilAsesmenAnonimScreen(
                          hasil: dataHasil,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HasilAsesmenDetailScreen(
                          hasil: dataHasil,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.maroon,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Lihat Hasil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipPilihan extends StatelessWidget {
  final String label;
  final bool aktif;
  final bool tampilCentang;
  final VoidCallback onTap;

  const _ChipPilihan({
    required this.label,
    required this.aktif,
    required this.onTap,
    this.tampilCentang = true,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: aktif,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      avatar: aktif && tampilCentang
          ? const Icon(Icons.check, size: 18, color: Colors.white)
          : null,
      labelStyle: TextStyle(
        color: aktif ? Colors.white : _teksGelap,
        fontWeight: aktif ? FontWeight.w700 : FontWeight.w400,
      ),
      backgroundColor: Colors.transparent,
      selectedColor: AppColors.maroon,
      side: BorderSide(color: aktif ? AppColors.maroon : _garis, width: 1.2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    );
  }
}