import 'package:flutter/material.dart';
import '../../widgets/circle_back_button.dart';
import 'package:google_fonts/google_fonts.dart';

/// ============================================================================
/// CURHATIN - FLOW KUESIONER KESEHATAN MENTAL (2 LAYAR LENGKAP)
/// Layar 1: Asesmen Online DASS-21
/// Layar 2: Soal Penyebab
/// ============================================================================

// -----------------------------------------------------------------------------
// 🎨 DESIGN SYSTEM & THEME TOKENS
// -----------------------------------------------------------------------------
class CurhatinTheme {
  static const Color primaryMaroon = Color(0xFF800020); // #800020 / #7A0C2E
  static const Color bgCream = Color(0xFFFFFDF9); // Background Cream / Off-white
  static const Color surfaceCream = Color(0xFFFEF5EC); // Warm Light Cream (Cards/Inputs)
  static const Color borderBeige = Color(0xFFEBD9C6); // Border halus krem
  static const Color cardBorderPink = Color(0xFFE8A9B5); // Border aksen kartu DASS-21
  static const Color textDark = Color(0xFF1A1A1A); // Teks gelap netral
  static const Color textMuted = Color(0xFF757575); // Abu-abu netral
}

// =============================================================================
// 📱 LAYAR 1: ASESMEN ONLINE DASS-21
// =============================================================================
class AsesmenOnlineScreen extends StatefulWidget {
  const AsesmenOnlineScreen({super.key});

  @override
  State<AsesmenOnlineScreen> createState() => _AsesmenOnlineScreenState();
}

class _AsesmenOnlineScreenState extends State<AsesmenOnlineScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _prodiController = TextEditingController();

  bool _isAnonim = false;
  final Map<int, int> _jawaban = {};

  final List<String> _pertanyaanList = [
    'Saya merasa bahwa diri saya menjadi marah karena hal-hal sepele.',
    'Saya merasa sulit untuk berpikir positif atau merasa tidak ada harapan.',
  ];

  static const List<String> _opsiJawaban = [
    'Tidak Pernah',
    'Kadang-kadang',
    'Sering',
    'Sangat Sering',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _prodiController.dispose();
    super.dispose();
  }

  void _onLanjutkanPressed() {
    if (!_isAnonim) {
      if (_namaController.text.trim().isEmpty || _nimController.text.trim().isEmpty) {
        _showSnack('Silakan lengkapi Nama dan NIM terlebih dahulu');
        return;
      }
    }

    if (_jawaban.length < _pertanyaanList.length) {
      _showSnack('Lengkapi semua pertanyaan kuesioner terlebih dahulu ya');
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SoalPenyebabScreen(
          namaUser: _isAnonim ? 'Anonim' : _namaController.text.trim(),
          nimUser: _isAnonim ? '-' : _nimController.text.trim(),
          prodiUser: _prodiController.text.trim(),
        ),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg, style: const TextStyle(color: Colors.white, fontSize: 13)),
          backgroundColor: CurhatinTheme.primaryMaroon,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CurhatinTheme.bgCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 28),
                  _buildDataDiri(),
                  const SizedBox(height: 28),
                  _buildKuesioner(),
                  const SizedBox(height: 32),
                  _buildButtonLanjutkan(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Header & Top Bar
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: const CircleBackButton(),
        ),
        const SizedBox(height: 8),
        Image.asset(
          'assets/images/logo_heart.png',
          width: 125,
          height: 125,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: CurhatinTheme.surfaceCream,
              shape: BoxShape.circle,
              border: Border.all(color: CurhatinTheme.borderBeige, width: 1.5),
            ),
            child: const Icon(Icons.favorite_rounded, color: CurhatinTheme.primaryMaroon, size: 75),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Asesmen Online DASS-21',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: CurhatinTheme.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Pilih jawaban sesuai dengan kondisi yang kamu rasakan',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
            color: CurhatinTheme.textMuted,
          ),
        ),
      ],
    );
  }

  // Seksi Data Diri
  Widget _buildDataDiri() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.person, color: CurhatinTheme.primaryMaroon, size: 26),
            const SizedBox(width: 8),
            Text(
              'Data Diri',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: CurhatinTheme.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _buildTextField(controller: _namaController, hint: 'Nama User/Anonim', enabled: !_isAnonim),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _nimController,
                hint: 'NIM',
                enabled: !_isAnonim,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: _prodiController,
                hint: 'Program Studi',
                enabled: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildCheckboxAnonim(),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool enabled = true,
    TextInputType? keyboardType,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: SizedBox(
        height: 48,
        child: TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(fontSize: 13, color: CurhatinTheme.textDark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(fontSize: 13, color: CurhatinTheme.textMuted),
            filled: true,
            fillColor: CurhatinTheme.surfaceCream,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: CurhatinTheme.primaryMaroon, width: 1.2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxAnonim() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: CurhatinTheme.surfaceCream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CurhatinTheme.borderBeige.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: Checkbox(
                  value: _isAnonim,
                  onChanged: (val) => setState(() => _isAnonim = val ?? false),
                  activeColor: CurhatinTheme.primaryMaroon,
                  checkColor: Colors.white,
                  side: const BorderSide(color: CurhatinTheme.primaryMaroon, width: 1.8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => setState(() => _isAnonim = !_isAnonim),
                child: Text(
                  'Skreening Anonim?',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: CurhatinTheme.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              'Centang ini jika ingin menyamarkan identitas (Nama & NIM) pada hasil skrinning.',
              style: GoogleFonts.inter(fontSize: 10.5, color: CurhatinTheme.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  // Seksi Pertanyaan Kuesioner
  Widget _buildKuesioner() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.assignment_outlined, color: CurhatinTheme.primaryMaroon, size: 26),
            const SizedBox(width: 8),
            Text(
              'Pertanyaan Kuesioner',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: CurhatinTheme.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (int i = 0; i < _pertanyaanList.length; i++) ...[
          _QuestionCard(
            nomor: i + 1,
            pertanyaan: _pertanyaanList[i],
            opsiList: _opsiJawaban,
            skorTerpilih: _jawaban[i],
            onOptionSelected: (skor) => setState(() => _jawaban[i] = skor),
          ),
          if (i != _pertanyaanList.length - 1) const SizedBox(height: 18),
        ],
      ],
    );
  }

  // Tombol "Lanjutkan"
  Widget _buildButtonLanjutkan() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _onLanjutkanPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: CurhatinTheme.primaryMaroon,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          'Lanjutkan',
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ---------------- CARD PERTANYAAN DASS-21 ----------------
class _QuestionCard extends StatelessWidget {
  final int nomor;
  final String pertanyaan;
  final List<String> opsiList;
  final int? skorTerpilih;
  final ValueChanged<int> onOptionSelected;

  const _QuestionCard({
    required this.nomor,
    required this.pertanyaan,
    required this.opsiList,
    required this.skorTerpilih,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CurhatinTheme.surfaceCream,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CurhatinTheme.cardBorderPink, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: CurhatinTheme.primaryMaroon.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$nomor. ',
                style: GoogleFonts.nunito(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: CurhatinTheme.textDark,
                ),
              ),
              Expanded(
                child: Text(
                  pertanyaan,
                  style: GoogleFonts.nunito(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                    color: CurhatinTheme.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (int skor = 0; skor < opsiList.length; skor++) ...[
            _SelectableOptionPill(
              label: opsiList[skor],
              isSelected: skorTerpilih == skor,
              onTap: () => onOptionSelected(skor),
            ),
            if (skor != opsiList.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _SelectableOptionPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableOptionPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? CurhatinTheme.primaryMaroon : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          height: 44,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? CurhatinTheme.primaryMaroon
                  : CurhatinTheme.borderBeige.withOpacity(0.6),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : CurhatinTheme.textDark,
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 📱 LAYAR 2: SOAL PENYEBAB
// =============================================================================
class SoalPenyebabScreen extends StatefulWidget {
  final String? namaUser;
  final String? nimUser;
  final String? prodiUser;

  const SoalPenyebabScreen({
    super.key,
    this.namaUser,
    this.nimUser,
    this.prodiUser,
  });

  @override
  State<SoalPenyebabScreen> createState() => _SoalPenyebabScreenState();
}

class _SoalPenyebabScreenState extends State<SoalPenyebabScreen> {
  static const int maksKarakter = 200;

  static const List<String> _kategoriPenyebab = [
    'Tugas Akhir',
    'Magang',
    'Keluarga',
    'Keuangan',
    'Hubungan',
    'Kesehatan',
    'Akademik',
    'Lainnya',
  ];

  static const List<String> _subKategori = [
    'Keluarga',
    'Keuangan',
    'Hubungan',
    'Kesehatan',
    'Akademik',
    'Masa depan dan karier',
  ];

  // Default terpilih sesuai permintaan: 'Tugas Akhir' dan 'Lainnya'
  final Set<String> _penyebabTerpilih = {'Tugas Akhir', 'Lainnya'};
  String? _subKategoriTerpilih = 'Masa depan dan karier';

  late final TextEditingController _ceritaController = TextEditingController(
    text: 'Takut tidak diterima kerja setelah lulus karena persaingannya ketat dan pengalamanku masih sedikit.',
  )..addListener(() => setState(() {}));

  @override
  void dispose() {
    _ceritaController.dispose();
    super.dispose();
  }

  void _togglePenyebab(String kategori) {
    setState(() {
      if (_penyebabTerpilih.contains(kategori)) {
        _penyebabTerpilih.remove(kategori);
      } else {
        _penyebabTerpilih.add(kategori);
      }
    });
  }

  void _onLihatHasilPressed() {
    if (_ceritaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Kolom cerita singkat wajib diisi ya'),
          backgroundColor: CurhatinTheme.primaryMaroon,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    // Modal / Dialog hasil asesmen
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CurhatinTheme.surfaceCream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Asesmen Berhasil!',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: CurhatinTheme.primaryMaroon,
          ),
        ),
        content: Text(
          'Terima kasih telah mengisi kuesioner asesmen mandiri DASS-21 dan soal penyebab.\n\nData kamu telah tersimpan dengan aman.',
          style: GoogleFonts.inter(fontSize: 14, color: CurhatinTheme.textDark),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CurhatinTheme.primaryMaroon,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Kembali ke Beranda'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CurhatinTheme.bgCream,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSeksiPenyebabUtama(),
                        const SizedBox(height: 24),
                        _buildCardDetailPenyebab(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildBottomActionBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Row(
            children: [
              const CircleBackButton(),
              const SizedBox(width: 14),
              Text(
                'Soal Penyebab',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: CurhatinTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeksiPenyebabUtama() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saya merasa sulit bersantai karena...',
          style: GoogleFonts.inter(
            color: CurhatinTheme.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: _kategoriPenyebab.map((kategori) {
            final isSelected = _penyebabTerpilih.contains(kategori);
            return _SelectableTagChip(
              label: kategori,
              isSelected: isSelected,
              showCheckmark: true,
              onTap: () => _togglePenyebab(kategori),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCardDetailPenyebab() {
    final currentLength = _ceritaController.text.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CurhatinTheme.surfaceCream,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: CurhatinTheme.borderBeige, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: CurhatinTheme.primaryMaroon.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lebih spesifik soal apa?',
            style: GoogleFonts.inter(
              color: CurhatinTheme.primaryMaroon,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: _subKategori.map((sub) {
              final isSelected = _subKategoriTerpilih == sub;
              return _SelectableTagChip(
                label: sub,
                isSelected: isSelected,
                showCheckmark: false,
                onTap: () => setState(() => _subKategoriTerpilih = sub),
              );
            }).toList(),
          ),
          const SizedBox(height: 22),
          Text(
            'Ceritakan singkat *',
            style: GoogleFonts.inter(
              color: CurhatinTheme.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _ceritaController,
            minLines: 3,
            maxLines: 4,
            maxLength: maksKarakter,
            style: GoogleFonts.inter(color: CurhatinTheme.textDark, fontSize: 13.5, height: 1.4),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'Ceritakan singkat apa yang kamu rasakan...',
              hintStyle: GoogleFonts.inter(color: CurhatinTheme.textMuted, fontSize: 13),
              filled: true,
              fillColor: CurhatinTheme.bgCream,
              contentPadding: const EdgeInsets.all(16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: CurhatinTheme.primaryMaroon.withOpacity(0.4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: CurhatinTheme.primaryMaroon, width: 1.6),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kolom ini wajib diisi',
                style: GoogleFonts.inter(color: CurhatinTheme.textMuted, fontSize: 11.5),
              ),
              Text(
                '$currentLength/$maksKarakter',
                style: GoogleFonts.inter(
                  color: CurhatinTheme.textMuted,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
      decoration: const BoxDecoration(
        color: CurhatinTheme.bgCream,
        border: Border(top: BorderSide(color: CurhatinTheme.borderBeige, width: 0.8)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => Navigator.maybePop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CurhatinTheme.primaryMaroon,
                      backgroundColor: CurhatinTheme.surfaceCream,
                      side: const BorderSide(color: CurhatinTheme.borderBeige, width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: Text(
                      'Kembali',
                      style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _onLihatHasilPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CurhatinTheme.primaryMaroon,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: Text(
                      'Lihat Hasil',
                      style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
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

// ---------------- REUSABLE CHIP TAG (WRAP LAYOUT) ----------------
class _SelectableTagChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool showCheckmark;
  final VoidCallback onTap;

  const _SelectableTagChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.showCheckmark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? CurhatinTheme.primaryMaroon : Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? CurhatinTheme.primaryMaroon : CurhatinTheme.borderBeige,
              width: 1.3,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected && showCheckmark) ...[
                const Icon(Icons.check, size: 16, color: Colors.white),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : CurhatinTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

