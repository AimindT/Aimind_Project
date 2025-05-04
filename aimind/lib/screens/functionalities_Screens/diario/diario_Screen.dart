// lib/screens/functionalities_Screens/diario/diario_Screen.dart
import 'dart:math';
import 'package:aimind/constants/colors.dart';
import 'package:aimind/models/note.dart';
import 'package:aimind/screens/functionalities_Screens/diario/edit.dart';
import 'package:aimind/services/supabase_Service%20.dart';
import 'package:aimind/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DiarioScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const DiarioScreen({super.key, this.selectedDate});

  @override
  State<DiarioScreen> createState() => _DiarioScreenState();
}

class _DiarioScreenState extends State<DiarioScreen> {
  List<Note> allNotes = [];
  List<Note> filteredNotes = [];
  bool sorted = false;
  bool isLoading = true;
  final SupabaseService _supabaseService = SupabaseService();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (widget.selectedDate != null) {
        allNotes = await _supabaseService.getNotesByDate(widget.selectedDate!);
      } else {
        allNotes = await _supabaseService.getNotes();
      }

      setState(() {
        filteredNotes = List.from(allNotes);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Manejar errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar las notas: $e')),
      );
    }
  }

  List<Note> sortNotesByMofifiedTime(List<Note> notes) {
    if (sorted) {
      notes.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));
    } else {
      notes.sort((b, a) => a.modifiedTime.compareTo(b.modifiedTime));
    }
    sorted = !sorted;

    return notes;
  }

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  void onSearchTextChanged(String searchText) {
    setState(() {
      filteredNotes = allNotes
          .where((note) =>
              note.content.toLowerCase().contains(searchText.toLowerCase()) ||
              note.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void deleteNote(int index) async {
    final noteToDelete = filteredNotes[index];
    if (noteToDelete.id != null) {
      try {
        await _supabaseService.deleteNote(noteToDelete.id!);
        setState(() {
          allNotes.remove(noteToDelete);
          filteredNotes = List.from(allNotes);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar la nota: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeData.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: themeProvider.themeData.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
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
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    )),
                Text(
                  'Mis Notas',
                  style: TextStyle(
                      fontSize: 30,
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        filteredNotes = sortNotesByMofifiedTime(filteredNotes);
                      });
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
                      child: Icon(Icons.sort,
                          color: isDarkMode ? Colors.white : Colors.black),
                    ))
              ],
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: onSearchTextChanged,
              style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                  hintText: 'Buscar Notas...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  fillColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.transparent)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.transparent))),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredNotes.isEmpty
                      ? Center(
                          child: Text(
                            'No hay notas para esta fecha',
                            style: TextStyle(
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black54,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(top: 30),
                          itemCount: filteredNotes.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.only(bottom: 20),
                              color: getRandomColor(),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                EditScreen(
                                                  note: filteredNotes[index],
                                                  selectedDate:
                                                      widget.selectedDate ??
                                                          DateTime.now(),
                                                )));

                                    if (result != null) {
                                      final String title = result[0];
                                      final String content = result[1];

                                      // Crear una nota actualizada
                                      final updatedNote = Note(
                                        id: filteredNotes[index].id,
                                        title: title,
                                        content: content,
                                        dateNote: filteredNotes[index].dateNote,
                                        modifiedTime: DateTime.now(),
                                        userId: _supabaseService
                                                .getCurrentUserId() ??
                                            '',
                                      );

                                      try {
                                        // Actualizar en Supabase
                                        final serverUpdatedNote =
                                            await _supabaseService
                                                .updateNote(updatedNote);
                                        if (serverUpdatedNote != null) {
                                          setState(() {
                                            // Actualizar en la lista local
                                            final noteIndex =
                                                allNotes.indexWhere((note) =>
                                                    note.id ==
                                                    serverUpdatedNote.id);
                                            if (noteIndex != -1) {
                                              allNotes[noteIndex] =
                                                  serverUpdatedNote;
                                            }

                                            // Actualizar en la lista filtrada
                                            final filteredIndex = filteredNotes
                                                .indexWhere((note) =>
                                                    note.id ==
                                                    serverUpdatedNote.id);
                                            if (filteredIndex != -1) {
                                              filteredNotes[filteredIndex] =
                                                  serverUpdatedNote;
                                            }
                                          });
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Error al actualizar la nota: $e')),
                                        );
                                      }
                                    }
                                  },
                                  title: RichText(
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                          text:
                                              '${filteredNotes[index].title}\n',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              height: 1.5),
                                          children: [
                                            TextSpan(
                                                text: filteredNotes[index]
                                                    .content,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 14,
                                                    height: 1.5))
                                          ])),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Editado: ${DateFormat('EEE MMM d, yyyy h:mm a').format(filteredNotes[index].modifiedTime)}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey.shade800),
                                    ),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () async {
                                        final result = await confirmDialog(
                                            context, isDarkMode);
                                        if (result != null && result) {
                                          deleteNote(index);
                                        }
                                      },
                                      icon: Icon(
                                          color: Colors.black, Icons.delete)),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => EditScreen(
                        selectedDate: widget.selectedDate ?? DateTime.now(),
                      )));

          if (result != null) {
            final String title = result[0];
            final String content = result[1];

            // Crear una nueva nota
            final newNote = Note(
              title: title,
              content: content,
              dateNote: widget.selectedDate ?? DateTime.now(),
              modifiedTime: DateTime.now(),
              userId: _supabaseService.getCurrentUserId() ?? '',
            );

            try {
              // Guardar en Supabase
              final createdNote = await _supabaseService.createNote(newNote);
              if (createdNote != null) {
                setState(() {
                  // Actualizar las listas locales
                  allNotes.add(createdNote);
                  filteredNotes = List.from(allNotes);
                });
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al crear la nota: $e')),
              );
            }
          }
        },
        elevation: 2,
        backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
        child: Icon(
          color: isDarkMode ? Colors.white : Colors.black,
          Icons.add,
          size: 38,
        ),
      ),
    );
  }

  Future<dynamic> confirmDialog(BuildContext context, bool isDarkMode) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
            icon: Icon(Icons.info, color: Colors.grey),
            title: Text(
              '¿Seguro que quieres eliminar esta nota?',
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: SizedBox(
                      width: 60,
                      child: Text(
                        'Sí',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: SizedBox(
                      width: 60,
                      child: Text(
                        'No',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ))
              ],
            ),
          );
        });
  }
}
