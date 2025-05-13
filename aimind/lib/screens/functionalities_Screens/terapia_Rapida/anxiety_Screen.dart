import 'package:aimind/screens/functionalities_Screens/terapia_Rapida/Exercises/technique_exercise_screen.dart';
import 'package:flutter/material.dart';

class AnxietyScreen extends StatefulWidget {
  final Map<String, dynamic> emotion;

  const AnxietyScreen({
    super.key,
    required this.emotion,
  });

  @override
  State<AnxietyScreen> createState() => _AnxietyScreenState();
}

class _AnxietyScreenState extends State<AnxietyScreen> {
  final List<String> anxietyTechniques = [
    'Respiración profunda',
    'Relajación muscular',
    'Mindfulness',
    'Visualización',
    'Distracción cognitiva'
  ];

  final List<String> anxietySymptoms = [
    'Preocupación excesiva',
    'Tensión muscular',
    'Taquicardia',
    'Sudoración',
    'Dificultad para concentrarse',
    'Insomnio',
    'Inquietud'
  ];

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = widget.emotion['color2'];
    final Color secondaryColor = widget.emotion['color1'];

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
                          'Manejo de la Ansiedad',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.info_outline,
                          title: 'Sobre la ansiedad',
                          content:
                              'La ansiedad es una respuesta natural del cuerpo ante situaciones de estrés. Sin embargo, cuando se vuelve excesiva, puede afectar tu bienestar diario.',
                          color: primaryColor,
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Síntomas comunes', primaryColor),
                        const SizedBox(height: 12),
                        _buildSymptomsList(anxietySymptoms, primaryColor),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Técnicas de manejo', primaryColor),
                        const SizedBox(height: 16),
                        _buildTechniquesList(
                            anxietyTechniques, primaryColor, secondaryColor),
                        // const SizedBox(height: 24),
                        // _buildBreatheExercise(primaryColor, secondaryColor),
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
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TechniqueExerciseScreen(
                  techniqueName: techniques[index],
                  primaryColor: primaryColor,
                  secondaryColor: secondaryColor,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.1),
                  secondaryColor.withOpacity(0.1)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withOpacity(0.2)),
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
          ),
        );
      },
    );
  }

  // Widget _buildBreatheExercise(Color primaryColor, Color secondaryColor) {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [primaryColor, secondaryColor],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: primaryColor.withOpacity(0.3),
  //           blurRadius: 8,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         const Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(
  //               Icons.air,
  //               color: Colors.white,
  //               size: 28,
  //             ),
  //             SizedBox(width: 10),
  //             Text(
  //               'Ejercicio de respiración',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         const Text(
  //           'Inhala por 4 segundos, mantén por 4 y exhala por 6 segundos. Repite 5 veces.',
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontSize: 15,
  //             color: Colors.white,
  //             height: 1.5,
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => BreathingExerciseScreen(
  //                   primaryColor: primaryColor,
  //                   secondaryColor: secondaryColor,
  //                 ),
  //               ),
  //             );
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.white,
  //             foregroundColor: primaryColor,
  //             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(30),
  //             ),
  //           ),
  //           child: const Text(
  //             'Comenzar ahora',
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
