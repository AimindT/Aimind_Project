import 'package:flutter/material.dart';

class DepressionScreen extends StatefulWidget {
  final Map<String, dynamic> emotion;

  const DepressionScreen({
    Key? key,
    required this.emotion,
  }) : super(key: key);

  @override
  State<DepressionScreen> createState() => _DepressionScreenState();
}

class _DepressionScreenState extends State<DepressionScreen> {
  final List<String> depressionTechniques = [
    'Activación conductual',
    'Reestructuración cognitiva',
    'Ejercicio físico regular',
    'Conexión social',
    'Mindfulness y meditación'
  ];

  final List<String> depressionSymptoms = [
    'Tristeza persistente',
    'Pérdida de interés',
    'Fatiga',
    'Problemas de sueño',
    'Cambios en el apetito',
    'Dificultad para concentrarse',
    'Sentimientos de culpa o inutilidad'
  ];

  @override
  Widget build(BuildContext context) {
    // Usando tonos de azul para depresión
    final Color primaryColor = Colors.blue[700]!;
    final Color secondaryColor = Colors.blue[300]!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              secondaryColor,
              primaryColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manejo de la Depresión',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.info_outline,
                          title: 'Sobre la depresión',
                          content:
                              'La depresión es más que sentirse triste. Es un trastorno del estado de ánimo que afecta cómo te sientes, piensas y manejas las actividades diarias.',
                          color: primaryColor,
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Síntomas comunes', primaryColor),
                        const SizedBox(height: 12),
                        _buildSymptomsList(depressionSymptoms, primaryColor),
                        const SizedBox(height: 24),
                        _buildSectionTitle(
                            'Estrategias de afrontamiento', primaryColor),
                        const SizedBox(height: 16),
                        _buildTechniquesList(
                            depressionTechniques, primaryColor, secondaryColor),
                        const SizedBox(height: 24),
                        _buildMoodExercise(primaryColor, secondaryColor),
                        const SizedBox(height: 24),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Aquí puedes agregar acciones adicionales
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Volver',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            widget.emotion['emoji'],
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 12),
          Text(
            widget.emotion['name'],
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomsList(List<String> symptoms, Color color) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: symptoms.map((symptom) {
        return Chip(
          label: Text(symptom),
          backgroundColor: color.withOpacity(0.1),
          side: BorderSide(color: color.withOpacity(0.3)),
          labelStyle: TextStyle(color: Colors.grey[800]),
        );
      }).toList(),
    );
  }

  Widget _buildTechniquesList(
      List<String> techniques, Color primaryColor, Color secondaryColor) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: techniques.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.1),
                secondaryColor.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: primaryColor.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  techniques[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: primaryColor,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoodExercise(Color primaryColor, Color secondaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.psychology,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(width: 10),
              Text(
                'Ejercicio de activación',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Identifica una pequeña actividad que puedas realizar hoy que normalmente te daría placer o satisfacción, incluso si ahora no te apetece.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) {
                  String activity = '';
                  bool completed = false;

                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 24,
                          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Ejercicio de activación',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Escribe una actividad sencilla que normalmente te haría sentir mejor.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Actividad',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                activity = value;
                              },
                            ),
                            const SizedBox(height: 16),
                            CheckboxListTile(
                              activeColor: Colors.green,
                              title: const Text('He completado esta actividad'),
                              value: completed,
                              onChanged: (value) {
                                setState(() {
                                  completed = value ?? false;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      completed
                                          ? '¡Buen trabajo completando la actividad!'
                                          : 'Actividad registrada: "$activity"',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Guardar',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Comenzando ejercicio de activación...'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Comenzar ahora',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
