import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

const Color _latar = Color(0xFFFCFAF8);
const Color _teksGelap = Color(0xFF222222);
const Color _teksAbu = Color(0xFF666666);
const Color _kartu = Color(0xFFFEF5EC);
const Color _garis = Color(0xFFEBD9C6);

// ---------------- Data mood ----------------
// Gambar: export dari Figma ke assets/images/.
// Jika file belum ada, otomatis tampil ikon pengganti.
enum Mood {
  luarBiasa('Luar Biasa', 'assets/images/mood_luar_biasa.png',
      Icons.sentiment_very_satisfied),
  gembira('Gembira', 'assets/images/mood_gembira.png',
      Icons.sentiment_satisfied_alt),
  biasaSaja('Biasa saja', 'assets/images/mood_biasa.png',
      Icons.sentiment_neutral),
  sedih('Sedih', 'assets/images/mood_sedih.png',
      Icons.sentiment_dissatisfied),
  sangatSedih('Sangat sedih', 'assets/images/mood_sangat_sedih.png',
      Icons.sentiment_very_dissatisfied),
  cemas('Cemas', 'assets/images/mood_cemas.png', Icons.vibration);

  final String label;
  final String gambar;
  final IconData ikon;

  const Mood(this.label, this.gambar, this.ikon);
}

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  static const List<String> _faktor = [
    'Tugas & Praktikum',
    'Keluarga',
    'Magang',
    'Bimbingan Skripsi',
    'Ujian & Kuis',
    'Istirahat cukup',
  ];

  Mood? selectedMood;
  final List<String> selectedFactors = [];
  final TextEditingController journalController = TextEditingController();

  @override
  void dispose() {
    journalController.dispose();
    super.dispose();
  }

  void _toggleFaktor(String nama) {
    setState(() {
      if (!selectedFactors.remove(nama)) selectedFactors.add(nama);
    });
  }

  void _simpan() {
    final messenger = ScaffoldMessenger.of(context);

    if (selectedMood == null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Silakan pilih perasaan Anda hari ini terlebih dahulu.'),
          ),
        );
      return;
    }

    // TODO: kirim selectedMood, selectedFactors, dan isi jurnal ke backend
    debugPrint('Mood: ${selectedMood!.label}, '
        'Faktor: $selectedFactors, '
        'Jurnal: ${journalController.text.trim()}');

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Jurnal dan Mood berhasil disimpan!')),
      );

    // Kembali ke halaman utama
    Navigator.maybePop(context);
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
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _seksiMood(),
                    const SizedBox(height: 28),
                    _seksiFaktor(),
                    const SizedBox(height: 28),
                    _seksiJurnal(),
                  ],
                ),
              ),
            ),
            _tombolSimpan(),
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
              'Mood Tracker & Jurnal',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _teksGelap,
                fontSize: 18,
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

  // ---------------- Pilih mood ----------------
  Widget _seksiMood() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bagaimana Perasaan Anda hari ini?',
          style: TextStyle(
            color: _teksGelap,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Monitor perasaan anda tiap hari untuk mengenali setiap perubahan '
          'perasaan anda setiap hari.',
          style: TextStyle(color: _teksAbu, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 16),
        _barisMood(0, 3),
        const SizedBox(height: 16),
        _barisMood(3, 6),
      ],
    );
  }

  // ---------------- Baris Mood -----------------------
    Widget _barisMood(int awal, int akhir) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = awal; i < akhir; i++) ...[
          if (i != awal) const SizedBox(width: 16),
          Expanded(
            child: _KartuMood(
              mood: Mood.values[i],
              aktif: selectedMood == Mood.values[i],
              onTap: () => setState(() => selectedMood = Mood.values[i]),
            ),
          ),
        ],
      ],
    );
  }

  // ---------------- Faktor pemengaruh ----------------
  Widget _seksiFaktor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Apa yang paling memengaruhi perasaan mu?',
          style: TextStyle(
            color: _teksGelap,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Pilih hal yang paling berdampak padamu hari ini.',
          style: TextStyle(color: _teksAbu, fontSize: 13),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _faktor
              .map(
                (f) => _ChipFaktor(
                  label: f,
                  aktif: selectedFactors.contains(f),
                  onTap: () => _toggleFaktor(f),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  // ---------------- Jurnal ----------------
  Widget _seksiJurnal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jurnal',
          style: TextStyle(
            color: _teksGelap,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: journalController,
          minLines: 3,
          maxLines: 5,
          textCapitalization: TextCapitalization.sentences,
          style: const TextStyle(color: _teksGelap, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'catatan...',
            hintStyle: const TextStyle(color: _teksAbu),
            filled: true,
            fillColor: _kartu,
            contentPadding: const EdgeInsets.all(16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: _garis),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide:
                  const BorderSide(color: AppColors.maroon, width: 1.6),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- Tombol simpan ----------------
  Widget _tombolSimpan() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      decoration: const BoxDecoration(
        color: _latar,
        border: Border(top: BorderSide(color: _garis)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: _simpan,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.maroon,
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: const Text(
            'SIMPAN',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- Kartu mood ----------------
class _KartuMood extends StatelessWidget {
  final Mood mood;
  final bool aktif;
  final VoidCallback onTap;

  const _KartuMood({
    required this.mood,
    required this.aktif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gambar kartu ditampilkan apa adanya; yang terpilih sedikit membesar
          AnimatedScale(
            scale: aktif ? 1.08 : 1,
            duration: const Duration(milliseconds: 180),
            child: Image.asset(
              mood.gambar,
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => SizedBox(
                height: 90,
                child: Center(
                  child: Icon(mood.ikon, color: AppColors.maroon, size: 44),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            mood.label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: aktif ? AppColors.maroon : _teksGelap,
              fontSize: 13,
              fontWeight: aktif ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Chip faktor (multi-select) ----------------
class _ChipFaktor extends StatelessWidget {
  final String label;
  final bool aktif;
  final VoidCallback onTap;

  const _ChipFaktor({
    required this.label,
    required this.aktif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: aktif,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      labelStyle: TextStyle(
        color: aktif ? AppColors.maroon : _teksGelap,
        fontSize: 13,
        fontWeight: aktif ? FontWeight.w700 : FontWeight.w400,
      ),
      backgroundColor: _kartu,
      selectedColor: AppColors.maroon.withAlpha(26),
      side: BorderSide(
        color: aktif ? AppColors.maroon : _garis,
        width: aktif ? 1.6 : 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}