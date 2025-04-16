import 'dart:math';
import 'dart:ui';
import 'package:aimind/screens/functionalities_Screens/terapia_Rapida_Screen/ChooserPainter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ArcChooser extends StatefulWidget {
  final ArcSelectedCallback arcSelectedCallback;

  ArcChooser({required this.arcSelectedCallback});

  @override
  State<StatefulWidget> createState() {
    return ChooserState(arcSelectedCallback);
  }
}

class ChooserState extends State<ArcChooser>
    with SingleTickerProviderStateMixin {
  var slideValue = 200;
  late Offset centerPoint;

  double userAngle = 0.0;

  late double startAngle;

  static double center = 270.0;
  static double centerInRadians = degreeToRadians(center);
  static double angle = 45.0;

  static double angleInRadians = degreeToRadians(angle);
  static double angleInRadiansByTwo = angleInRadians / 2;
  static double centerItemAngle = degreeToRadians(center - (angle / 2));
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

  static double radianToDegrees(double radian) {
    return radian * (180 / pi);
  }

  @override
  void initState() {
    arcItems = [];

    for (int i = 0; i < 8; i++) {
      String label = (i % 4 == 0 || i % 4 == 3)
          ? "BAD"
          : (i % 4 == 1 || i % 4 == 5)
              ? "UGH"
              : "GOOD";
      List<Color> colors = label == "BAD"
          ? [Color(0xFFfe0944), Color(0xFFfeae96)]
          : label == "UGH"
              ? [Color(0xFFF9D976), Color(0xfff39f86)]
              : label == "GOOD"
                  ? [Color(0xFF3ee98a), Color(0xFF41f7c7)]
                  : [Color(0xFF21e1fa), Color(0xff3bb8fd)];

      arcItems.add(ArcItem(
        label,
        colors,
        angleInRadiansByTwo + userAngle + (i * angleInRadians),
      ));
    }

    animation = AnimationController(
      duration: const Duration(milliseconds: 200),
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

    super.initState();
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
          animationEnd += angleInRadians;
          currentPosition--;
          if (currentPosition < 0) {
            currentPosition = arcItems.length - 1;
          }
        } else {
          animationEnd -= angleInRadians;
          currentPosition++;
          if (currentPosition >= arcItems.length) {
            currentPosition = 0;
          }
        }

        arcSelectedCallback(
            currentPosition,
            arcItems[(currentPosition >= arcItems.length - 1)
                ? 0
                : currentPosition + 1]);

        animation.forward(from: 0.0);
      },
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.width * 1 / 1.5),
        painter: ChooserPainter(arcItems, angleInRadians),
      ),
    );
  }
}

typedef void ArcSelectedCallback(int position, ArcItem arcitem);

class ArcItem {
  String text;
  List<Color> colors;
  double startAngle;

  ArcItem(this.text, this.colors, this.startAngle);
}
