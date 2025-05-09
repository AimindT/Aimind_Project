import 'dart:async';
import 'package:flutter/material.dart';

class BreathingExerciseScreen extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const BreathingExerciseScreen({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  State<BreathingExerciseScreen> createState() =>
      _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen> {
  final List<_Step> steps = [
    _Step("Inhala", 4),
    _Step("Mantén", 4),
    _Step("Exhala", 6),
  ];

  int stepIndex = 0;
  int counter = 0;
  Timer? timer;
  int repetitions = 0;

  @override
  void initState() {
    super.initState();
    _startStep();
  }

  void _startStep() {
    counter = steps[stepIndex].duration;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        counter--;
        if (counter <= 0) {
          stepIndex = (stepIndex + 1) % steps.length;
          if (stepIndex == 0) repetitions++;
          if (repetitions >= 5) {
            timer?.cancel();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Ejercicio completado. ¡Bien hecho!')),
            );
          } else {
            _startStep();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = steps[stepIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.secondaryColor, widget.primaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Repetición ${repetitions + 1} de 5',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 20),
              Text(
                currentStep.label,
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      value: counter / currentStep.duration,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.white.withOpacity(0.3),
                      strokeWidth: 12,
                    ),
                  ),
                  Text(
                    '$counter',
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  timer?.cancel();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: widget.primaryColor,
                ),
                child: const Text('Cancelar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Step {
  final String label;
  final int duration;

  _Step(this.label, this.duration);
}
