// ignore_for_file: deprecated_member_use

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
      appBar: AppBar(
        title: Text('Ejercicio: $techniqueName'),
        backgroundColor: primaryColor,
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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildExerciseContent(),
                const SizedBox(height: 24),
                _buildProgressIndicator(),
                const SizedBox(height: 32),
                _buildActionButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Contenido del ejercicio
  Widget _buildExerciseContent() {
    return Column(
      children: [
        Text(
          '¡Sigue las instrucciones!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Text(
          techniqueName == 'Respiración profunda'
              ? 'Inhala por 4 segundos, mantén por 4, exhala por 6. Repite 5 veces.'
              : 'Instrucción específica de la técnica', // Aquí puedes añadir la instrucción de la técnica
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }

  // Barra de progreso (simula avance como en Duolingo)
  Widget _buildProgressIndicator() {
    return LinearProgressIndicator(
      value: 0.5, // Simula progreso (porcentaje de completado)
      backgroundColor: Colors.grey.withOpacity(0.3),
      color: primaryColor,
    );
  }

  // Botón de acción (tipo Duolingo, para continuar con el ejercicio o completarlo)
  Widget _buildActionButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Aquí puedes avanzar o dar retroalimentación
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Excelente! Has completado el ejercicio de $techniqueName')),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text(
        '¡Hecho!',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
