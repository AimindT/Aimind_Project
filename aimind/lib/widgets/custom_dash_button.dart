import 'package:flutter/material.dart';

class CustomDashButton extends StatelessWidget {
  final String iconImagePath;
  final String buttontext;
  final Color color;
  final VoidCallback onPressed; // Callback para el evento onPressed

  const CustomDashButton({
    super.key,
    required this.iconImagePath,
    required this.buttontext,
    this.color = Colors.white, // Color predeterminado
    required this.onPressed, // Parámetro requerido
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // GestureDetector para detectar toques
        GestureDetector(
          onTap: onPressed, // Ejecuta la función onPressed
          child: Container(
            height: 110,
            width: 110, // Ancho fijo para que sea cuadrado
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(5, 5), // Sombra 3D
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(-5, -5), // Sombra interna para efecto de relieve
                ),
              ],
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.9),
                  color.withOpacity(0.6),
                  Colors.white.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Image.asset(
                iconImagePath,
                color: Colors.grey[800], // Color del ícono
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Texto del botón
        Text(
          buttontext,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800], // Color del texto
          ),
        ),
      ],
    );
  }
}