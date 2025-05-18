import 'package:flutter/material.dart';
import 'dart:async';

class MindfulnessScreen extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const MindfulnessScreen({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  _MindfulnessScreenState createState() => _MindfulnessScreenState();
}

class _MindfulnessScreenState extends State<MindfulnessScreen> {
  bool _isRunning = false;
  int _secondsRemaining = 300; // 5 minutos
  Timer? _timer;
  String _instruction = 'Siéntate en un lugar tranquilo, cierra los ojos y concéntrate en tu respiración.';

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startMindfulness() {
    setState(() {
      _isRunning = true;
      _secondsRemaining = 300;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          // Cambiar instrucción en ciertos momentos para guiar
          if (_secondsRemaining == 240) {
            _instruction = 'Observa tus pensamientos sin juzgarlos, déjalos pasar como nubes.';
          } else if (_secondsRemaining == 120) {
            _instruction = 'Regresa suavemente a tu respiración si tu mente se distrae.';
          }
        } else {
          _timer?.cancel();
          _isRunning = false;
          _instruction = '¡Bien hecho! Has completado la sesión de mindfulness.';
        }
      });
    });
  }

  void _stopMindfulness() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _instruction = 'Sesión pausada. Puedes continuar cuando quieras.';
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.secondaryColor,
      appBar: AppBar(
        backgroundColor: widget.primaryColor.withOpacity(0.9),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 12.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        title: const Text(
          'Mindfulness',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.primaryColor, widget.secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sesión de Mindfulness',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    _instruction,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  _formatTime(_secondsRemaining),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!_isRunning) ...[
                      ElevatedButton(
                        onPressed: _startMindfulness,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: widget.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 6,
                        ),
                        child: const Text(
                          'Iniciar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ] else ...[
                      ElevatedButton(
                        onPressed: _stopMindfulness,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: widget.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 6,
                        ),
                        child: const Text(
                          'Pausar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _timer?.cancel();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: widget.primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 6,
                  ),
                  child: const Text(
                    'Completar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}