import 'package:flutter/material.dart';
import 'dart:async';

// Pantalla para la técnica de Visualización, que guía al usuario a imaginar un lugar tranquilo
class VisualizationScreen extends StatefulWidget {
  final Color primaryColor; // Color principal para el diseño
  final Color secondaryColor; // Color secundario para el gradiente

  const VisualizationScreen({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  _VisualizationScreenState createState() => _VisualizationScreenState();
}

class _VisualizationScreenState extends State<VisualizationScreen> {
  // Estado para rastrear el paso actual (0 a 3)
  int _currentStep = 0;
  // Indica si el temporizador está activo
  bool _isRunning = false;
  // Segundos restantes para el paso actual (1 minuto por paso)
  int _secondsRemaining = 60;
  // Temporizador para controlar el tiempo de cada paso
  Timer? _timer;
  // Lista de pasos con título y descripción para la visualización
  final List<Map<String, String>> _steps = [
    {
      'title': 'Paso 1: Encuentra un lugar cómodo',
      'description':
          'Siéntate o acuéstate en un lugar tranquilo. Cierra los ojos y respira profundamente unas veces.',
    },
    {
      'title': 'Paso 2: Imagina un lugar tranquilo',
      'description':
          'Piensa en un lugar que te haga sentir en paz, como una playa, un bosque o una montaña. Visualiza los detalles.',
    },
    {
      'title': 'Paso 3: Agrega sentidos',
      'description':
          'Imagina los sonidos, olores y texturas de tu lugar. Por ejemplo, el sonido de las olas o el aroma de los árboles.',
    },
    {
      'title': 'Paso 4: Sumérgete en la escena',
      'description':
          'Permítete estar completamente en ese lugar. Quédate ahí, disfrutando de la calma.',
    },
  ];

  // Limpia el temporizador al salir de la pantalla para evitar fugas de memoria
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Inicia el temporizador para el paso actual
  void _startStep() {
    setState(() {
      _isRunning = true;
      _secondsRemaining = 60; // Reinicia a 1 minuto
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--; // Decrementa el tiempo
        } else {
          _timer?.cancel(); // Detiene el temporizador al llegar a 0
          _isRunning = false;
        }
      });
    });
  }

  // Avanza al siguiente paso o completa la actividad
  void _nextStep() {
    _timer?.cancel(); // Detiene el temporizador actual
    setState(() {
      _isRunning = false;
      if (_currentStep < _steps.length - 1) {
        _currentStep++; // Avanza al siguiente paso
      } else {
        // Muestra un mensaje de confirmación y regresa
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Visualización completada!')),
        );
        Navigator.pop(context);
      }
    });
  }

  // Formatea el tiempo en formato MM:SS
  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.secondaryColor, // Fondo con color secundario
      appBar: AppBar(
        backgroundColor: widget.primaryColor.withOpacity(0.9), // Color principal con opacidad
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context), // Botón para regresar
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
          'Visualización',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.primaryColor, widget.secondaryColor], // Gradiente de fondo
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
                // Título del paso actual
                Text(
                  _steps[_currentStep]['title']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Tarjeta con la descripción del paso
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
                    _steps[_currentStep]['description']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Temporizador para el paso actual
                Text(
                  _formatTime(_secondsRemaining),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                // Botón para iniciar el temporizador (solo si no está corriendo)
                if (!_isRunning) ...[
                  ElevatedButton(
                    onPressed: _startStep,
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
                      'Iniciar paso',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                // Botón para pasar al siguiente paso o completar
                ElevatedButton(
                  onPressed: _nextStep,
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
                  child: Text(
                    _currentStep < _steps.length - 1 ? 'Siguiente paso' : 'Completar',
                    style: const TextStyle(
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