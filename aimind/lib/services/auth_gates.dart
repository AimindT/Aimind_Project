import 'package:aimind/screens/auth_Screens/login_screen.dart';
import 'package:aimind/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGates extends StatefulWidget {
  const AuthGates({super.key});

  @override
  State<AuthGates> createState() => _AuthGatesState();
}

class _AuthGatesState extends State<AuthGates> {
  Session? _session;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final auth = Supabase.instance.client.auth;
    Session? session = auth.currentSession;

    if (session == null) {
      setState(() {
        _session = null;
        _loading = false;
      });
      return;
    }

    // Si está expirado, intenta refrescarlo
    if (session.isExpired) {
      try {
        final refreshed = await auth.refreshSession();
        session = refreshed.session;
      } catch (e) {
        session = null;
      }
    }

    setState(() {
      _session = session;
      _loading = false;
    });

    // Escuchar futuros cambios de sesión (opcional)
    auth.onAuthStateChange.listen((data) {
      setState(() {
        _session = data.session;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _session != null ? const DashboardScreen() : const LoginScreen();
  }
}
