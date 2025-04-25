import 'dart:io';
import 'package:aimind/services/supabase_Service%20.dart';
import 'package:aimind/theme/theme_provider.dart';
import 'package:aimind/widgets/custom_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditAccountScreen2 extends StatefulWidget {
  final bool isDarkMode;
  final Map<String, dynamic>? initialData;

  const EditAccountScreen2({
    super.key,
    required this.isDarkMode,
    this.initialData,
  });

  @override
  State<EditAccountScreen2> createState() => _EditAccountScreen2State();
}

class _EditAccountScreen2State extends State<EditAccountScreen2> {
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  File? _imageFile;
  String? avatarUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // Inicializa con datos precargados si existen
    if (widget.initialData != null) {
      nameController =
          TextEditingController(text: widget.initialData!['nombre'] ?? '');
      usernameController =
          TextEditingController(text: widget.initialData!['usuario'] ?? '');
      emailController =
          TextEditingController(text: widget.initialData!['correo'] ?? '');
      avatarUrl = widget.initialData!['avatar_url'];
    } else {
      nameController = TextEditingController();
      usernameController = TextEditingController();
      emailController = TextEditingController();
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    if (mounted) setState(() => isLoading = true);

    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final data = await SupabaseService().getProfile(user.id);
        if (data != null && mounted) {
          setState(() {
            nameController.text = data['nombre'] ?? '';
            usernameController.text = data['usuario'] ?? '';
            emailController.text = data['correo'] ?? '';
            avatarUrl = data['avatar_url'];
          });
        }
      } finally {
        if (mounted) setState(() => isLoading = false);
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null && mounted) {
        setState(() => _imageFile = File(pickedFile.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error al seleccionar imagen: ${e.toString()}')),
        );
      }
    }
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: const Text('Selecciona tu imagen')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text(
                'Tomar foto',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Center(
                child: const Text(
                  'Elegir de la galería',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
      ),
      child: Icon(Icons.person, size: 50, color: Colors.grey[400]),
    );
  }

  Widget _buildSkeletonLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          _buildImagePlaceholder(),
          const SizedBox(height: 50),
          Container(
            width: 350,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 350,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 350,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeData.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Editar Perfil',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? _buildSkeletonLoader()
            : Column(
                children: [
                  const SizedBox(height: 50),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: _showImagePickerDialog,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: _imageFile != null
                                ? Image.file(_imageFile!, fit: BoxFit.cover)
                                : avatarUrl != null
                                    ? CachedNetworkImage(
                                        imageUrl: avatarUrl!,
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) =>
                                            _buildImagePlaceholder(),
                                        errorWidget: (_, __, ___) =>
                                            _buildImagePlaceholder(),
                                      )
                                    : _buildImagePlaceholder(),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
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
                      enabled: false,
                    ),
                  ),
                  // SizedBox(
                  //   height: 100,
                  //   width: 350,
                  //   child: CustomTextField(
                  //     hintText: 'Contraseña',
                  //     controller: passwordController,
                  //     prefixIcon: Icons.lock,
                  //     isPassword: true,
                  //     keyboardType: TextInputType.text,
                  //     maxLegth: 100,
                  //   ),
                  // ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize:
                            const Size(150, 48), // Ancho y alto mínimos
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _saveProfile,
                      child: const Text(
                        'Guardar cambios',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      setState(() => isLoading = true);

      // 1. Actualizar email en auth si cambió
      if (emailController.text != user.email) {
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(email: emailController.text),
        );
      }

      // 2. Subir imagen si hay una nueva
      String? newAvatarUrl;
      if (_imageFile != null) {
        newAvatarUrl =
            await SupabaseService().uploadProfileImage(user.id, _imageFile!);
      }

      // 3. Actualizar perfil (incluyendo el email)
      await SupabaseService().updateProfile(user.id, {
        'nombre': nameController.text,
        'usuario': usernameController.text,
        'correo': emailController.text, // Actualiza también en profiles
        'avatar_url': newAvatarUrl ?? avatarUrl,
      });

      // 4. Actualizar contraseña si se proporcionó
      if (passwordController.text.isNotEmpty) {
        await Supabase.instance.client.auth
            .updateUser(UserAttributes(password: passwordController.text));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado correctamente')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
