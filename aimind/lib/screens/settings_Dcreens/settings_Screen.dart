import 'package:aimind/screens/auth_Screens/login_screen.dart';
import 'package:aimind/screens/settings_screens/faq_Screen.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:aimind/services/auth_services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

AuthService authService = AuthService();

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double padding = constraints.maxWidth * 0.05;
          return ListView(
            padding: EdgeInsets.all(padding),
            physics: const BouncingScrollPhysics(),
            children: [
              SizedBox(height: constraints.maxHeight * 0.05),
              userTile(),
              divider(),
              colorTiles(),
              divider(),
              bwTiles(context),
            ],
          );
        },
      ),
    );
  }

  Widget userTile() {
    String url =
        'https://static.wikia.nocookie.net/mokeys-show/images/4/43/Screenshot_2025-01-10_212625.png/revision/latest?cb=20250112022914';
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color.fromARGB(255, 230, 228, 228),
        backgroundImage: NetworkImage(url),
        radius: MediaQuery.of(context).size.width * 0.07,
      ),
      title: const Text(
        'Chris Chaparro',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

Widget divider() {
  return const Padding(
    padding: EdgeInsets.all(8.0),
    child: Divider(thickness: 1.5),
  );
}

Widget colorTiles() {
  return Column(
    children: [
      colorTile(Icons.person_outline, Colors.deepPurple, 'Tu perfil',
          onTap: () {}),
      SizedBox(
        height: 20,
      ),
      colorTile(Icons.settings_outlined, Colors.blue, 'Configuración',
          onTap: () {}),
    ],
  );
}

Widget bwTiles(BuildContext context) {
  return Column(
    children: [
      bwTile(Icons.info_outline, 'FAQs', () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FaqScreen()));
      }),
      SizedBox(height: 20),
      colorTile(
        Icons.login_outlined,
        Colors.pink,
        'Salir',
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
              Navigator.pop(context); // Cerrar el QuickAlert de confirmación

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
                  MaterialPageRoute(builder: (context) => LoginScreen()),
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
  );
}

Widget bwTile(IconData icon, String text, VoidCallback onTap) {
  return colorTile(icon, Colors.black, text, blackAndWhite: true, onTap: onTap);
}

Widget colorTile(IconData icon, Color color, String text,
    {bool blackAndWhite = false, required VoidCallback onTap}) {
  Color pickedColor = const Color(0xfff3f4fe);
  return LayoutBuilder(
    builder: (context, constraints) {
      double iconSize = constraints.maxWidth * 0.07;
      return ListTile(
        leading: Container(
          height: iconSize * 2,
          width: iconSize * 2,
          decoration: BoxDecoration(
            color: blackAndWhite ? pickedColor : color.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(iconSize * 0.8),
          ),
          child: Icon(icon, color: color, size: iconSize),
        ),
        title: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing:
            const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
        onTap: onTap,
      );
    },
  );
}
