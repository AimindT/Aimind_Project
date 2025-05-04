// lib/screens/functionalities_Screens/diario/edit.dart
import 'package:aimind/models/note.dart';
import 'package:aimind/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  final Note? note;
  final DateTime selectedDate;

  const EditScreen({
    super.key,
    this.note,
    required this.selectedDate, // Ahora es requerido para saber a qué fecha pertenece la nota
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    if (widget.note != null) {
      _titleController = TextEditingController(text: widget.note!.title);
      _contentController = TextEditingController(text: widget.note!.content);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeData.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: themeProvider.themeData.colorScheme.surface,
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: EdgeInsets.all(0),
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.grey.shade800.withOpacity(.8)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.arrow_back_ios_new,
                          color: isDarkMode ? Colors.white : Colors.black),
                    ))
              ],
            ),
            Expanded(
                child: ListView(
              children: [
                TextField(
                  controller: _titleController,
                  style: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.black,
                      fontSize: 30),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Título',
                      hintStyle: TextStyle(
                          color: isDarkMode ? Colors.grey : Colors.black,
                          fontSize: 30)),
                ),
                TextField(
                  controller: _contentController,
                  style:
                      TextStyle(color: isDarkMode ? Colors.grey : Colors.black),
                  maxLines: null,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Escribe aquí',
                      hintStyle: TextStyle(
                          color: isDarkMode ? Colors.grey : Colors.black)),
                )
              ],
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(
              context, [_titleController.text, _contentController.text]);
        },
        elevation: 10,
        backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
        child: Icon(color: isDarkMode ? Colors.grey : Colors.black, Icons.save),
      ),
    );
  }
}
