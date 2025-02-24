import 'package:aimind/services/auth_services.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // get auth service
  final authservice = AuthService();

  // logout button
  void logout() async {
    await authservice.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = authservice.getCurrentUserEmail();
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Profile')),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      body: Center(
          child: Text(
        currentEmail.toString(),
        style: TextStyle(fontSize: 24),
      )),
    );
  }
}
