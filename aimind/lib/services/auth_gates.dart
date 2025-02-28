import 'package:aimind/screens/auth_Screens/login_screen.dart';
import 'package:aimind/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGates extends StatelessWidget {
  const AuthGates({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Listen to auth state pages
      stream: Supabase.instance.client.auth.onAuthStateChange,
      //Build appropiate page
      builder: (context, snapshot) {
        //Loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        //Check if there is a valid session
        final session = snapshot.hasData ? snapshot.data!.session : null;
        if (session != null) {
          return DashboardScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
