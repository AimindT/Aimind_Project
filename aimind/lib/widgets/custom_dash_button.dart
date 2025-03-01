import 'package:flutter/material.dart';

class CustomDashButton extends StatelessWidget {
  final String iconImagePath;
  final String buttontext;
  const CustomDashButton(
      {super.key, required this.iconImagePath, required this.buttontext});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 110,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 40,
                    spreadRadius: 10)
              ]),
          child: Center(
            child: Image.asset(iconImagePath),
          ),
        ),
        SizedBox(height: 10),
        Text(buttontext,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700]))
      ],
    );
  }
}
