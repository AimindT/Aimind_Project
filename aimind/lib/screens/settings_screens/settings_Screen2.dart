import 'package:aimind/screens/auth_Screens/login_screen.dart';
import 'package:aimind/screens/settings_screens/edit_Account_Screen2.dart';
import 'package:aimind/screens/settings_screens/faq_Screen.dart';
import 'package:aimind/services/auth_services.dart';
import 'package:aimind/services/supabase_Service%20.dart';
import 'package:aimind/theme/theme_provider.dart';
import 'package:aimind/widgets/forward_button.dart';
import 'package:aimind/widgets/setting_Item.dart';
import 'package:aimind/widgets/setting_Switch.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen2 extends StatefulWidget {
  const SettingsScreen2({super.key});

  @override
  State<SettingsScreen2> createState() => _SettingsScreen2State();
}

class _SettingsScreen2State extends State<SettingsScreen2> {
  String userName = '';
  String? avatarUrl;
  bool isLoading = true;

  final SupabaseService _supabaseService = SupabaseService();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    final userData = await _supabaseService.getProfile(user!.id);
    if (mounted) {
      setState(() {
        userName = userData?['nombre'] ?? 'Usuario';
        avatarUrl = userData?['avatar_url'];
        isLoading = false;
      });
    }
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
      ),
      child: Icon(Icons.person, size: 30, color: Colors.grey[400]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeData.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: themeProvider.themeData.colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: Text(
                    'Configuración',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Tu Cuenta',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDarkMode ? Colors.white : Colors.black,
                            width: 3.0,
                          ),
                        ),
                        child: ClipOval(
                          child: avatarUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: avatarUrl!,
                                  fit: BoxFit.cover,
                                  width: 60,
                                  height: 60,
                                  placeholder: (context, url) =>
                                      _buildImagePlaceholder(),
                                  errorWidget: (context, url, error) =>
                                      _buildImagePlaceholder(),
                                )
                              : _buildImagePlaceholder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Spacer(),
                    ForwardButton(
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditAccountScreen2(
                                    isDarkMode: isDarkMode)));
                        if (result == true) {
                          // Refresh user data if profile was updated
                          fetchUserData();
                        }
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Configuración',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              SettingItem(
                title: 'Idioma',
                icon: Ionicons.earth,
                bgColor: Colors.orange.shade100,
                iconColor: Colors.orange,
                value: 'Español',
                onTap: () {},
              ),
              SizedBox(height: 20),
              SettingSwitch(
                title: "Modo Oscuro",
                icon: Icons.dark_mode,
                value: isDarkMode,
                onTap: (_) => themeProvider.toggleTheme(),
              ),
              SizedBox(height: 20),
              SettingItem(
                title: 'FAQs',
                icon: Ionicons.information_circle_outline,
                bgColor: Colors.grey.shade100,
                iconColor: Colors.grey,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FaqScreen()));
                },
              ),
              SizedBox(height: 20),
              SettingItem(
                title: 'Cerrar Sesión',
                icon: Ionicons.exit_outline,
                bgColor: Colors.red.shade100,
                iconColor: Colors.red,
                onTap: () {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    barrierDismissible: false,
                    confirmBtnText: 'Sí',
                    cancelBtnText: 'No',
                    cancelBtnTextStyle: TextStyle(color: Colors.red),
                    showCancelBtn: true,
                    text: '¿Deseas cerrar sesión?',
                    onConfirmBtnTap: () async {
                      // Cerrar el diálogo de confirmación primero
                      Navigator.pop(context);

                      try {
                        // Obtener el servicio de autenticación y cerrar sesión
                        final authService =
                            Provider.of<AuthService>(context, listen: false);

                        // Guardar el BuildContext actual antes de cualquier navegación
                        final currentContext = context;

                        // Cerrar sesión
                        await authService.signOut();

                        // Verificar si el contexto todavía está disponible
                        if (!currentContext.mounted) return;

                        // Navegar a la pantalla de inicio de sesión
                        await Navigator.pushReplacement(
                          currentContext,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );

                        // El contexto después de pushReplacement ya no es válido para mostrar alertas,
                        // así que usamos un enfoque diferente
                      } catch (e) {
                        print('Error al cerrar sesión: $e');
                        // No intentes mostrar ninguna alerta aquí, ya que el contexto puede ser inválido
                      }
                    },
                    onCancelBtnTap: () {
                      Navigator.pop(context);
                    },
                    title: '¿Estás seguro?',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
