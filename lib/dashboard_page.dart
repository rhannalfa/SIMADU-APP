import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Jangan lupa import Supabase

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        // --- TAMBAHKAN KODE INI ---
        actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            // TAMBAHKAN PRINT INI UNTUK DEBUGGING
            print('Mencoba logout...'); 
            
            await Supabase.instance.client.auth.signOut();
            
            print('Proses signOut selesai.'); // Tambahkan ini juga
          },
          tooltip: 'Logout',
        )
      ],
        // ------------------------
      ),
      body: const Center(
        child: Text('Selamat! Kamu berhasil login.'),
      ),
    );
  }
}