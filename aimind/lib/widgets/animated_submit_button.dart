import 'package:flutter/material.dart';

class AnimatedSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String buttonText;
  final double width;
  final double height;
  final Color buttonColor;
  final Color loadingColor;

  const AnimatedSubmitButton({
    Key? key,
    required this.isLoading,
    required this.onPressed,
    this.buttonText = 'Registrarse',
    this.width = 200,
    this.height = 50,
    this.buttonColor = Colors.orange,
    this.loadingColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: loadingColor,
                  strokeWidth: 2,
                ),
              )
            : Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
