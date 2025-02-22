import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Color? iconColor;
  final Color? textColor;
  final IconData icon;
  final VoidCallback voidCallback;
  final String text;
  final Color backgroundColor;
  const LoginButton({
    super.key,
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.voidCallback,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: voidCallback,
        style: TextButton.styleFrom(
          minimumSize: Size(155, 40),
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(20)),
          backgroundColor: backgroundColor,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            SizedBox(width: 5),
            Text(text, style: TextStyle(color: textColor))
          ],
        ));
  }
}