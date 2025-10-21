import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/login/login_page.dart'; 

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> profile;
  const ProfilePage({super.key, required this.profile});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Fungsi logout diimplementasikan secara penuh
  Future<void> _logout() async {
    try {
      // 1. Melakukan sign out dari Supabase
      await Supabase.instance.client.auth.signOut();

      // 2. Navigasi kembali ke LoginPage dan hapus semua halaman sebelumnya
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false, // Kondisi false akan menghapus semua rute
        );
      }
    } catch (e) {
      // Tampilkan pesan error jika logout gagal
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal melakukan logout: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = widget.profile['name'] ?? 'Nama Pengguna';
    final email = widget.profile['email'] ?? 'email@pengguna.com';
    final avatarUrl = widget.profile['avatar_url'];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profil Saya', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3B82F6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProfileHeader(context, userName, email, avatarUrl),
          const SizedBox(height: 20),
          _buildActionMenu(context),
          const SizedBox(height: 20),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  // Widget untuk header profil (foto, nama, email)
  Widget _buildProfileHeader(BuildContext context, String name, String email, String? avatarUrl) {
    return Card(
      elevation: 4.0,
      shadowColor:const Color(0x14000000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      avatarUrl != null ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl == null
                      ? const Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2)),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.edit, color: Colors.white, size: 16),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menu seperti Edit Profil, dll.
  Widget _buildActionMenu(BuildContext context) {
    return Card(
      elevation: 2.0,
      shadowColor: const Color(0x14000000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        children: [
          _buildMenuTile(
            context,
            icon: Icons.person_outline,
            title: 'Edit Profil',
            onTap: () { /* TODO: Navigasi ke halaman edit profil */ },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildMenuTile(
            context,
            icon: Icons.lock_outline,
            title: 'Ubah Kata Sandi',
            onTap: () { /* TODO: Navigasi ke halaman ubah kata sandi */ },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildMenuTile(
            context,
            icon: Icons.info_outline,
            title: 'Tentang Aplikasi',
            onTap: () { /* TODO: Tampilkan dialog tentang aplikasi */ },
          ),
        ],
      ),
    );
  }

  // Widget untuk tombol logout
  Widget _buildLogoutButton(BuildContext context) {
    return Card(
      elevation: 2.0,
      shadowColor: const Color(0x14000000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: _buildMenuTile(
        context,
        icon: Icons.logout,
        title: 'Logout',
        isLogout: true, 
        onTap: _logout,
      ),
    );
  }

  // Helper untuk membuat satu baris menu
  ListTile _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    final color = isLogout ? Colors.red : Theme.of(context).primaryColor;
    final textColor = isLogout ? Colors.red : Colors.black87;

    return ListTile(
      leading: Icon(icon, color: color),
      title:
          Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: textColor)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}