import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profil_page.dart';

// --- HALAMAN UTAMA (DASHBOARD) ---
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _supabase = Supabase.instance.client;
  Map<String, dynamic>? _profile;
  Map<String, dynamic>? _upcomingSchedule;
  List<Map<String, dynamic>> _children = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    // Fungsi ini tidak diubah
    try {
      final userId = _supabase.auth.currentUser!.id;
      final today = DateTime.now().toIso8601String();

      final profileRes =
          await _supabase.from('profiles').select().eq('id', userId).single();
      _profile = profileRes;

      final scheduleRes = await _supabase
          .from('schedules')
          .select()
          .gte('schedule_date', today)
          .order('schedule_date', ascending: true)
          .limit(1);
      if (scheduleRes.isNotEmpty) {
        _upcomingSchedule = scheduleRes.first;
      }

      final childrenRes =
          await _supabase.from('children').select().eq('parent_id', userId);
      _children = List<Map<String, dynamic>>.from(childrenRes);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // [DIUBAH] Warna background diubah menjadi putih polos
      backgroundColor: Colors.white,
      // [DIHAPUS] appBar: _buildAppBar() telah dihapus
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SafeArea( // Menambahkan SafeArea agar konten tidak terlalu ke atas
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // 1. Pesan Selamat Datang
                    _buildWelcomeCard(),
                    const SizedBox(height: 20),

                    // 2. Kartu Banner Utama
                    _buildHeroCard(),
                    const SizedBox(height: 20),

                    // 3. Kartu Statistik
                    _buildStatsSection(),
                    const SizedBox(height: 20),

                    // 4. Kartu Kegiatan Terdekat
                    _buildUpcomingActivityCard(),
                  ],
                ),
              ),
            ),
    );
  }

  // --- WIDGET BUILDER HELPERS ---

  // [DIHAPUS] Seluruh fungsi _buildAppBar() sudah dihapus.

Widget _buildWelcomeCard() {
    final userName = _profile?['name'] ?? 'Pengguna';
    const posyanduName = 'Posyandu Mawar';

    // [DIUBAH] Dibungkus dengan GestureDetector untuk aksi klik
    return GestureDetector(
      onTap: () {
        // Cek jika data profil tidak null sebelum navigasi
        if (_profile != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              // Mengirim data profil ke halaman ProfilePage
              builder: (context) => ProfilePage(profile: _profile!),
            ),
          );
        } else {
          // Tampilkan pesan jika data belum siap
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data profil belum dimuat.')),
          );
        }
      },
      child: Card(
        elevation: 3.0,
        shadowColor: const Color(0x14000000),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFF4A6A8A),
                child: Icon(Icons.person, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, Bunda $userName 👋',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Selamat datang di $posyanduName',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildHeroCard() {
    return Card(
      color: const Color(0xFF60A5FA), // Warna biru sedikit lebih muda
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 4.0,
      shadowColor: Colors.blue.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Posyandu Sehat, Anak Ceria!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pantau pertumbuhan anak dan jadwal imunisasi dengan mudah melalui SIMADU.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
            ),
            const SizedBox(height: 16),
            // TODO: Ganti Icon dengan gambar ilustrasi dari aset Anda
            // Contoh: Image.asset('assets/images/illustration.png', height: 80)
            const Icon(Icons.escalator_warning, color: Colors.white, size: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    String totalAnak = _children.length.toString();
    String jadwalAktif = _upcomingSchedule != null ? '1' : '0';

    return Row(
      children: [
        Expanded(child: _buildStatCard('Total Anak', totalAnak)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Jadwal Aktif', jadwalAktif)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 3.0,
      shadowColor: const Color(0x14000000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF60A5FA),
                  ),
            ),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingActivityCard() {
    return Card(
      elevation: 3.0,
      shadowColor: const Color(0x14000000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0x1A2196F3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.edit_calendar,
                  color: Color(0xFF60A5FA), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kegiatan Terdekat',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    _upcomingSchedule == null
                        ? 'Tidak ada jadwal terdekat.'
                        : (_upcomingSchedule!['title'] ?? 'Jadwal Posyandu'),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}