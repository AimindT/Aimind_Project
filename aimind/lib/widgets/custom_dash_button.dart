import 'package:flutter/material.dart';

class CustomDashButton extends StatelessWidget {
  final String iconImagePath;
  final String buttontext;
  final Color color;
  final VoidCallback onPressed; // Callback para el evento onPressed
  final double spaceBetween; // Espacio personalizable entre el ícono y el texto

  const CustomDashButton({
    super.key,
    required this.iconImagePath,
    required this.buttontext,
    this.color = Colors.white, // Color predeterminado
    required this.onPressed, // Parámetro requerido
    this.spaceBetween = 8.0, // Espacio predeterminado entre ícono y texto
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // GestureDetector para detectar toques
        GestureDetector(
          onTap: onPressed, // Ejecuta la función onPressed
          child: Container(
            height: 200,
            width: 200, // Ancho fijo para que sea cuadrado
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4), // Sombra más intensa
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(7, 7), // Sombra 3D más pronunciada
                ),
                BoxShadow(
                  color: Colors.white
                      .withOpacity(0.6), // Sombra interna más intensa
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(
                      -7, -7), // Sombra interna para efecto de relieve
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
                iconImagePath, // Mostrar la imagen en su color normal
              ),
            ),
          ),
        ),
        SizedBox(height: 40), // Espacio personalizable
        // Texto del botón
        SizedBox(
          width: 110,
          child: Text(
            buttontext,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Color del texto
            ),
            textAlign: TextAlign.center, // Centrar el texto
            maxLines: 2, // Máximo de dos líneas
            overflow: TextOverflow
                .ellipsis, // Mostrar puntos suspensivos si el texto es muy largo
          ),
        ),
      ],
    );
  }
}
