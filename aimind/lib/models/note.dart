// lib/models/note.dart
import 'package:intl/intl.dart';

class Note {
  final String? id;
  final String title;
  final String content;
  final DateTime dateNote;
  final DateTime modifiedTime;
  final String userId;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.dateNote,
    required this.modifiedTime,
    required this.userId,
  });

  // Factory constructor para crear Note desde un Map (JSON de Supabase)
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id_note'],
      title: json['title'] ?? '',
      content: json['note'] ?? '',
      dateNote: DateTime.parse(json['date_note']),
      modifiedTime: DateTime.parse(json['date_edit']),
      userId: json['id'],
    );
  }

  // Convertir Note a un Map para enviarlo a Supabase
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'note': content,
      'date_note': DateFormat('yyyy-MM-dd').format(dateNote),
      'date_edit': modifiedTime.toIso8601String(),
      'id': userId,
    };
  }
}
