import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _primary = Color(0xFF7B1E2B);
const _textDark = Color(0xFF4A1420);
const _textMuted = Color(0xFF7A5A5F);
const _beige = Color(0xFFF1E3D5);
const _inputFill = Color(0xFFF9E8E5);
const _infoBg = Color(0xFFFFE8E8);

TextStyle _t(double size,
        {FontWeight weight = FontWeight.w400, Color color = _textDark}) =>
    GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);

class NotifikasiJamOperasionalScreen extends StatefulWidget {
  const NotifikasiJamOperasionalScreen({super.key});

  @override
  State<NotifikasiJamOperasionalScreen> createState() =>
      _NotifikasiJamOperasionalScreenState();
}

class _NotifikasiJamOperasionalScreenState
    extends State<NotifikasiJamOperasionalScreen> {
  // Toggle pengingat
  bool _pengingatAktif = true;

  // Hari praktik: index 0=Sen … 6=Min
  final List<bool> _hariAktif = [true, true, true, true, true, false, false];
  static const _namaHari = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  // Ingatkan saya — 0 = Tepat waktu, 1 = 15 menit, 2 = 30 menit
  int _ingatIdx = 1;
  static const _ingatOptions = [
    'Tepat waktu',
    '15 menit sebelum',
    '30 menit sebelum',
  ];

  void _simpan() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Perubahan berhasil disimpan',
            style: _t(13.5, color: Colors.white)),
        backgroundColor: _primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kartu toggle pengingat
                    _buildToggleCard(),
                    const SizedBox(height: 24),

                    // Jam operasional
                    _buildJamOperasional(),
                    const SizedBox(height: 24),

                    // Hari praktik
                    _buildHariPraktik(),
                    const SizedBox(height: 24),

                    // Ingatkan saya
                    _buildIngatkanSaya(),
                    const SizedBox(height: 24),

                    // Info box
                    _buildInfoBox(),
                    const SizedBox(height: 32),

                    // Tombol simpan
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _simpan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        child: Text('Simpan Perubahan',
                            style: _t(15,
                                weight: FontWeight.w600,
                                color: Colors.white)),
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
                          backgroundColor: _beige,
                          foregroundColor: _primary,
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        child: Text('Batal',
                            style: _t(15,
                                weight: FontWeight.w600, color: _primary)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0C9C9))),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            iconSize: 40,
            color: _primary,
            icon: const Icon(Icons.arrow_circle_left_outlined),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Notifikasi Jam Operasional',
              textAlign: TextAlign.center,
              style: _t(16, weight: FontWeight.w700),
            ),
          ),
          // Placeholder agar judul benar-benar center
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // ── Toggle pengingat ────────────────────────────────────────────────────

  Widget _buildToggleCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEBD8CB), width: 1.2),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pengingat Jam Operasional',
                    style: _t(14, weight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Terima notifikasi sebelum sesi dimulai',
                    style: _t(12.5, color: _textMuted)),
              ],
            ),
          ),
          Switch(
            value: _pengingatAktif,
            onChanged: (v) => setState(() => _pengingatAktif = v),
            activeThumbColor: Colors.white,
            activeTrackColor: _primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFCCC0C0),
          ),
        ],
      ),
    );
  }

  // ── Jam operasional ─────────────────────────────────────────────────────

  Widget _buildJamOperasional() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Jam Operasional', style: _t(14, weight: FontWeight.w700)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _JamField(label: '08.00 WIB')),
            const SizedBox(width: 12),
            Expanded(child: _JamField(label: '16.00 WIB')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.lock_outline_rounded,
                size: 14, color: _textMuted),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'Jam ditetapkan oleh Admin. Tidak dapat diubah.',
                style: _t(12, color: _textMuted),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Hari praktik ────────────────────────────────────────────────────────

  Widget _buildHariPraktik() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hari Praktik', style: _t(14, weight: FontWeight.w700)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(_namaHari.length, (i) {
            final aktif = _hariAktif[i];
            return GestureDetector(
              onTap: () => setState(() => _hariAktif[i] = !_hariAktif[i]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: aktif ? _primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: aktif ? _primary : const Color(0xFFBFA8AD),
                    width: 1.4,
                  ),
                ),
                child: Text(
                  _namaHari[i],
                  style: _t(13,
                      weight: FontWeight.w600,
                      color: aktif ? Colors.white : _textMuted),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── Ingatkan saya ───────────────────────────────────────────────────────

  Widget _buildIngatkanSaya() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ingatkan Saya', style: _t(14, weight: FontWeight.w700)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(_ingatOptions.length, (i) {
            final aktif = _ingatIdx == i;
            return GestureDetector(
              onTap: () => setState(() => _ingatIdx = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: aktif ? _primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: aktif ? _primary : const Color(0xFFBFA8AD),
                    width: 1.4,
                  ),
                ),
                child: Text(
                  _ingatOptions[i],
                  style: _t(13,
                      weight: FontWeight.w600,
                      color: aktif ? Colors.white : _textMuted),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── Info box ────────────────────────────────────────────────────────────

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _infoBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: _primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Mahasiswa hanya dapat memulai chat saat status kamu '
              'Aktif pada jam operasional.',
              style: _t(12.5, color: _textDark),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Field jam (read-only) ─────────────────────────────────────────────────

class _JamField extends StatelessWidget {
  final String label;
  const _JamField({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: _inputFill,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: _t(14,
                    weight: FontWeight.w500, color: _textDark)),
          ),
          const Icon(Icons.lock_outline_rounded,
              color: _textMuted, size: 16),
        ],
      ),
    );
  }
}
