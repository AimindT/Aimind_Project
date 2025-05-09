import 'dart:math';
import 'package:aimind/screens/functionalities_Screens/terapia_Rapida/anxiety_Screen.dart';
import 'package:aimind/screens/functionalities_Screens/terapia_Rapida/depression_Screen.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class EmotionSelectorScreen extends StatefulWidget {
  const EmotionSelectorScreen({super.key});

  @override
  State<EmotionSelectorScreen> createState() => _EmotionSelectorScreenState();
}

class _EmotionSelectorScreenState extends State<EmotionSelectorScreen>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> emotions = [
    {
      'name': 'Ansiedad',
      'emoji': '😰',
      'color1': Color(0xFFFFAB40), // Naranja claro
      'color2': Color(0xFFFF6F00), // Naranja oscuro
    },
    {
      'name': 'Depresión',
      'emoji': '😞',
      'color1': Color(0xFF64B5F6), // Azul claro
      'color2': Color(0xFF1976D2), // Azul oscuro
    },
  ];

  int currentIndex = 0;
  late AnimationController _emojiController;
  late AnimationController _titleController;
  late AnimationController _neuronOpacityController;
  late Animation<double> _neuronOpacity;
  late List<Offset> neuronPoints;

  @override
  void initState() {
    super.initState();

    _emojiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward(); // Add this to animate emoji on initial load

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _neuronOpacityController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _neuronOpacity = Tween(begin: 0.08, end: 0.18).animate(
      CurvedAnimation(
          parent: _neuronOpacityController, curve: Curves.easeInOut),
    );

    neuronPoints = _generateRandomPoints();
  }

  List<Offset> _generateRandomPoints() {
    final rand = Random();
    // Use a safer way to get the screen size since window.physicalSize is deprecated
    final size = MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.first)
        .size;
    return List.generate(25, (_) {
      return Offset(
        rand.nextDouble() * size.width,
        rand.nextDouble() * size.height,
      );
    });
  }

  @override
  void dispose() {
    _emojiController.dispose();
    _titleController.dispose();
    _neuronOpacityController.dispose();
    super.dispose();
  }

  void onEmotionChanged(int index) {
    setState(() {
      currentIndex = index;
      _emojiController.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final emotion = emotions[currentIndex];
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _neuronOpacity,
            builder: (context, _) {
              return CustomPaint(
                size: MediaQuery.of(context).size,
                painter: NeuronBackground(neuronPoints, _neuronOpacity.value),
              );
            },
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.02),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _titleController,
                    curve: Curves.easeIn,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '¿Cómo te sientes en este momento?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                SizedBox(
                  height: screenHeight * 0.60,
                  child: Swiper(
                    itemCount: emotions.length,
                    viewportFraction: 0.7,
                    scale: 0.85,
                    loop: false,
                    onIndexChanged: onEmotionChanged,
                    itemBuilder: (context, index) {
                      final e = emotions[index];
                      final isActive = index == currentIndex;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                        transform:
                            isActive ? Matrix4.identity() : Matrix4.identity()
                              ..rotateZ(0.05)
                              ..scale(0.95),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: LinearGradient(
                            colors: [e['color1'], e['color2']],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: e['color2'].withOpacity(0.4),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ScaleTransition(
                              scale: CurvedAnimation(
                                parent: _emojiController,
                                curve: Curves.elasticOut,
                              ),
                              child: Text(
                                e['emoji'],
                                style: const TextStyle(fontSize: 80),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              e['name'],
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.3,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ElevatedButton(
                    onPressed: () {
                      final selected = emotions[currentIndex];

                      // Navegación condicional basada en la emoción seleccionada
                      if (selected['name'] == 'Ansiedad') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                AnxietyScreen(emotion: selected),
                          ),
                        );
                      } else if (selected['name'] == 'Depresión') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                DepressionScreen(emotion: selected),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: emotion['color2'],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 10,
                    ),
                    child: const Text(
                      'Continuar',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NeuronBackground extends CustomPainter {
  final List<Offset> points;
  final double opacity;
  NeuronBackground(this.points, this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.blueGrey.withOpacity(opacity)
      ..strokeWidth = 1;
    final paintNode = Paint()..color = Colors.deepPurple.withOpacity(opacity);

    for (var i = 0; i < points.length; i++) {
      for (var j = i + 1; j < points.length; j++) {
        if ((points[i] - points[j]).distance < 100) {
          canvas.drawLine(points[i], points[j], paintLine);
        }
      }
    }

    for (var point in points) {
      canvas.drawCircle(point, 3, paintNode);
    }
  }

  @override
  bool shouldRepaint(covariant NeuronBackground oldDelegate) => true;
}
