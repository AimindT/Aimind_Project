import 'dart:math';
import 'package:flutter/material.dart';

class SmilePainter extends CustomPainter {
  final double value;

  // Creamos valores normalizados para cada característica que queremos animar
  final double normalizedValue;
  final double previousValue;

  // Constructor con valor anterior para animaciones suaves
  SmilePainter(double slideValue, {double? lastValue})
      : value = slideValue,
        normalizedValue = slideValue / 400.0,
        previousValue =
            lastValue != null ? lastValue / 400.0 : slideValue / 400.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Pintura para el rostro con gradiente radial
    final Paint facePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(0.0, 0.0),
        radius: 0.7,
        colors: const [
          Color(0xFFFFEB3B), // Amarillo más brillante en el centro
          Color(0xFFFFD600), // Amarillo más oscuro en los bordes
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Pintura para ojos y otros detalles
    final Paint featurePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // Pintura para rellenar los ojos
    final Paint eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Pintura para mejillas
    final Paint cheekPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.pink.withOpacity(0.5),
          Colors.pink.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Pintura para brillo en ojos
    final Paint eyeHighlightPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    // Dibujar el rostro
    canvas.drawCircle(center, radius, facePaint);

    // Dibujar el borde del rostro
    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = Colors.orange.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0);

    // Añadir reflejo/brillo (para dar sensación 3D)
    Path highlightPath = Path();
    highlightPath.addArc(
        Rect.fromCircle(
            center: Offset(center.dx - 10, center.dy - 10),
            radius: radius * 0.7),
        degToRad(-40),
        degToRad(100));
    canvas.drawPath(
        highlightPath,
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 15.0
          ..strokeCap = StrokeCap.round);

    // Calcular sonrisa
    Path smilePath = Path();
    double smileWidth = size.width * 0.6;
    double startX = (size.width - smileWidth) / 2;
    double endX = startX + smileWidth;
    double y = size.height * 0.7;

    // Punto de control para la curva de la sonrisa
    double controlPointX = size.width / 2;
    double? controlPointY;

    // Mapear el valor normalizado (0-1) a la curvatura de la sonrisa
    if (normalizedValue <= 0.25) {
      // Mal humor - curva hacia abajo
      controlPointY = lerpDouble(
          size.height * 0.9, size.height * 0.85, normalizedValue * 4);
    } else if (normalizedValue <= 0.5) {
      // Descontento - ligeramente curvado hacia abajo/neutral
      controlPointY = lerpDouble(
          size.height * 0.85, size.height * 0.7, (normalizedValue - 0.25) * 4);
    } else if (normalizedValue <= 0.75) {
      // Bien - ligeramente curvado hacia arriba
      controlPointY = lerpDouble(
          size.height * 0.7, size.height * 0.5, (normalizedValue - 0.5) * 4);
    } else {
      // Excelente - curvado hacia arriba (sonrisa amplia)
      controlPointY = lerpDouble(
          size.height * 0.5, size.height * 0.4, (normalizedValue - 0.75) * 4);
    }

    // Dibujar la sonrisa (o ceño fruncido)
    smilePath.moveTo(startX, y);
    smilePath.quadraticBezierTo(controlPointX, controlPointY!, endX, y);
    canvas.drawPath(
        smilePath,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6.0
          ..strokeCap = StrokeCap.round);

    // Para expresiones más felices, agregar relleno a la sonrisa
    if (normalizedValue > 0.6) {
      // Extender la sonrisa para cerrarla
      smilePath.lineTo(endX, y + 5);
      smilePath.quadraticBezierTo(
          controlPointX, controlPointY + 10, startX, y + 5);
      smilePath.close();

      canvas.drawPath(
          smilePath,
          Paint()
            ..color = Colors.red.withOpacity(0.3)
            ..style = PaintingStyle.fill);
    }

    // Dibujar ojos - forma y posición varían según el estado de ánimo
    double eyeBaseY = size.height * 0.35;
    double leftEyeX = size.width * 0.35;
    double rightEyeX = size.width * 0.65;

    // Ajustar posición de ojos según estado de ánimo
    if (normalizedValue <= 0.25) {
      // Mal humor - ojos inclinados y ceño fruncido
      drawAngryEyes(canvas, size, leftEyeX, rightEyeX, eyeBaseY, eyePaint,
          featurePaint, eyeHighlightPaint);
    } else if (normalizedValue <= 0.5) {
      // Descontento - ojos neutros/cansados
      drawUghEyes(canvas, size, leftEyeX, rightEyeX, eyeBaseY, eyePaint,
          featurePaint, eyeHighlightPaint);
    } else if (normalizedValue <= 0.75) {
      // Bien - ojos normales
      drawNormalEyes(canvas, size, leftEyeX, rightEyeX, eyeBaseY, eyePaint,
          featurePaint, eyeHighlightPaint);
    } else {
      // Excelente - ojos felices (arqueados)
      drawHappyEyes(canvas, size, leftEyeX, rightEyeX, eyeBaseY, eyePaint,
          featurePaint, eyeHighlightPaint);
    }

    // Dibujar mejillas (más visibles cuando está feliz)
    if (normalizedValue > 0.5) {
      double opacidad = lerpDouble(0.0, 0.7, (normalizedValue - 0.5) * 2)!;
      double mejillaRadius = lerpDouble(
          size.width * 0.08, size.width * 0.12, (normalizedValue - 0.5) * 2)!;

      // Mejilla izquierda
      canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.6),
          mejillaRadius, Paint()..color = Colors.pink.withOpacity(opacidad));

      // Mejilla derecha
      canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.6),
          mejillaRadius, Paint()..color = Colors.pink.withOpacity(opacidad));
    }

    // Agregar cejas que se mueven según el estado de ánimo
    drawEyebrows(canvas, size, normalizedValue, featurePaint);

    // Agregar pequeñas gotas de sudor cuando está mal (BAD)
    if (normalizedValue < 0.25) {
      drawSweatDrops(canvas, size, normalizedValue);
    }

    // Agregar brillos/estrellas alrededor cuando está muy feliz (GOOD)
    if (normalizedValue > 0.8) {
      drawSparkles(canvas, size, normalizedValue);
    }
  }

  // Función para dibujar ojos enojados
  void drawAngryEyes(Canvas canvas, Size size, double leftX, double rightX,
      double baseY, Paint eyePaint, Paint outlinePaint, Paint highlightPaint) {
    // Ojos angulados/inclinados para mostrar enojo
    Path leftEyePath = Path();
    Path rightEyePath = Path();

    double eyeWidth = size.width * 0.1;
    double eyeHeight = size.height * 0.06;

    // Ojos ligeramente inclinados hacia adentro para expresar enojo
    leftEyePath.addOval(Rect.fromCenter(
        center: Offset(leftX, baseY), width: eyeWidth, height: eyeHeight));

    rightEyePath.addOval(Rect.fromCenter(
        center: Offset(rightX, baseY), width: eyeWidth, height: eyeHeight));

    canvas.drawPath(leftEyePath, eyePaint);
    canvas.drawPath(rightEyePath, eyePaint);

    // Añadir pequeños brillos a los ojos
    canvas.drawCircle(Offset(leftX - eyeWidth * 0.2, baseY - eyeHeight * 0.2),
        size.width * 0.015, highlightPaint);

    canvas.drawCircle(Offset(rightX - eyeWidth * 0.2, baseY - eyeHeight * 0.2),
        size.width * 0.015, highlightPaint);
  }

  // Función para dibujar ojos descontentos/cansados
  void drawUghEyes(Canvas canvas, Size size, double leftX, double rightX,
      double baseY, Paint eyePaint, Paint outlinePaint, Paint highlightPaint) {
    // Ojos medio cerrados/cansados
    double eyeWidth = size.width * 0.1;
    double eyeHeight = size.height * 0.04; // Más aplanados

    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(leftX, baseY), width: eyeWidth, height: eyeHeight),
        eyePaint);

    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(rightX, baseY), width: eyeWidth, height: eyeHeight),
        eyePaint);

    // Añadir pequeños brillos a los ojos
    canvas.drawCircle(Offset(leftX - eyeWidth * 0.2, baseY), size.width * 0.015,
        highlightPaint);

    canvas.drawCircle(Offset(rightX - eyeWidth * 0.2, baseY),
        size.width * 0.015, highlightPaint);
  }

  // Función para dibujar ojos normales
  void drawNormalEyes(Canvas canvas, Size size, double leftX, double rightX,
      double baseY, Paint eyePaint, Paint outlinePaint, Paint highlightPaint) {
    double eyeRadius = size.width * 0.05;

    // Ojos circulares normales
    canvas.drawCircle(Offset(leftX, baseY), eyeRadius, eyePaint);
    canvas.drawCircle(Offset(rightX, baseY), eyeRadius, eyePaint);

    // Añadir brillos a los ojos
    canvas.drawCircle(Offset(leftX - eyeRadius * 0.4, baseY - eyeRadius * 0.4),
        eyeRadius * 0.4, highlightPaint);

    canvas.drawCircle(Offset(rightX - eyeRadius * 0.4, baseY - eyeRadius * 0.4),
        eyeRadius * 0.4, highlightPaint);
  }

  // Función para dibujar ojos felices
  void drawHappyEyes(Canvas canvas, Size size, double leftX, double rightX,
      double baseY, Paint eyePaint, Paint outlinePaint, Paint highlightPaint) {
    // Crear ojos arqueados (como líneas curvas) para la felicidad
    Path leftEyePath = Path();
    Path rightEyePath = Path();

    double eyeWidth = size.width * 0.1;

    // Ojo izquierdo arqueado
    leftEyePath.moveTo(leftX - eyeWidth / 2, baseY);
    leftEyePath.quadraticBezierTo(
        leftX, baseY - eyeWidth / 2, leftX + eyeWidth / 2, baseY);

    // Ojo derecho arqueado
    rightEyePath.moveTo(rightX - eyeWidth / 2, baseY);
    rightEyePath.quadraticBezierTo(
        rightX, baseY - eyeWidth / 2, rightX + eyeWidth / 2, baseY);

    // Dibujar los ojos
    canvas.drawPath(
        leftEyePath,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5.0
          ..strokeCap = StrokeCap.round);

    canvas.drawPath(
        rightEyePath,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5.0
          ..strokeCap = StrokeCap.round);
  }

  // Función para dibujar cejas
  void drawEyebrows(
      Canvas canvas, Size size, double normalizedValue, Paint paint) {
    double leftX = size.width * 0.35;
    double rightX = size.width * 0.65;
    double baseY = size.height * 0.27;

    double eyebrowWidth = size.width * 0.12;
    double eyebrowSlant;

    if (normalizedValue <= 0.25) {
      // Cejas enojadas - inclinadas hacia el centro
      eyebrowSlant = size.height * 0.04;

      // Ceja izquierda
      canvas.drawLine(
          Offset(leftX - eyebrowWidth / 2, baseY + eyebrowSlant),
          Offset(leftX + eyebrowWidth / 2, baseY - eyebrowSlant),
          Paint()
            ..color = Colors.black
            ..strokeWidth = 5.0
            ..strokeCap = StrokeCap.round);

      // Ceja derecha
      canvas.drawLine(
          Offset(rightX - eyebrowWidth / 2, baseY - eyebrowSlant),
          Offset(rightX + eyebrowWidth / 2, baseY + eyebrowSlant),
          Paint()
            ..color = Colors.black
            ..strokeWidth = 5.0
            ..strokeCap = StrokeCap.round);
    } else if (normalizedValue <= 0.5) {
      // Cejas neutrales - horizontales pero ligeramente inclinadas
      eyebrowSlant = size.height * 0.01;

      // Ceja izquierda
      canvas.drawLine(
          Offset(leftX - eyebrowWidth / 2, baseY),
          Offset(leftX + eyebrowWidth / 2, baseY - eyebrowSlant),
          Paint()
            ..color = Colors.black
            ..strokeWidth = 5.0
            ..strokeCap = StrokeCap.round);

      // Ceja derecha
      canvas.drawLine(
          Offset(rightX - eyebrowWidth / 2, baseY - eyebrowSlant),
          Offset(rightX + eyebrowWidth / 2, baseY),
          Paint()
            ..color = Colors.black
            ..strokeWidth = 5.0
            ..strokeCap = StrokeCap.round);
    } else if (normalizedValue <= 0.75) {
      // Cejas normales - ligeramente arqueadas
      Path leftBrow = Path();
      Path rightBrow = Path();

      leftBrow.moveTo(leftX - eyebrowWidth / 2, baseY);
      leftBrow.quadraticBezierTo(
          leftX, baseY - size.height * 0.02, leftX + eyebrowWidth / 2, baseY);

      rightBrow.moveTo(rightX - eyebrowWidth / 2, baseY);
      rightBrow.quadraticBezierTo(
          rightX, baseY - size.height * 0.02, rightX + eyebrowWidth / 2, baseY);

      canvas.drawPath(
          leftBrow,
          Paint()
            ..color = Colors.black
            ..strokeWidth = 5.0
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke);

      canvas.drawPath(
          rightBrow,
          Paint()
            ..color = Colors.black
            ..strokeWidth = 5.0
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke);
    } else {
      // Cejas felices - muy arqueadas
      Path leftBrow = Path();
      Path rightBrow = Path();

      leftBrow.moveTo(leftX - eyebrowWidth / 2, baseY);
      leftBrow.quadraticBezierTo(leftX, baseY - size.height * 0.04,
          leftX + eyebrowWidth / 2, baseY - size.height * 0.01);

      rightBrow.moveTo(rightX - eyebrowWidth / 2, baseY - size.height * 0.01);
      rightBrow.quadraticBezierTo(
          rightX, baseY - size.height * 0.04, rightX + eyebrowWidth / 2, baseY);

      canvas.drawPath(
          leftBrow,
          Paint()
            ..color = Colors.black
            ..strokeWidth = 5.0
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke);

      canvas.drawPath(
          rightBrow,
          Paint()
            ..color = Colors.black
            ..strokeWidth = 5.0
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke);
    }
  }

  // Función para dibujar gotas de sudor (para el estado BAD)
  void drawSweatDrops(Canvas canvas, Size size, double normalizedValue) {
    // La opacidad aumenta a medida que el valor disminuye (más intenso cuanto más "BAD")
    double opacity = lerpDouble(0.0, 0.8, 1.0 - (normalizedValue * 4))!;

    // Crear la forma de gota
    Path dropPath1 = Path();
    Path dropPath2 = Path();

    double dropWidth = size.width * 0.03;
    double dropHeight = size.height * 0.06;

    // Primera gota cerca de la sien izquierda
    dropPath1.addOval(Rect.fromCenter(
        center: Offset(size.width * 0.2, size.height * 0.3),
        width: dropWidth,
        height: dropHeight));

    // Segunda gota en la frente
    dropPath2.addOval(Rect.fromCenter(
        center: Offset(size.width * 0.8, size.height * 0.28),
        width: dropWidth,
        height: dropHeight));

    // Dibujar las gotas con un gradiente para efecto de brillo
    Paint dropPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(opacity * 0.9),
          Colors.lightBlue.withOpacity(opacity * 0.7),
        ],
      ).createShader(Rect.fromLTWH(0, 0, dropWidth, dropHeight));

    canvas.drawPath(dropPath1, dropPaint);
    canvas.drawPath(dropPath2, dropPaint);
  }

  // Función para dibujar brillos/estrellas (para el estado GOOD)
  void drawSparkles(Canvas canvas, Size size, double normalizedValue) {
    // La opacidad aumenta a medida que el valor aumenta (más brillante cuanto más "GOOD")
    double opacity = lerpDouble(0.0, 0.9, (normalizedValue - 0.8) * 5)!;

    // Dibujar varias estrellas alrededor
    drawStar(canvas, Offset(size.width * 0.15, size.height * 0.2),
        size.width * 0.05, opacity);
    drawStar(canvas, Offset(size.width * 0.85, size.height * 0.2),
        size.width * 0.05, opacity);
    drawStar(canvas, Offset(size.width * 0.5, size.height * 0.1),
        size.width * 0.06, opacity);
  }

  // Función auxiliar para dibujar una estrella
  void drawStar(Canvas canvas, Offset center, double radius, double opacity) {
    final Paint starPaint = Paint()
      ..color = Colors.yellow.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    Path starPath = Path();
    double angle = -pi / 2; // Comenzar desde arriba

    for (int i = 0; i < 10; i++) {
      double currentRadius = i.isEven ? radius : radius * 0.4;
      double x = center.dx + cos(angle) * currentRadius;
      double y = center.dy + sin(angle) * currentRadius;

      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }

      angle += pi / 5;
    }

    starPath.close();
    canvas.drawPath(starPath, starPaint);

    // Añadir brillo central
    canvas.drawCircle(center, radius * 0.3,
        Paint()..color = Colors.white.withOpacity(opacity * 0.8));
  }

  // Función auxiliar para calcular radianes a partir de grados
  double degToRad(double deg) {
    return deg * (pi / 180);
  }

  // Función auxiliar para interpolación lineal de valores dobles
  double? lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
