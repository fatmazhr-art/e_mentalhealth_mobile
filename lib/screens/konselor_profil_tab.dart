import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_storage.dart';
import 'konselor_login_screen.dart';
import 'ubah_profil_screen.dart';
import 'kelola_kata_sandi_screen.dart';

const _primary = Color(0xFF7B1E2B);
const _textDark = Color(0xFF4A1420);
const _textMuted = Color(0xFF7A5A5F);
const _beige = Color(0xFFF1E3D5);
const _badgeBg = Color(0xFFFFD9D9);
const _shadow = Color(0x14000000);

TextStyle _t(double size,
        {FontWeight weight = FontWeight.w400, Color color = _textDark}) =>
    GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);

/// Tab Profil lengkap sesuai desain Figma.
class KonselorProfilTab extends StatefulWidget {
  const KonselorProfilTab({super.key});

  @override
  State<KonselorProfilTab> createState() => _KonselorProfilTabState();
}

class _KonselorProfilTabState extends State<KonselorProfilTab> {
  bool _notifAktif = true;

  Future<void> _logout() async {
    await AuthStorage.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const KonselorLoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildWaveHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
            child: Column(
              children: [
                const SizedBox(height: 52), // ruang avatar yang overlap
                _buildNameCard(),
                const SizedBox(height: 24),
                _buildMenuCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Wave header + avatar ─────────────────────────────────────────────────

  Widget _buildWaveHeader() {
    return SizedBox(
      height: 170,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox.expand(child: CustomPaint(painter: _WavePainter())),
          Positioned(
            bottom: -44,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _beige,
                  border: Border.all(color: _primary, width: 3),
                  boxShadow: const [
                    BoxShadow(
                        color: _shadow, blurRadius: 12, offset: Offset(0, 4)),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'SV',
                  style: _t(28, weight: FontWeight.w800, color: _primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Kartu nama ───────────────────────────────────────────────────────────

  Widget _buildNameCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: _primary.withValues(alpha: 0.35), width: 1.5),
        boxShadow: const [
          BoxShadow(color: _shadow, blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text('DR. SARAH V., SP.KJ',
              style: _t(17, weight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('Spesialis Kedokteran Jiwa',
              style: _t(13.5, color: _textMuted)),
        ],
      ),
    );
  }

  // ── Kartu menu ───────────────────────────────────────────────────────────

  Widget _buildMenuCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: _primary.withValues(alpha: 0.35), width: 1.5),
        boxShadow: const [
          BoxShadow(color: _shadow, blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          _MenuItem(
            label: 'Ubah Profil',
            trailing:
                const Icon(Icons.chevron_right_rounded, color: _primary, size: 24),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UbahProfilScreen()),
            ),
          ),
          const _Divider(),
          _MenuItem(
            label: 'Kelola Kata Sandi',
            trailing:
                const Icon(Icons.chevron_right_rounded, color: _primary, size: 24),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const KelolaKataSandiScreen()),
            ),
          ),
          const _Divider(),
          _MenuItem(
            label: 'Notifikasi Jam Operasional',
            trailing: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _badgeBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _notifAktif ? 'Aktif' : 'Nonaktif',
                style: _t(12.5, weight: FontWeight.w500, color: _primary),
              ),
            ),
            onTap: () => setState(() => _notifAktif = !_notifAktif),
          ),
          const _Divider(),
          _MenuItem(
            label: 'Keluar',
            trailing: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.logout_rounded,
                  color: Colors.white, size: 20),
            ),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}

// ── Komponen lokal ──────────────────────────────────────────────────────────

class _MenuItem extends StatelessWidget {
  final String label;
  final Widget trailing;
  final VoidCallback onTap;

  const _MenuItem(
      {required this.label, required this.trailing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4A1420),
                  ),
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) => const Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFFF0E4DC),
        indent: 20,
        endIndent: 20,
      );
}

// ── Wave painter ────────────────────────────────────────────────────────────

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Layer paling belakang – merah muda paling terang
    final p1 = Paint()..color = const Color(0xFFE8919D);
    final path1 = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h * 0.85)
      ..cubicTo(w * 0.75, h * 1.00, w * 0.45, h * 0.70, w * 0.20, h * 0.88)
      ..cubicTo(w * 0.10, h * 0.93, 0, h * 0.85, 0, h * 0.85)
      ..close();
    canvas.drawPath(path1, p1);

    // Layer tengah – merah muda medium
    final p2 = Paint()..color = const Color(0xFFD44F61);
    final path2 = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h * 0.70)
      ..cubicTo(w * 0.72, h * 0.88, w * 0.45, h * 0.58, w * 0.22, h * 0.75)
      ..cubicTo(w * 0.11, h * 0.82, 0, h * 0.72, 0, h * 0.72)
      ..close();
    canvas.drawPath(path2, p2);

    // Layer depan – maroon
    final p3 = Paint()..color = const Color(0xFF7B1E2B);
    final path3 = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h * 0.55)
      ..cubicTo(w * 0.68, h * 0.74, w * 0.40, h * 0.44, w * 0.18, h * 0.62)
      ..cubicTo(w * 0.09, h * 0.68, 0, h * 0.60, 0, h * 0.60)
      ..close();
    canvas.drawPath(path3, p3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
