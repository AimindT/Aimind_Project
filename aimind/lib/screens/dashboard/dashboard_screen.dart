import 'package:aimind/screens/functionalities_Screens/chat_bot/chatScreen.dart';
import 'package:aimind/screens/functionalities_Screens/diario/calender_Screen.dart';
import 'package:aimind/screens/settings_screens/edit_Account_Screen2.dart';
import 'package:aimind/screens/settings_screens/settings_Screen2.dart';
import 'package:aimind/services/supabase_Service%20.dart';
import 'package:aimind/theme/theme_provider.dart';
import 'package:aimind/widgets/custom_dash_button.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
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
                avatarUrl: avatarUrl,
                onProfileUpdated: () => fetchUserData(),
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
  final bool isDarkMode;
  final String userName;
  final String? avatarUrl;
  final VoidCallback? onProfileUpdated;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.userName,
    this.avatarUrl,
    this.onProfileUpdated,
  });

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
                onTap: () async {
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditAccountScreen2(isDarkMode: isDarkMode)));
                  if (result == true && onProfileUpdated != null) {
                    onProfileUpdated!();
                  }
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen()),
                      );
                    },
                  ),

                  // CustomDashButton(
                  //   iconImagePath: 'assets/images/RapTer.jpeg',
                  //   buttontext: 'Terapia Rapida',
                  //   onPressed: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => const FastTherapyScreen()));
                  //   },
                  // ),
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
