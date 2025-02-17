import 'package:aimind/config/palette.dart';
import 'package:flutter/material.dart';

class GenderSelection extends StatefulWidget {
  final String text;
  final IconData icon;
  const GenderSelection({super.key, required this.text, required this.icon});

  @override
  State<GenderSelection> createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Palette.textColor1),
              borderRadius: BorderRadius.circular(15)),
          child: Icon(
            Icons.person_2_outlined,
            color: Palette.iconColor,
          ),
        ),
        Text(
          "Hombre",
          style: TextStyle(color: Palette.textColor1),
        )
      ],
    );
  }
}
