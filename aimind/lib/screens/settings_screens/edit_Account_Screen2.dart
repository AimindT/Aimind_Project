import 'dart:io';
import 'package:aimind/services/supabase_Service%20.dart';
import 'package:aimind/theme/theme_provider.dart';
import 'package:aimind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditAccountScreen2 extends StatefulWidget {
  final bool isDarkMode;
  const EditAccountScreen2({super.key, required this.isDarkMode});

  @override
  State<EditAccountScreen2> createState() => _EditAccountScreen2State();
}

class _EditAccountScreen2State extends State<EditAccountScreen2> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String userName = '';
  bool isLoading = true;
  File? _imageFile;
  String? avatarUrl;
  final ImagePicker _picker = ImagePicker();
  final String defaultAvatarUrl = 'assets/images/background.png';

  @override
  void initState() {
    super.initState();
    Supabase.instance.client.auth.refreshSession().then((_) => loadUserData());
  }

  Future<void> loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final data = await SupabaseService().getProfile(user.id);
      if (data != null) {
        setState(() {
          nameController.text = data['nombre'] ?? '';
          usernameController.text = data['usuario'] ?? '';
          emailController.text = data['correo'] ?? '';
          avatarUrl = data['avatar_url'];
          isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
    }
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar imagen'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Tomar foto'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Elegir de galería'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeData.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          'Editar Perfil',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: _showImagePickerDialog,
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 3.0,
                            ),
                          ),
                          child: ClipOval(
                            child: _imageFile != null
                                ? Image.file(_imageFile!, fit: BoxFit.cover)
                                : (avatarUrl != null && avatarUrl!.isNotEmpty)
                                    ? Image.network(
                                        avatarUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error,
                                                stackTrace) =>
                                            Image.asset(
                                                'assets/images/background.png',
                                                fit: BoxFit.cover),
                                      )
                                    : Image.asset(
                                        'assets/images/background.png',
                                        fit: BoxFit.cover,
                                      ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImagePickerDialog,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.black,
                          ),
                          child: const Icon(Icons.camera_alt_outlined,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    SizedBox(
                      height: 90,
                      width: 350,
                      child: CustomTextField(
                        hintText: 'Nombre',
                        controller: nameController,
                        prefixIcon: Icons.person,
                        keyboardType: TextInputType.text,
                        maxLegth: 100,
                      ),
                    ),
                    SizedBox(
                      height: 90,
                      width: 350,
                      child: CustomTextField(
                        hintText: 'Usuario',
                        controller: usernameController,
                        prefixIcon: Icons.supervised_user_circle_sharp,
                        keyboardType: TextInputType.text,
                        maxLegth: 50,
                      ),
                    ),
                    SizedBox(
                      height: 90,
                      width: 350,
                      child: CustomTextField(
                        hintText: 'Correo',
                        controller: emailController,
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        maxLegth: 255,
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      width: 350,
                      child: CustomTextField(
                        hintText: 'Contraseña',
                        controller: passwordController,
                        prefixIcon: Icons.lock,
                        isPassword: true,
                        keyboardType: TextInputType.text,
                        maxLegth: 100,
                      ),
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: 350,
                      height: 70,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () async {
                          final user =
                              Supabase.instance.client.auth.currentUser;
                          if (user == null) return;

                          try {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(
                                  child: CircularProgressIndicator()),
                            );

                            String? newAvatarUrl = avatarUrl;

                            if (_imageFile != null) {
                              newAvatarUrl = await SupabaseService()
                                  .uploadProfileImage(user.id, _imageFile!);
                            }

                            await SupabaseService().updateProfile(user.id, {
                              'nombre': nameController.text,
                              'usuario': usernameController.text,
                              'correo': emailController.text,
                              'avatar_url': newAvatarUrl,
                            });

                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('✅ Perfil actualizado!')),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('❌ Error: ${e.toString()}')),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Guardar Cambios',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
