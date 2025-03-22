import 'package:aimind/screens/auth_Screens/login_screen.dart';
import 'package:aimind/screens/settings_screens/edit_Account_Screen.dart';
import 'package:aimind/screens/settings_screens/faq_Screen.dart';
import 'package:aimind/screens/settings_screens/settings_Screen.dart';
import 'package:aimind/theme/theme_provider.dart';
import 'package:aimind/widgets/forward_button.dart';
import 'package:aimind/widgets/setting_Item.dart';
import 'package:aimind/widgets/setting_Switch.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class SettingsScreen2 extends StatefulWidget {
  const SettingsScreen2({super.key});

  @override
  State<SettingsScreen2> createState() => _SettingsScreen2State();
}

class _SettingsScreen2State extends State<SettingsScreen2> {
  final String url =
      'https://static.wikia.nocookie.net/mokeys-show/images/4/43/Screenshot_2025-01-10_212625.png/revision/latest?cb=20250112022914';

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
                            color: Colors.black,
                            width: 3.0,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 230, 228, 228),
                          radius: 30,
                          backgroundImage: NetworkImage(url),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chris Chaparro',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Fullstack Dev',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        )
                      ],
                    ),
                    Spacer(),
                    ForwardButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditAccountScreen()));
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
              // SettingItem(
              //   title: 'Notificaciones',
              //   icon: Ionicons.notifications,
              //   bgColor: Colors.blue.shade100,
              //   iconColor: Colors.blue,
              //   onTap: () {},
              // ),
              // SizedBox(height: 20),
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
                      Navigator.pop(
                          context); // Cerrar el QuickAlert de confirmación

                      // Mostrar QuickAlert de carga
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.loading,
                        title: 'Cargando',
                        text: 'Cerrando sesión...',
                        barrierDismissible: false,
                      );

                      try {
                        await authService.signOut();
                        Navigator.pop(context); // cerrar el QuickAlert de carga
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                        QuickAlert.show(
                          context: context,
                          title: 'Éxito',
                          type: QuickAlertType.success,
                          text: 'Sesión cerrada con éxito!',
                          barrierDismissible: false,
                        );
                      } catch (e) {
                        Navigator.pop(context); // cerrar el QuickAlert de carga
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          text: 'Error al cerrar sesión: $e',
                          barrierDismissible: false,
                        );
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
