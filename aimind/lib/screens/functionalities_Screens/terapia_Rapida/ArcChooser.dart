import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class ArcChooser extends StatefulWidget {
  final ArcSelectedCallback arcSelectedCallback;

  const ArcChooser({super.key, required this.arcSelectedCallback});

  @override
  State<StatefulWidget> createState() {
    return ChooserState(arcSelectedCallback);
  }
}

class ChooserState extends State<ArcChooser>
    with SingleTickerProviderStateMixin {
  late Offset centerPoint;

  double userAngle = 0.0;
  late double startAngle;

  static double center = 270.0;
  static double centerInRadians = degreeToRadians(center);
  static double angle = 45.0;

  static double angleInRadians = degreeToRadians(angle);
  static double angleInRadiansByTwo = angleInRadians / 2;

  late List<ArcItem> arcItems;

  late AnimationController animation;
  late double animationStart;
  double animationEnd = 0.0;

  int currentPosition = 0;

  late Offset startingPoint;
  late Offset endingPoint;

  ArcSelectedCallback arcSelectedCallback;

  ChooserState(this.arcSelectedCallback);

  static double degreeToRadians(double degree) {
    return degree * (pi / 180);
  }

  @override
  void initState() {
    super.initState();

    // Initialize arc items with their appropriate labels and colors
    arcItems = [
      ArcItem("BAD", [Color(0xFFfe0944), Color(0xFFfeae96)],
          angleInRadiansByTwo + userAngle),
      ArcItem("UGH", [Color(0xFFF9D976), Color(0xfff39f86)],
          angleInRadiansByTwo + userAngle + angleInRadians),
      ArcItem("OK", [Color(0xFF21e1fa), Color(0xff3bb8fd)],
          angleInRadiansByTwo + userAngle + (2 * angleInRadians)),
      ArcItem("GOOD", [Color(0xFF3ee98a), Color(0xFF41f7c7)],
          angleInRadiansByTwo + userAngle + (3 * angleInRadians)),
      // The next 4 items repeat the first 4 to complete the circle
      ArcItem("BAD", [Color(0xFFfe0944), Color(0xFFfeae96)],
          angleInRadiansByTwo + userAngle + (4 * angleInRadians)),
      ArcItem("UGH", [Color(0xFFF9D976), Color(0xfff39f86)],
          angleInRadiansByTwo + userAngle + (5 * angleInRadians)),
      ArcItem("OK", [Color(0xFF21e1fa), Color(0xff3bb8fd)],
          angleInRadiansByTwo + userAngle + (6 * angleInRadians)),
      ArcItem("GOOD", [Color(0xFF3ee98a), Color(0xFF41f7c7)],
          angleInRadiansByTwo + userAngle + (7 * angleInRadians)),
    ];

    animation = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    animation.addListener(() {
      userAngle = lerpDouble(animationStart, animationEnd, animation.value)!;
      setState(() {
        for (int i = 0; i < arcItems.length; i++) {
          arcItems[i].startAngle =
              angleInRadiansByTwo + userAngle + (i * angleInRadians);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double centerX = MediaQuery.of(context).size.width / 2;
    double centerY = MediaQuery.of(context).size.height * 1.5;
    centerPoint = Offset(centerX, centerY);

    return GestureDetector(
      onPanStart: (DragStartDetails details) {
        startingPoint = details.globalPosition;
        var deltaX = centerPoint.dx - details.globalPosition.dx;
        var deltaY = centerPoint.dy - details.globalPosition.dy;
        startAngle = atan2(deltaY, deltaX);
      },
      onPanUpdate: (DragUpdateDetails details) {
        endingPoint = details.globalPosition;
        var deltaX = centerPoint.dx - details.globalPosition.dx;
        var deltaY = centerPoint.dy - details.globalPosition.dy;
        var freshAngle = atan2(deltaY, deltaX);
        userAngle += freshAngle - startAngle;
        setState(() {
          for (int i = 0; i < arcItems.length; i++) {
            arcItems[i].startAngle =
                angleInRadiansByTwo + userAngle + (i * angleInRadians);
          }
        });
        startAngle = freshAngle;
      },
      onPanEnd: (DragEndDetails details) {
        bool rightToLeft = startingPoint.dx < endingPoint.dx;

        animationStart = userAngle;
        if (rightToLeft) {
          animationEnd = userAngle + angleInRadians;
          currentPosition = (currentPosition - 1) % arcItems.length;
          if (currentPosition < 0) {
            currentPosition = arcItems.length - 1;
          }
        } else {
          animationEnd = userAngle - angleInRadians;
          currentPosition = (currentPosition + 1) % arcItems.length;
        }

        // Make sure to use modulo 4 for the position to normalize it to 0-3
        arcSelectedCallback(currentPosition % 4, arcItems[currentPosition]);

        animation.forward(from: 0.0);
      },
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.width * 1 / 1.5),
        painter: ChooserPainter(arcItems, angleInRadians),
      ),
    );
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }
}

typedef ArcSelectedCallback = void Function(int position, ArcItem arcitem);

class ArcItem {
  String text;
  List<Color> colors;
  double startAngle;

  ArcItem(this.text, this.colors, this.startAngle);
}

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

    // Draw text labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (var arc in arcItems) {
      // Calculate position for text
      double middleAngle = arc.startAngle + (sweepAngle / 2);
      double textRadius = radius - 15; // Position text slightly inside the arc

      double x = center.dx + textRadius * cos(middleAngle);
      double y = center.dy + textRadius * sin(middleAngle);

      // Prepare and draw text
      textPainter.text = TextSpan(
        text: arc.text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );

      textPainter.layout();

      // Center text on calculated position
      final textOffset = Offset(
        x - (textPainter.width / 2),
        y - (textPainter.height / 2),
      );

      // Only draw text for arcs that are visible in the upper half
      if (y < center.dy) {
        textPainter.paint(canvas, textOffset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
