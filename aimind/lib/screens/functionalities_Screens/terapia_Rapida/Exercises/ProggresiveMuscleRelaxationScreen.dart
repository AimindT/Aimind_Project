import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class ProgressiveMuscleRelaxationScreen extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const ProgressiveMuscleRelaxationScreen({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  _ProgressiveMuscleRelaxationScreenState createState() =>
      _ProgressiveMuscleRelaxationScreenState();
}

class _ProgressiveMuscleRelaxationScreenState
    extends State<ProgressiveMuscleRelaxationScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  late ConfettiController _confettiController;
  final List<Map<String, String>> _steps = [
    {
      'title': 'Encuentra un lugar tranquilo',
      'description': 'Adopta una postura cómoda, ya sea sentado o acostado.',
    },
    {
      'title': 'Aprieta los puños',
      'description': 'Tensa ambos puños durante 5 segundos, luego relájalos.',
    },
    {
      'title': 'Tensa los brazos',
      'description':
          'Contrae los músculos de los brazos durante 5 segundos y relájalos.',
    },
    {
      'title': 'Continúa con el cuerpo',
      'description': 'Sigue con hombros, cuello, cara, abdomen, piernas, etc.',
    },
  ];
  final List<bool> _completedSteps = [false, false, false, false];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _completeStep(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _completedSteps[index] = true;
      _currentStep = index + 1;
      if (_currentStep == _steps.length) {
        _confettiController.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Relajación Muscular',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [widget.secondaryColor, widget.primaryColor],
            ),
          ),
        ),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0, // Keep elevation at 0 for a seamless look
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [widget.secondaryColor, widget.primaryColor],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Relajación Muscular Progresiva',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _currentStep / _steps.length,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(widget.primaryColor),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    const SizedBox(height: 30),
                    ..._steps.asMap().entries.map((entry) {
                      final index = entry.key;
                      final step = entry.value;
                      return _buildStep(context, index + 1, step['title']!,
                          step['description']!, index);
                    }).toList(),
                    const SizedBox(height: 20),
                    _buildConclusion(context),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 100,
              minBlastForce: 20,
              gravity: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(BuildContext context, int step, String title,
      String description, int index) {
    final isCompleted = _completedSteps[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isCompleted
              ? widget.primaryColor.withOpacity(0.2)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: AnimatedScale(
            scale: isCompleted ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: CircleAvatar(
              backgroundColor: isCompleted
                  ? Colors.greenAccent
                  : widget.primaryColor.withOpacity(0.8),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white)
                  : Text(
                      '$step',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              description,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ),
          trailing: isCompleted
              ? null
              : ElevatedButton(
                  onPressed: () => _completeStep(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Completar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildConclusion(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        const Text(
          'Al terminar, respira profundamente y siente la liberación de tensión en tu cuerpo.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          label: const Text(
            'Terminar',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 5,
          ),
        ),
      ],
    );
  }
}
