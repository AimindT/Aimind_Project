import 'package:flutter/material.dart';

class CustomDashButton extends StatelessWidget {
  final String iconImagePath;
  final String buttontext;
  final Color color;
  final VoidCallback onPressed;
  final double spaceBetween;

  const CustomDashButton({
    super.key,
    required this.iconImagePath,
    required this.buttontext,
    this.color = Colors.white,
    required this.onPressed,
    this.spaceBetween = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonSize = screenWidth * 0.35;

    // Detect the current theme (dark or light)
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(buttonSize * 0.125),
          child: Container(
            height: buttonSize,
            width: buttonSize,
            padding: EdgeInsets.all(buttonSize * 0.125),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.grey.shade700
                  : color, // Darker color for dark mode
              borderRadius: BorderRadius.circular(buttonSize * 0.125),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.6)
                      : Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(7, 7),
                ),
                BoxShadow(
                  color: isDarkMode
                      ? Colors.grey.withOpacity(0.6)
                      : Colors.white.withOpacity(0.6),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(-7, -7),
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
                width: buttonSize * 1,
                height: buttonSize * 1,
              ),
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.1),
        SizedBox(
          width: screenWidth * 0.3,
          child: Text(
            buttontext,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: screenWidth * 0.055,
              fontWeight: FontWeight.bold,
              color: isDarkMode
                  ? Colors.white
                  : Colors.grey[800], // White text in dark mode
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
