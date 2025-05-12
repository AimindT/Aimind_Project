import 'package:aimind/screens/functionalities_Screens/terapia_Rapida/Exercises/BreathingExerciseScreen.dart';
import 'package:aimind/screens/functionalities_Screens/terapia_Rapida/Exercises/ProggresiveMuscleRelaxationScreen.dart';
import 'package:flutter/material.dart';

class TechniqueExerciseScreen extends StatelessWidget {
  final String techniqueName;
  final Color primaryColor;
  final Color secondaryColor;

  const TechniqueExerciseScreen({
    super.key,
    required this.techniqueName,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: primaryColor.withOpacity(0.9),
          elevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
          title: Text(
            techniqueName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
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
                const SizedBox(height: 20),
                _buildTitle(),
                const SizedBox(height: 20),
                _buildInstructionCard(),
                // const SizedBox(height: 30),
                // _buildProgressIndicator(),
                const Spacer(),
                _buildActionButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      '¡Sigue las instrucciones!',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Text(
        techniqueName == 'Respiración profunda'
            ? 'Inhala profundamente por la nariz, mantén el aire unos segundos y exhala lentamente por la boca.'
            : 'Instrucción específica de la técnica.',
        style: TextStyle(fontSize: 18, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Widget _buildProgressIndicator() {
  //   return Column(
  //     children: [
  //       Text(
  //         'Progreso',
  //         style: TextStyle(color: Colors.white70, fontSize: 16),
  //       ),
  //       const SizedBox(height: 8),
  //       ClipRRect(
  //         borderRadius: BorderRadius.circular(10),
  //         child: LinearProgressIndicator(
  //           value: 0.2,
  //           backgroundColor: Colors.white24,
  //           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  //           minHeight: 10,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildActionButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (techniqueName == 'Respiración profunda') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BreathingExerciseScreen(
                primaryColor: primaryColor,
                secondaryColor: secondaryColor,
              ),
            ),
          );
        }
        if (techniqueName == 'Relajación muscular') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProgressiveMuscleRelaxationScreen(
                primaryColor: primaryColor,
                secondaryColor: secondaryColor,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '¡Excelente! Has completado el ejercicio de $techniqueName'),
              backgroundColor: primaryColor,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 6,
      ),
      child: const Text(
        '¡Hecho!',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
