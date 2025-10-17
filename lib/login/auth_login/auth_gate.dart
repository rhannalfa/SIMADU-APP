import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../pages/dashboard_page.dart';
import '../login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // StreamBuilder ini yang secara ajaib melakukan navigasi otomatis
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Cek jika ada sesi yang aktif
        if (snapshot.hasData && snapshot.data?.session != null) {
          // Jika user sudah login, tampilkan Dashboard
          return const DashboardPage();
        } else {
          // Jika tidak ada sesi (null setelah logout), tampilkan Login
          return const LoginPage();
        }
      },
    );
  }
}