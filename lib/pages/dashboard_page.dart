import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// [1] MODEL DATA: Membuat class untuk merepresentasikan data anak.
// Ini adalah praktik yang baik untuk mengelola data yang terstruktur.
class Anak {
  final String id;
  final String nama;
  final int umurBulan;
  final double beratBadan;
  final double tinggiBadan;
  final String statusImunisasi;
  final String fotoUrl;

  Anak({
    required this.id,
    required this.nama,
    required this.umurBulan,
    required this.beratBadan,
    required this.tinggiBadan,
    required this.statusImunisasi,
    required this.fotoUrl,
  });
}

// [2] STATEFUL WIDGET: Mengubah menjadi StatefulWidget
// agar dapat mengelola data dinamis (daftar anak).
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // [3] DUMMY DATA: Untuk keperluan desain, kita gunakan data statis dulu.
  // Nantinya, data ini bisa Anda ambil dari database Supabase.
  final List<Anak> _dataAnak = [
    Anak(
      id: '001',
      nama: 'Aisyah Putri',
      umurBulan: 12,
      beratBadan: 9.5,
      tinggiBadan: 74.0,
      statusImunisasi: 'Lengkap',
      fotoUrl: 'https://i.pravatar.cc/150?img=1', // Placeholder image
    ),
    Anak(
      id: '002',
      nama: 'Budi Santoso',
      umurBulan: 15,
      beratBadan: 10.2,
      tinggiBadan: 78.5,
      statusImunisasi: 'Dasar',
      fotoUrl: 'https://i.pravatar.cc/150?img=5', // Placeholder image
    ),
    Anak(
      id: '003',
      nama: 'Citra Lestari',
      umurBulan: 8,
      beratBadan: 8.1,
      tinggiBadan: 68.0,
      statusImunisasi: 'Lengkap',
      fotoUrl: 'https://i.pravatar.cc/150?img=3', // Placeholder image
    ),
    Anak(
      id: '004',
      nama: 'Daffa Akbar',
      umurBulan: 24,
      beratBadan: 12.5,
      tinggiBadan: 86.0,
      statusImunisasi: 'Booster',
      fotoUrl: 'https://i.pravatar.cc/150?img=8', // Placeholder image
    ),
  ];

  Future<void> _logout() async {
    // Fungsi logout tetap sama
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      // Menangani error jika terjadi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal logout: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Anak Posyandu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          )
        ],
      ),
      // [4] BODY UTAMA: Menggunakan ListView.builder untuk menampilkan daftar data
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: _dataAnak.length,
        itemBuilder: (context, index) {
          final anak = _dataAnak[index];
          // Setiap item di list akan menjadi widget Card yang kita buat di bawah
          return _buildAnakCard(anak);
        },
      ),
      // [5] FLOATING ACTION BUTTON: Tombol untuk menambah data baru
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementasi fungsi tambah data anak
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur Tambah Data Anak')),
          );
        },
        tooltip: 'Tambah Data Anak',
        child: const Icon(Icons.add),
      ),
    );
  }

  // [6] WIDGET KARTU ANAK: Widget terpisah untuk membuat tampilan per anak
  // Ini membuat kode utama (build method) lebih rapi dan mudah dibaca.
  Widget _buildAnakCard(Anak anak) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: () {
          // TODO: Implementasi navigasi ke halaman detail anak
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Melihat detail ${anak.nama}')),
          );
        },
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Bagian Header: Foto & Nama ---
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(anak.fotoUrl),
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          anak.nama,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          '${anak.umurBulan} bulan',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24.0),
              // --- Bagian Detail: Berat, Tinggi, Imunisasi ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoKolom(
                    context,
                    icon: Icons.monitor_weight_outlined,
                    label: 'Berat',
                    value: '${anak.beratBadan} kg',
                    color: Colors.blue,
                  ),
                  _buildInfoKolom(
                    context,
                    icon: Icons.height_outlined,
                    label: 'Tinggi',
                    value: '${anak.tinggiBadan} cm',
                    color: Colors.green,
                  ),
                  _buildInfoKolom(
                    context,
                    icon: Icons.shield_outlined,
                    label: 'Imunisasi',
                    value: anak.statusImunisasi,
                    color: Colors.orange,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // [7] WIDGET BANTUAN: Untuk membuat kolom info (ikon, nilai, label)
  // agar tidak menulis kode yang sama berulang kali.
  Widget _buildInfoKolom(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 2.0),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}