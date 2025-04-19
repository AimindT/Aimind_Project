import 'package:aimind/screens/functionalities_Screens/terapia_Rapida/ArcChooser.dart';
import 'package:flutter/material.dart';

class ChooserPainter extends CustomPainter {
  final List<ArcItem> arcItems;
  final double sweepAngle;

  ChooserPainter(this.arcItems, this.sweepAngle);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30.0;

    final radius = size.width / 2.5;
    final center = Offset(size.width / 2, size.height);

    for (var arc in arcItems) {
      paint.shader = SweepGradient(
        startAngle: arc.startAngle,
        endAngle: arc.startAngle + sweepAngle,
        colors: arc.colors,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        arc.startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
