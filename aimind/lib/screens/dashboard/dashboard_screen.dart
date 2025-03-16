import 'package:aimind/screens/settings_screens/settings_Screen.dart';
import 'package:aimind/widgets/custom_dash_button.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Cambia la vista según el índice seleccionado
          _currentIndex == 0
              ? HomePage()
              : _currentIndex == 2
                  ? SettingsScreen()
                  : Container(), // Página vacía para "Notificaciones"

          // Barra de navegación inferior
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CurvedNavigationBar(
              backgroundColor: Colors.transparent,
              buttonBackgroundColor: Colors.black,
              color: Colors.black,
              animationDuration: const Duration(milliseconds: 300),
              items: const <Widget>[
                Icon(Icons.home, size: 26, color: Colors.white),
                Icon(Icons.notifications, size: 26, color: Colors.white),
                Icon(Icons.person, size: 26, color: Colors.white),
              ],
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Página de Inicio
class HomePage extends StatelessWidget {
  final String url =
      'https://static.wikia.nocookie.net/mokeys-show/images/4/43/Screenshot_2025-01-10_212625.png/revision/latest?cb=20250112022914';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hola,',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    'Chris Chaparro',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
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
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomDashButton(
                    iconImagePath: 'assets/images/background.png',
                    buttontext: 'Habla Con Aimind',
                    onPressed: () {},
                  ),
                  CustomDashButton(
                    iconImagePath: 'assets/images/RapTer.jpeg',
                    buttontext: 'Terapia Rapida',
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomDashButton(
                    iconImagePath: 'assets/images/calender.png',
                    buttontext: 'Agenda Una Cita',
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
