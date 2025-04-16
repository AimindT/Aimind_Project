import 'package:flutter/material.dart';

class SmilePainter extends CustomPainter {
  final double slideValue;

  SmilePainter(this.slideValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint facePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [
          Color(0xFFFFE082),
          Color(0xFFFFCA28),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Paint featurePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final Paint eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    canvas.drawCircle(center, radius, facePaint);

    Path smilePath = Path();

    double smileWidth = size.width * 0.6;
    double smileHeight = size.height * 0.25;

    double startX = (size.width - smileWidth) / 2;
    double endX = startX + smileWidth;

    double controlPointX = size.width / 2;
    double controlPointY;

    if (slideValue <= 0.25) {
      double t = slideValue / 0.25;
      controlPointY = size.height * (0.55 + (0.5 - 0.55) * t);
    } else if (slideValue <= 0.5) {
      double t = (slideValue - 0.25) / 0.25;
      controlPointY = size.height * (0.5 + (0.6 - 0.5) * t);
    } else if (slideValue <= 0.75) {
      double t = (slideValue - 0.5) / 0.25;
      controlPointY = size.height * (0.6 + (0.5 - 0.6) * t);
    } else {
      double t = (slideValue - 0.75) / 0.25;
      controlPointY = size.height * (0.5 + (0.45 - 0.5) * t);
    }

    smilePath.moveTo(startX, size.height * 0.7);
    smilePath.quadraticBezierTo(
      controlPointX,
      controlPointY,
      endX,
      size.height * 0.7,
    );
    canvas.drawPath(smilePath, featurePaint);

    Offset leftEye;
    Offset rightEye;

    if (slideValue <= 0.25) {
      double t = slideValue / 0.25;
      leftEye = Offset(
        size.width * (0.35 + (0.34 - 0.35) * t),
        size.height * (0.35 + (0.36 - 0.35) * t),
      );
      rightEye = Offset(
        size.width * (0.65 + (0.66 - 0.65) * t),
        size.height * (0.35 + (0.36 - 0.35) * t),
      );
    } else if (slideValue <= 0.5) {
      double t = (slideValue - 0.25) / 0.25;
      leftEye = Offset(
        size.width * (0.34 + (0.35 - 0.34) * t),
        size.height * (0.36 + (0.34 - 0.36) * t),
      );
      rightEye = Offset(
        size.width * (0.66 + (0.65 - 0.66) * t),
        size.height * (0.36 + (0.34 - 0.36) * t),
      );
    } else if (slideValue <= 0.75) {
      double t = (slideValue - 0.5) / 0.25;
      leftEye = Offset(
        size.width * (0.35 + (0.34 - 0.35) * t),
        size.height * (0.34 + (0.36 - 0.34) * t),
      );
      rightEye = Offset(
        size.width * (0.65 + (0.66 - 0.65) * t),
        size.height * (0.34 + (0.36 - 0.34) * t),
      );
    } else {
      double t = (slideValue - 0.75) / 0.25;
      leftEye = Offset(
        size.width * (0.34 + (0.35 - 0.34) * t),
        size.height * (0.36 + (0.35 - 0.36) * t),
      );
      rightEye = Offset(
        size.width * (0.66 + (0.65 - 0.66) * t),
        size.height * (0.36 + (0.35 - 0.36) * t),
      );
    }

    canvas.drawCircle(leftEye, 5.0, eyePaint);
    canvas.drawCircle(rightEye, 5.0, eyePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
