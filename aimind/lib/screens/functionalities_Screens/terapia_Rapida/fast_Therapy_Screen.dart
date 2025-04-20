import 'package:aimind/screens/functionalities_Screens/terapia_Rapida/ArcChooser.dart';
import 'package:aimind/screens/functionalities_Screens/terapia_Rapida/SmilePainter.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class FastTherapyScreen extends StatefulWidget {
  const FastTherapyScreen({super.key});

  @override
  _FastTherapyScreenState createState() => _FastTherapyScreenState();
}

class _FastTherapyScreenState extends State<FastTherapyScreen>
    with TickerProviderStateMixin {
  int slideValue = 200; // Default to OK
  int lastAnimPosition = 2;

  late AnimationController animation;
  late AnimationController pulseAnimation;
  late AnimationController rotationAnimation;
  late AnimationController submitButtonAnimation;

  // Define mood items with their colors
  late final ArcItem badArcItem;
  late final ArcItem ughArcItem;
  late final ArcItem okArcItem;
  late final ArcItem goodArcItem;

  late Color startColor;
  late Color endColor;
  String currentMood = "OK";

  @override
  void initState() {
    super.initState();

    // Initialize arc items with more vibrant colors
    badArcItem = ArcItem("BAD", [Color(0xFFfe0944), Color(0xFFfeae96)], 0.0);
    ughArcItem = ArcItem("UGH", [Color(0xFFF9D976), Color(0xfff39f86)], 0.0);
    okArcItem = ArcItem("OK", [Color(0xFF21e1fa), Color(0xff3bb8fd)], 0.0);
    goodArcItem = ArcItem("GOOD", [Color(0xFF3ee98a), Color(0xFF41f7c7)], 0.0);

    // Default colors (OK)
    startColor = okArcItem.colors[0];
    endColor = okArcItem.colors[1];

    // Main animation controller for mood selection
    animation = AnimationController(
      value: 0.5, // Start at OK (200/400)
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: Duration(milliseconds: 500),
      vsync: this,
    )..addListener(() {
        setState(() {
          // Map 0-1 animation value to 0-400 slideValue
          slideValue = (animation.value * 400).toInt();

          // Update colors based on current position and set current mood text
          if (slideValue <= 100) {
            // BAD mood
            currentMood = "BAD";
            double ratio = slideValue / 100.0;
            startColor =
                Color.lerp(badArcItem.colors[0], ughArcItem.colors[0], ratio)!;
            endColor =
                Color.lerp(badArcItem.colors[1], ughArcItem.colors[1], ratio)!;
          } else if (slideValue <= 200) {
            // UGH mood
            currentMood = "UGH";
            double ratio = (slideValue - 100) / 100.0;
            startColor =
                Color.lerp(ughArcItem.colors[0], okArcItem.colors[0], ratio)!;
            endColor =
                Color.lerp(ughArcItem.colors[1], okArcItem.colors[1], ratio)!;
          } else if (slideValue <= 300) {
            // OK mood
            currentMood = "OK";
            double ratio = (slideValue - 200) / 100.0;
            startColor =
                Color.lerp(okArcItem.colors[0], goodArcItem.colors[0], ratio)!;
            endColor =
                Color.lerp(okArcItem.colors[1], goodArcItem.colors[1], ratio)!;
          } else {
            // GOOD mood
            currentMood = "GOOD";
            double ratio = (slideValue - 300) / 100.0;
            startColor = Color.lerp(goodArcItem.colors[0], badArcItem.colors[0],
                ratio < 1.0 ? ratio : 0.0)!;
            endColor = Color.lerp(goodArcItem.colors[1], badArcItem.colors[1],
                ratio < 1.0 ? ratio : 0.0)!;
          }
        });
      });

    // Pulsing animation for the face
    pulseAnimation = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    // Rotation animation for mood change effect
    rotationAnimation = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    // Submit button animation
    submitButtonAnimation = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    // Initialize with OK mood
    animation.value = 0.5; // 200/400
  }

  void _playRotationAnimation() {
    rotationAnimation.reset();
    rotationAnimation.forward();
  }

  void _playSubmitAnimation() {
    submitButtonAnimation.reset();
    submitButtonAnimation.forward();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
        color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold);

    // Background gradient based on selected mood
    final backgroundGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white,
        Color.lerp(Colors.white, startColor, 0.05)!,
      ],
    );

    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Animated app bar
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      startColor.withOpacity(0.7),
                      endColor.withOpacity(0.5)
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: endColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Title with animation
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(milliseconds: 800),
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        "How was your experience with us?",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 5,
                              color: Colors.black26,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Current mood indicator
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 300),
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(0.0, 0.2),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          currentMood,
                          key: ValueKey<String>(currentMood),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Animated emoji face
              RotationTransition(
                turns: Tween(begin: 0.0, end: 0.05).animate(CurvedAnimation(
                  parent: rotationAnimation,
                  curve: Curves.elasticInOut,
                )),
                child: ScaleTransition(
                  scale: Tween(begin: 1.0, end: 1.1).animate(CurvedAnimation(
                    parent: pulseAnimation,
                    curve: Curves.easeInOut,
                  )),
                  child: CustomPaint(
                    size: Size(MediaQuery.of(context).size.width,
                        (MediaQuery.of(context).size.width / 2) + 60),
                    painter: SmilePainter(slideValue.toDouble()),
                  ),
                ),
              ),

              // Floating particles effect (decorative)
              Positioned.fill(
                child: IgnorePointer(
                  child: ParticleOverlay(
                    baseColor: startColor,
                    intensity: animation.value,
                  ),
                ),
              ),

              // Arc chooser and submit button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    // Arc chooser with tap effect
                    ArcChooser(
                      arcSelectedCallback: (int pos, ArcItem item) {
                        // Map position to animation value (0-1)
                        double targetValue;

                        // Convert the position to a value between 0 and 1
                        // Positions: 0=BAD, 1=UGH, 2=OK, 3=GOOD
                        switch (pos % 4) {
                          case 0: // BAD
                            targetValue = 0.0;
                            break;
                          case 1: // UGH
                            targetValue = 0.25;
                            break;
                          case 2: // OK
                            targetValue = 0.5;
                            break;
                          case 3: // GOOD
                            targetValue = 0.75;
                            break;
                          default:
                            targetValue = 0.5;
                        }

                        // Play mood change animations
                        _playRotationAnimation();

                        // Animate to target value
                        animation.animateTo(targetValue);
                        lastAnimPosition = pos % 4;
                      },
                    ),

                    // Submit button with pulse and scale animations
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: GestureDetector(
                        onTap: () {
                          _playSubmitAnimation();
                          // Handle submission logic here
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Thank you for your feedback!'),
                              backgroundColor: startColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        child: ScaleTransition(
                          scale: Tween(begin: 1.0, end: 0.9)
                              .animate(CurvedAnimation(
                            parent: submitButtonAnimation,
                            curve: Curves.easeInOut,
                          )),
                          child: Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            elevation: 8.0,
                            shadowColor: endColor.withOpacity(0.5),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              width: 150.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [startColor, endColor]),
                                borderRadius: BorderRadius.circular(25.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: endColor.withOpacity(0.4),
                                    blurRadius: 10.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(0.0, 4.0),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'SUBMIT',
                                    style: textStyle,
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animation.dispose();
    pulseAnimation.dispose();
    rotationAnimation.dispose();
    submitButtonAnimation.dispose();
    super.dispose();
  }
}

// Particle class for visual effect
class Particle {
  Offset position;
  double size;
  Color color;
  double speed;
  double angle;

  Particle({
    required this.position,
    required this.size,
    required this.color,
    required this.speed,
    required this.angle,
  });

  void update() {
    final dx = math.cos(angle) * speed;
    final dy = math.sin(angle) * speed;
    position = Offset(position.dx + dx, position.dy + dy);
    size = math.max(0, size - 0.05);
  }
}

// Visual effect overlay
class ParticleOverlay extends StatefulWidget {
  final Color baseColor;
  final double intensity;

  const ParticleOverlay({
    super.key,
    required this.baseColor,
    required this.intensity,
  });

  @override
  _ParticleOverlayState createState() => _ParticleOverlayState();
}

class _ParticleOverlayState extends State<ParticleOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> particles = [];
  final math.Random random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Generate initial particles
    _generateParticles();

    // Update particles periodically
    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _updateParticles();
          if (random.nextDouble() < 0.1) {
            _addParticle();
          }
        });
      }
    });
  }

  void _generateParticles() {
    for (int i = 0; i < 10; i++) {
      _addParticle();
    }
  }

  void _addParticle() {
    final screenWidth = 400.0; // Approximation, will adapt to actual size
    final screenHeight = 800.0;

    particles.add(
      Particle(
        position: Offset(
          random.nextDouble() * screenWidth,
          random.nextDouble() * screenHeight,
        ),
        size: 2.0 + random.nextDouble() * 5.0,
        color: widget.baseColor.withOpacity(0.2 + random.nextDouble() * 0.3),
        speed: 0.5 + random.nextDouble() * 1.5,
        angle: random.nextDouble() * 2 * math.pi,
      ),
    );
  }

  void _updateParticles() {
    for (int i = particles.length - 1; i >= 0; i--) {
      particles[i].update();
      if (particles[i].size <= 0) {
        particles.removeAt(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ParticlePainter(
        particles: particles,
        intensity: widget.intensity,
      ),
      child: Container(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double intensity;

  ParticlePainter({
    required this.particles,
    required this.intensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(intensity * 0.5)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldPainter) => true;
}
