import 'package:flutter/material.dart';

/// Border putus-putus (dotted/dashed) berujung rounded
class DashedRRectPainter extends CustomPainter {
  final Color color;
  final double radius, dash, gap;
  DashedRRectPainter(
      {required this.color,
      required this.radius,
      required this.dash,
      required this.gap});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Offset.zero & size, Radius.circular(radius)));
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + dash), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedRRectPainter old) =>
      old.color != color || old.radius != radius;
}