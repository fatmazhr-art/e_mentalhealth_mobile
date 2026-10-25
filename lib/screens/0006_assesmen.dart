import 'package:flutter/material.dart';
import '../widgets/circle_back_button.dart';

import '../theme/app_colors.dart';
import '../widgets/circle_icon_button.dart';
import '0007_soal_penyebab.dart';

const Color _latar = Color(0xFFFCFAF8);
const Color _teksGelap = Color(0xFF1A1A1A);
const Color _kartu = Color(0xFFFEF5EC);
const Color _garis = Color(0xFFEBD9C6);

class AsesmenScreen extends StatefulWidget {
  const AsesmenScreen({super.key});

  @override
  State<AsesmenScreen> createState() => _AsesmenScreenState();
}

class _AsesmenScreenState extends State<AsesmenScreen> {
  // Pilihan jawaban DASS-21 (skor 0-3 sesuai urutan)
  static const List<String> _pilihan = [
    'Tidak Pernah',
    'Kadang-kadang',
    'Sering',
    'Sangat Sering',
  ];

  // Data pertanyaan contoh. Ganti dengan data dari API nanti.
  static const List<String> _pertanyaan = [
    'Saya merasa bahwa diri saya menjadi marah karena hal-hal sepele.',
    'Saya merasa sulit untuk berpikir positif atau merasa tidak ada harapan.',
  ];

  final _namaCtrl = TextEditingController();
  final _nimCtrl = TextEditingController();
  final _prodiCtrl = TextEditingController();

  bool _anonim = false;

  // index pertanyaan -> index jawaban terpilih
  final Map<int, int> _jawaban = {};

  @override
  void dispose() {
    _namaCtrl.dispose();
    _nimCtrl.dispose();
    _prodiCtrl.dispose();
    super.dispose();
  }

  void _lanjutkan() {
    // TODO: validasi semua pertanyaan sudah dijawab
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SoalPenyebabScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _latar,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleBackButton(),
                    const SizedBox(height: 8),
                    _header(),
                    const SizedBox(height: 28),
                    const _JudulSeksi(
                      ikon: Icons.person_outline,
                      judul: 'Data Diri',
                    ),
                    const SizedBox(height: 14),
                    _formDataDiri(),
                    const SizedBox(height: 28),
                    const _JudulSeksi(
                      ikon: Icons.assignment_outlined,
                      judul: 'Pertanyaan Kuesioner',
                    ),
                    const SizedBox(height: 14),
                    for (var i = 0; i < _pertanyaan.length; i++) ...[
                      _KartuPertanyaan(
                        nomor: i + 1,
                        teks: _pertanyaan[i],
                        pilihan: _pilihan,
                        terpilih: _jawaban[i],
                        onPilih: (v) => setState(() => _jawaban[i] = v),
                      ),
                      const SizedBox(height: 16),
                    ],
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
                  onPressed: _lanjutkan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.maroon,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Lanjutkan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.favorite,
              color: AppColors.maroon,
              size: 120,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Asesmen Online DASS-21',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _teksGelap,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Pilih jawaban sesuai dengan kondisi yang kamu rasakan',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
      ],
    );
  }

  Widget _formDataDiri() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _namaCtrl,
          enabled: !_anonim,
          decoration: _dekorasi('Nama User/Anonim'),
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _nimCtrl,
                enabled: !_anonim,
                keyboardType: TextInputType.number,
                decoration: _dekorasi('NIM'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _prodiCtrl,
                decoration: _dekorasi('Program Studi'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => _anonim = !_anonim),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _anonim,
                activeColor: AppColors.maroon,
                side: const BorderSide(color: AppColors.maroon, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                onChanged: (v) => setState(() => _anonim = v ?? false),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Skreening Anonim?',
                        style: TextStyle(
                          color: _teksGelap,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Centang ini jika ingin menyamarkan identitas '
                        '(Nama & NIM) pada hasil skrinning.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration _dekorasi(String label) {
    OutlineInputBorder garis(Color warna, [double lebar = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: warna, width: lebar),
      );
    }

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.shade600),
      floatingLabelStyle: const TextStyle(color: AppColors.maroon),
      filled: true,
      fillColor: _kartu,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: garis(_garis),
      enabledBorder: garis(_garis),
      disabledBorder: garis(_garis),
      focusedBorder: garis(AppColors.maroon, 1.6),
    );
  }
}

// ---------------- Tombol kembali bulat ----------------
class _TombolKembali extends StatelessWidget {
  const _TombolKembali();
  @override
  Widget build(BuildContext context) => const CircleBackButton();
}

// ---------------- Judul seksi ----------------
class _JudulSeksi extends StatelessWidget {
  final IconData ikon;
  final String judul;

  const _JudulSeksi({required this.ikon, required this.judul});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(ikon, color: AppColors.maroon, size: 24),
        const SizedBox(width: 8),
        Text(
          judul,
          style: const TextStyle(
            color: _teksGelap,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

// ---------------- Kartu pertanyaan ----------------
class _KartuPertanyaan extends StatelessWidget {
  final int nomor;
  final String teks;
  final List<String> pilihan;
  final int? terpilih;
  final ValueChanged<int> onPilih;

  const _KartuPertanyaan({
    required this.nomor,
    required this.teks,
    required this.pilihan,
    required this.terpilih,
    required this.onPilih,
  });

  @override
  Widget build(BuildContext context) {
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
          Text(
            '$nomor. $teks',
            style: const TextStyle(
              color: _teksGelap,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < pilihan.length; i++) ...[
            _PilihanJawaban(
              label: pilihan[i],
              aktif: terpilih == i,
              onTap: () => onPilih(i),
            ),
            if (i != pilihan.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _PilihanJawaban extends StatelessWidget {
  final String label;
  final bool aktif;
  final VoidCallback onTap;

  const _PilihanJawaban({
    required this.label,
    required this.aktif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: aktif ? AppColors.maroon.withAlpha(26) : _latar,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: aktif ? AppColors.maroon : _garis,
            width: aktif ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              aktif
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: aktif ? AppColors.maroon : Colors.grey.shade500,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: _teksGelap,
                  fontSize: 14,
                  fontWeight: aktif ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}