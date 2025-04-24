import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aimind/theme/theme_provider.dart';

class SettingSwitch extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final Function(bool) onTap;

  const SettingSwitch({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeData.brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            child: Icon(
              icon,
              color: isDarkMode ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const Spacer(),
          CupertinoSwitch(
            value: value,
            onChanged: onTap,
            activeTrackColor: isDarkMode ? Colors.blueGrey : Colors.blue,
          ),
        ],
      ),
    );
  }
}
