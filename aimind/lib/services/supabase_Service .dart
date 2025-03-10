import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

 Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return response;
    } catch (e) {
      print('Error al obtener perfil: $e');
      return null;
    }
  }

  Future<void> createProfile(Map<String, dynamic> profileData) async {
    final response = await _supabase.from('profiles').insert(profileData);

    if (response.error != null) {
      print('Error al crear perfil: ${response.error!.message}');
    }
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> updates) async {
    final response = await _supabase
        .from('profiles')
        .update(updates)
        .eq('id', userId);

    if (response.error != null) {
      print('Error al actualizar perfil: ${response.error!.message}');
    }
  }

  Future<void> deleteProfile(String userId) async {
    final response = await _supabase
        .from('profiles')
        .delete()
        .eq('id', userId);

    if (response.error != null) {
      print('Error al eliminar perfil: ${response.error!.message}');
    }
  }
}