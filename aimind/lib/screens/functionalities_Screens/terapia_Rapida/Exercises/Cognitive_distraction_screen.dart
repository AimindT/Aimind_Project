import 'package:flutter/material.dart';

// Pantalla para la técnica de Distracción Cognitiva, que propone actividades mentales
class CognitiveDistractionScreen extends StatefulWidget {
  final Color primaryColor; // Color principal para el diseño
  final Color secondaryColor; // Color secundario para el gradiente

  const CognitiveDistractionScreen({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  _CognitiveDistractionScreenState createState() => _CognitiveDistractionScreenState();
}

class _CognitiveDistractionScreenState extends State<CognitiveDistractionScreen> {
  // Actividad actual que se muestra
  String _activity = '';
  // Índice de la actividad actual en la lista
  int _activityIndex = 0;
  // Lista de actividades con título y descripción
  final List<Map<String, String>> _activities = [
    {
      'title': 'Contar hacia atrás',
      'description': 'Cuenta hacia atrás desde 100 de 7 en 7. Por ejemplo: 100, 93, 86...',
    },
    {
      'title': 'Nombrar objetos',
      'description': 'Mira a tu alrededor y nombra 5 objetos que veas. Luego, describe sus colores.',
    },
    {
      'title': 'Categorías',
      'description': 'Piensa en 5 animales, 5 frutas y 5 ciudades. Dilos en voz alta o en tu mente.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _generateActivity(); // Genera la primera actividad al iniciar
  }

  // Actualiza la actividad mostrada según el índice actual
  void _generateActivity() {
    setState(() {
      _activity = _activities[_activityIndex]['description']!;
    });
  }

  // Pasa a la siguiente actividad en la lista, cíclicamente
  void _nextActivity() {
    setState(() {
      _activityIndex = (_activityIndex + 1) % _activities.length; // Rota entre actividades
      _generateActivity();
    });
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
          'Distracción cognitiva',
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
                // Título de la actividad actual
                Text(
                  _activities[_activityIndex]['title']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Tarjeta con la descripción de la actividad
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
                    _activity,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
                const Spacer(),
                // Botón para cambiar a la siguiente actividad
                ElevatedButton(
                  onPressed: _nextActivity,
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
                    'Siguiente actividad',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Botón para completar la actividad y regresar
                ElevatedButton(
                  onPressed: () {
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