import 'package:aimind/screens/functionalities_Screens/diario/diario_Screen.dart';
import 'package:aimind/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeData.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: themeProvider.themeData.colorScheme.surface,
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        title: Text(
          "Selecciona una fecha",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: themeProvider.themeData.colorScheme.surface,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: CalendarDatePicker(
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2101),
                onDateChanged: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slide(begin: const Offset(0, 1), end: Offset.zero),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DiarioScreen(selectedDate: selectedDate)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                side: BorderSide.none,
                shape: StadiumBorder(),
              ),
              child: Text('Confirmar',
                  style: TextStyle(color: Colors.white, fontSize: 30)),
            ),
          ],
        ),
      ),
    );
  }
}
