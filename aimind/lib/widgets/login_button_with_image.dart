import 'package:flutter/material.dart';

class LoginButtonWithImage extends StatelessWidget {
  final String imagePath;
  final Color? textColor;
  final VoidCallback voidCallback;
  final String text;
  final Color backgroundColor;

  const LoginButtonWithImage({
    super.key,
    required this.imagePath,
    required this.text,
    required this.backgroundColor,
    required this.voidCallback,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 24,
              width: 24,
            ),
            SizedBox(width: 8),
            Text(text, style: TextStyle(color: textColor))
          ],
        ));
  }
}
