import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../widgets/circle_back_button.dart';

import '../theme/app_colors.dart';

const Color _teksGelap = Color(0xFF222222);
const Color _garis = Color(0xFFEBD9C6);

// ---------------- Top bar hasil asesmen ----------------
// Dipakai di layar ringkasan dan layar detail.
class BarAtasHasil extends StatelessWidget {
  final VoidCallback? onBantuan;

  const BarAtasHasil({super.key, this.onBantuan});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: [
          const CircleBackButton(),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Hasil Asesmen Online DASS-21',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  color: _teksGelap,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(
              side: BorderSide(color: _garis, width: 1.5),
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onBantuan ??
                  () {
                    // TODO: buka halaman bantuan / chat konselor
                  },
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.headset_mic_outlined,
                  color: AppColors.maroon,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Lingkaran skor (circular progress kustom) ----------------
class LingkaranSkor extends StatelessWidget {
  final int skor;
  final int skorMaks;
  final double ukuran;
  final double tebal;

  /// Isi di tengah lingkaran. Jika kosong, tampil angka skor.
  final Widget? tengah;

  const LingkaranSkor({
    super.key,
    required this.skor,
    this.skorMaks = 42,
    this.ukuran = 100,
    this.tebal = 10,
    this.tengah,
  });

  @override
  Widget build(BuildContext context) {
    final progres = (skor / skorMaks).clamp(0.0, 1.0);

    return SizedBox(
      width: ukuran,
      height: ukuran,
      child: CustomPaint(
        painter: _LingkaranSkorPainter(progres: progres, tebal: tebal),
        child: Center(
          child: tengah ??
              Text(
                '$skor',
                style: TextStyle(
                  color: _teksGelap,
                  fontSize: ukuran * 0.3,
                  fontWeight: FontWeight.w900,
                ),
              ),
        ),
      ),
    );
  }
}

class _LingkaranSkorPainter extends CustomPainter {
  final double progres; // 0..1
  final double tebal;

  _LingkaranSkorPainter({required this.progres, required this.tebal});

  @override
  void paint(Canvas canvas, Size size) {
    final pusat = size.center(Offset.zero);
    final radius = (math.min(size.width, size.height) - tebal) / 2;
    final area = Rect.fromCircle(center: pusat, radius: radius);

    // Jalur latar
    canvas.drawCircle(
      pusat,
      radius,
      Paint()
        ..color = _garis
        ..style = PaintingStyle.stroke
        ..strokeWidth = tebal,
    );

    // Bagian yang terisi (mulai dari atas, searah jarum jam)
    if (progres > 0) {
      canvas.drawArc(
        area,
        -math.pi / 2,
        2 * math.pi * progres,
        false,
        Paint()
          ..color = AppColors.maroon
          ..style = PaintingStyle.stroke
          ..strokeWidth = tebal
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LingkaranSkorPainter oldDelegate) =>
      oldDelegate.progres != progres || oldDelegate.tebal != tebal;
}