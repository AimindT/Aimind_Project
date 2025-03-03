import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title; // Título de la tarjeta
  final String text; // Texto a la izquierda
  final String imagePath; // Ruta de la imagen
  final Color color; // Color de fondo

  const CustomCard({
    super.key,
    required this.title,
    required this.text,
    required this.imagePath,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        width: 300,
        height: 180, // Alto fijo para la tarjeta
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.8), // Negro
              Colors.black.withOpacity(0.5), // Negro más claro
              Colors.white.withOpacity(0.1), // Blanco con transparencia
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6), // Sombra más oscura
              blurRadius: 20,
              spreadRadius: 5,
              offset: const Offset(7, 7), // Sombra 3D más pronunciada
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.6), // Sombra interna más clara
              blurRadius: 20,
              spreadRadius: 5,
              offset: const Offset(-7, -7), // Sombra interna para efecto de relieve
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título en la parte superior centrado
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white, // Texto en blanco
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Contenido: Texto a la izquierda e imagen en el centro
            Expanded(
              child: Row(
                children: [
                  // Texto a la izquierda
                  Expanded(
                    flex: 2, // 2 partes del espacio para el texto
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white, // Texto en blanco
                        fontSize: 16,
                      ),
                      maxLines: 3, // Máximo de 3 líneas
                      overflow: TextOverflow.ellipsis, // Puntos suspensivos si el texto es muy largo
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Imagen en el centro
                  Expanded(
                    flex: 3, // 3 partes del espacio para la imagen
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover, // Ajustar la imagen al espacio disponible
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}