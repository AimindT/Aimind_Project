import 'package:aimind/screens/functionalities_Screens/diario/calender_Screen.dart';
import 'package:aimind/screens/functionalities_Screens/terapia_Rapida/fast_Therapy_Screen.dart';
import 'package:aimind/screens/settings_screens/edit_Account_Screen2.dart';
import 'package:aimind/screens/settings_screens/settings_Screen2.dart';
import 'package:aimind/services/supabase_Service%20.dart';
import 'package:aimind/theme/theme_provider.dart';
import 'package:aimind/widgets/custom_dash_button.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  String userName = '';

  final SupabaseService _supabaseService = SupabaseService();

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    final nombre = await _supabaseService.getName();
    if (mounted) {
      setState(() {
        userName = nombre ?? 'usuario';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeData.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: themeProvider.themeData.colorScheme.surface,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: [
              HomePage(
                isDarkMode: isDarkMode,
                userName: userName,
              ),
              const SettingsScreen2(),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CurvedNavigationBar(
              backgroundColor: Colors.transparent,
              buttonBackgroundColor: isDarkMode ? Colors.black : Colors.white,
              color: isDarkMode ? Colors.black : Colors.white,
              animationDuration: const Duration(milliseconds: 300),
              items: [
                Icon(Icons.home,
                    size: 26, color: isDarkMode ? Colors.white : Colors.black),
                Icon(Icons.settings,
                    size: 26, color: isDarkMode ? Colors.white : Colors.black),
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

class HomePage extends StatelessWidget {
  final String url =
      'https://static.wikia.nocookie.net/mokeys-show/images/4/43/Screenshot_2025-01-10_212625.png/revision/latest?cb=20250112022914';
  final bool isDarkMode;
  final String userName;

  const HomePage({super.key, required this.isDarkMode, required this.userName});

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
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.grey[800],
                    ),
                  ),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 30,
                      color: isDarkMode ? Colors.white : Colors.grey[800],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditAccountScreen2(isDarkMode: isDarkMode)));
                },
                child: CircleAvatar(
                  radius: 32,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDarkMode ? Colors.white : Colors.black,
                        width: 3.0,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 230, 228, 228),
                      radius: 30,
                      backgroundImage: NetworkImage(url),
                    ),
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FastTherapyScreen()));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomDashButton(
                    iconImagePath: 'assets/images/diary.png',
                    buttontext: 'Diario Terapéutico',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CalendarScreen()));
                    },
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
