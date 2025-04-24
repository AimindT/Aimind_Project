import 'dart:io';

import 'package:flutter/material.dart';
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
      final fileName = 'avatar_$userId.${fileExt}';
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
}

extension on String {
  get error => null;
}
