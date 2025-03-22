import 'package:aimind/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_faq/flutter_easy_faq.dart';
import 'package:provider/provider.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeData.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: themeProvider.themeData.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: themeProvider.themeData.colorScheme.surface,
        title: Padding(
          padding: const EdgeInsets.only(right: 60.0),
          child: Center(child: Text('FAQS')),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Sobre La App',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                EasyFaq(
                  question: '¿Que es AImind?',
                  answer:
                      'AImind es una plataforma innovadora diseñada para brindar apoyo en el cuidado de la salud mental. A través de un asistente virtual basado en inteligencia artificial, los usuarios pueden expresar sus preocupaciones y recibir orientación complementaria. La plataforma también ofrece herramientas interactivas en tiempo real para gestionar emociones negativas y facilita la programación de citas con profesionales de la salud mental, garantizando un acceso ágil y seguro a la ayuda especializada.',
                  questionTextStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  anserTextStyle: const TextStyle(
                      fontSize: 14, color: Color.fromRGBO(108, 108, 109, 1)),
                  duration: const Duration(milliseconds: 200),
                  expandedIcon: const Icon(Icons.remove, color: Colors.black),
                  collapsedIcon: const Icon(Icons.add, color: Colors.black),
                  backgroundColor: Color.fromRGBO(241, 240, 242, 1.0),
                  borderRadius: BorderRadius.circular(12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                SizedBox(height: 10),
                EasyFaq(
                  question:
                      '¿Cómo garantizarás que el chatbot no sustituya el diagnóstico profesional, sino que motive a los usuarios a buscar ayuda especializada?',
                  answer:
                      'Se incluirán mensajes aclaratorios indicando que el chatbot no reemplaza a un profesional. Además, si detecta señales de alerta, recomendará contactar a un especialista.',
                  questionTextStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  anserTextStyle: const TextStyle(
                      fontSize: 14, color: Color.fromRGBO(108, 108, 109, 1)),
                  duration: const Duration(milliseconds: 200),
                  expandedIcon: const Icon(Icons.remove, color: Colors.black),
                  collapsedIcon: const Icon(Icons.add, color: Colors.black),
                  backgroundColor: Color.fromRGBO(241, 240, 242, 1.0),
                  borderRadius: BorderRadius.circular(12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                SizedBox(height: 10),
                EasyFaq(
                  question:
                      '¿Tendrá integración con modelos preentrenados como GPT o se desarrollará con un motor propio?',
                  answer:
                      'Se basará en modelos preentrenados, pero con ajustes específicos para el contexto de la salud mental, asegurando respuestas seguras y adecuadas.',
                  questionTextStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  anserTextStyle: const TextStyle(
                      fontSize: 14, color: Color.fromRGBO(108, 108, 109, 1)),
                  duration: const Duration(milliseconds: 200),
                  expandedIcon: const Icon(Icons.remove),
                  collapsedIcon: const Icon(Icons.add, color: Colors.black),
                  backgroundColor: Color.fromRGBO(241, 240, 242, 1.0),
                  borderRadius: BorderRadius.circular(12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                SizedBox(height: 20),
                Divider(
                  thickness: 3,
                ),
                SizedBox(height: 20),
                Text(
                  'Sobre La Privacidad',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                EasyFaq(
                  question: '¿Es seguro mi información?',
                  answer:
                      'Sí, utilizamos protocolos de seguridad avanzados para proteger los datos de los usuarios y garantizar su privacidad.',
                  questionTextStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  anserTextStyle: const TextStyle(
                      fontSize: 14, color: Color.fromRGBO(108, 108, 109, 1)),
                  duration: const Duration(milliseconds: 200),
                  expandedIcon: const Icon(Icons.remove, color: Colors.black),
                  collapsedIcon: const Icon(Icons.add, color: Colors.black),
                  backgroundColor: Color.fromRGBO(241, 240, 242, 1.0),
                  borderRadius: BorderRadius.circular(12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                SizedBox(height: 10),
                EasyFaq(
                  question:
                      '¿Cumplirá con normativas como GDPR o HIPAA si se planea una expansión internacional?',
                  answer:
                      'Sí, se adaptará a las regulaciones de protección de datos según la región.',
                  questionTextStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  anserTextStyle: const TextStyle(
                      fontSize: 14, color: Color.fromRGBO(108, 108, 109, 1)),
                  duration: const Duration(milliseconds: 200),
                  expandedIcon: const Icon(Icons.remove, color: Colors.black),
                  collapsedIcon: const Icon(Icons.add, color: Colors.black),
                  backgroundColor: Color.fromRGBO(241, 240, 242, 1.0),
                  borderRadius: BorderRadius.circular(12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                SizedBox(height: 20),
                Divider(
                  thickness: 3,
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Sobre La Experiencia Del Usuario',
                    style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                EasyFaq(
                  question:
                      '¿Cómo será el proceso de conexión con profesionales de la salud mental? ¿Habrá filtros por especialidad o disponibilidad?',
                  answer:
                      'Los usuarios podrán filtrar profesionales por especialidad, disponibilidad y enfoque terapéutico.',
                  questionTextStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  anserTextStyle: const TextStyle(
                      fontSize: 14, color: Color.fromRGBO(108, 108, 109, 1)),
                  duration: const Duration(milliseconds: 200),
                  expandedIcon: const Icon(Icons.remove, color: Colors.black),
                  collapsedIcon: const Icon(Icons.add, color: Colors.black),
                  backgroundColor: Color.fromRGBO(241, 240, 242, 1.0),
                  borderRadius: BorderRadius.circular(12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                SizedBox(height: 10),
                EasyFaq(
                  question:
                      '¿Habrá recordatorios automáticos para fomentar el uso constante de la plataforma?',
                  answer:
                      'Sí, se enviarán recordatorios personalizados para fomentar la continuidad en el uso de la plataforma.',
                  questionTextStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  anserTextStyle: const TextStyle(
                      fontSize: 14, color: Color.fromRGBO(108, 108, 109, 1)),
                  duration: const Duration(milliseconds: 200),
                  expandedIcon: const Icon(Icons.remove, color: Colors.black),
                  collapsedIcon: const Icon(Icons.add, color: Colors.black),
                  backgroundColor: Color.fromRGBO(241, 240, 242, 1.0),
                  borderRadius: BorderRadius.circular(12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                SizedBox(height: 10),
                EasyFaq(
                  question:
                      '¿Se integrará con plataformas de videollamadas o solo será un sistema de gestión de citas?',
                  answer:
                      'Se integrará con servicios de videollamada en un futuro para facilitar las sesiones en línea, pero de momento solo se agendarán citas.',
                  questionTextStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  anserTextStyle: const TextStyle(
                      fontSize: 14, color: Color.fromRGBO(108, 108, 109, 1)),
                  duration: const Duration(milliseconds: 200),
                  expandedIcon: const Icon(
                    Icons.remove,
                    color: Colors.black,
                  ),
                  collapsedIcon: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  backgroundColor: Color.fromRGBO(241, 240, 242, 1.0),
                  borderRadius: BorderRadius.circular(12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
