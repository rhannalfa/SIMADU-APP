
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// UBAH IMPORT INI
import '../../pages/home_page.dart'; // <-- Arahkan ke HomePage
import '../login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Cek jika ada sesi yang aktif
        if (snapshot.hasData && snapshot.data?.session != null) {
          // UBAH BARIS INI
          // Jika user sudah login, tampilkan HomePage (wadah navigasi)
          return const HomePage(); // <-- BUKAN DashboardPage
        } else {
          // Jika tidak ada sesi, tampilkan Login
          return const LoginPage();
        }
      },
    );
  }
}