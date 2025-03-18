import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ForwardButton extends StatefulWidget {
  final VoidCallback onTap;
  const ForwardButton({super.key, required this.onTap});

  @override
  State<ForwardButton> createState() => _ForwardButtonState();
}

class _ForwardButtonState extends State<ForwardButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Determina el modo actual
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: _isPressed ? 55 : 60,
        height: _isPressed ? 55 : 60,
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.grey.shade700
              : Colors
                  .grey.shade200, // Color de fondo ajustado para el modo oscuro
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          Ionicons.chevron_forward_outline,
          color: isDarkMode
              ? Colors.white
              : Colors.black, // Color del ícono ajustado para el modo oscuro
        ),
      ),
    );
  }
}
