import 'dart:io';

import 'package:aimind/models/note.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final response =
          await _supabase.from('profiles').select().eq('id', userId).single();
      return response;
    } catch (e) {
      print('Error al obtener perfil: $e');
      return null;
    }
  }

  Future<String?> getName() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      try {
        final response = await _supabase
            .from('profiles')
            .select('nombre')
            .eq('id', user.id)
            .single();
        return response['nombre'] ?? 'usuario';
      } catch (e) {
        print('Error al obtener el nombre: $e');
      }
    }
    return null;
  }

  Future<String> uploadProfileImage(String userId, File imageFile) async {
    try {
      // Validamos el archivo
      if (!await imageFile.exists()) {
        throw Exception('❗ El archivo no existe');
      }

      // Verificamos el tamaño (máx 5MB)
      if (await imageFile.length() > 5 * 1024 * 1024) {
        throw Exception('⚠️ La imagen es muy pesada (máx 5MB)');
      }

      // Preparamos el nombre del archivo
      final fileExt = imageFile.path.split('.').last;
      final fileName = 'avatar_$userId.$fileExt';
      final filePath = 'users/$userId/$fileName';

      // Subimos la imagen
      await _supabase.storage
          .from('profiles-images')
          .upload(filePath, imageFile,
              fileOptions: FileOptions(
                upsert: true,
                contentType: 'image/$fileExt',
              ));

      // Obtenemos la URL pública
      final imageUrl =
          _supabase.storage.from('profiles-images').getPublicUrl(filePath);

      // Actualizamos el perfil
      await _supabase
          .from('profiles')
          .update({'avatar_url': imageUrl}).eq('id', userId);

      return imageUrl;
    } catch (e) {
      debugPrint('🔥 Error en uploadProfileImage: $e');
      throw Exception('No se pudo subir la imagen: ${e.toString()}');
    }
  }

  Future<String?> getEmail() async {
    final user = _supabase.auth.currentUser;
    return user?.email;
  }

  Future<String?> getUserName() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      try {
        final response = await _supabase
            .from('profiles')
            .select('usuario')
            .eq('id', user.id)
            .single();
        return response['usuario'] ?? 'nombre';
      } catch (e) {
        print('Error al obtener el nombre de usuario: $e');
      }
    }
    return null;
  }

  Future<void> createProfile(Map<String, dynamic> profileData) async {
    try {
      await _supabase.from('profiles').insert(profileData);
    } catch (e) {
      print('Error al crear perfil: $e');
    }
  }

  Future<void> updateProfile(
      String userId, Map<String, dynamic> updates) async {
    try {
      await _supabase.from('profiles').update(updates).eq('id', userId);
    } catch (e) {
      print('Error al actualizar perfil: $e');
    }
  }

  Future<void> deleteProfile(String userId) async {
    try {
      await _supabase.from('profiles').delete().eq('id', userId);
    } catch (e) {
      print('Error al eliminar perfil: $e');
    }
  }

  Future<List<Note>> getNotesByDate(DateTime date) async {
    final userId = getCurrentUserId();
    if (userId == null) return [];

    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final response = await Supabase.instance.client
        .from('notes')
        .select()
        .eq('id', userId)
        .eq('date_note', formattedDate)
        .order('date_edit', ascending: false);

    return (response as List).map((note) => Note.fromJson(note)).toList();
  }

  // Obtener todas las notas del usuario
  Future<List<Note>> getNotes() async {
    final userId = getCurrentUserId();
    if (userId == null) return [];

    final response = await Supabase.instance.client
        .from('notes')
        .select()
        .eq('id', userId)
        .order('date_edit', ascending: false);

    return (response as List).map((note) => Note.fromJson(note)).toList();
  }

  Future<void> deleteNote(String noteId) async {
    final userId = getCurrentUserId();
    if (userId == null) return;

    await Supabase.instance.client
        .from('notes')
        .delete()
        .eq('id_note', noteId)
        .eq('id', userId);
  }

  String? getCurrentUserId() {
    return Supabase.instance.client.auth.currentUser?.id;
  }

  Future<Note?> updateNote(Note note) async {
    final userId = getCurrentUserId();
    if (userId == null || note.id == null) return null;

    final data = note.toJson();
    final response = await Supabase.instance.client
        .from('notes')
        .update(data)
        .eq('id_note', note.id as Object)
        .eq('id', userId)
        .select()
        .single();

    return Note.fromJson(response);
  }

  Future<Note?> createNote(Note note) async {
    final userId = getCurrentUserId();
    if (userId == null) return null;

    final data = note.toJson();
    final response = await Supabase.instance.client
        .from('notes')
        .insert(data)
        .select()
        .single();

    return Note.fromJson(response);
  }
}

String? getCurrentUserId() {
  return Supabase.instance.client.auth.currentUser?.id;
}

// Obtener todas las notas del usuario
Future<List<Note>> getNotes() async {
  final userId = getCurrentUserId();
  if (userId == null) return [];

  final response = await Supabase.instance.client
      .from('notes')
      .select()
      .eq('id', userId)
      .order('date_edit', ascending: false);

  return (response as List).map((note) => Note.fromJson(note)).toList();
}

// Obtener notas por fecha específica

// Crear una nueva nota
Future<Note?> createNote(Note note) async {
  final userId = getCurrentUserId();
  if (userId == null) return null;

  final data = note.toJson();
  final response = await Supabase.instance.client
      .from('notes')
      .insert(data)
      .select()
      .single();

  return Note.fromJson(response);
}

// Actualizar una nota existente
Future<Note?> updateNote(Note note) async {
  final userId = getCurrentUserId();
  if (userId == null || note.id == null) return null;

  final data = note.toJson();
  final response = await Supabase.instance.client
      .from('notes')
      .update(data)
      .eq('id_note', note.id!)
      .eq('id', userId)
      .select()
      .single();

  return Note.fromJson(response);
}

// Eliminar una nota

extension on String {}
