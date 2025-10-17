import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// [MODIFIKASI 1]: Model Data disesuaikan dengan struktur tabel 'children' di Supabase.
// - Nama properti diubah (e.g., nama -> name).
// - Menambahkan properti 'nik'.
// - Tipe data disesuaikan (e.g., id menjadi int, birth_date menjadi DateTime).
// - Menghapus 'statusImunisasi' karena tidak ada di tabel.
class Anak {
  final int id; // Tipe data id di database adalah int8 (integer)
  final String name;
  final DateTime birth_date;
  final String gender;
  final double birth_weight;
  final double birth_height;
  final String? blood_type; // Nullable jika bisa kosong
  final String? photo;      // Nullable jika bisa kosong
  final String? nik;        // Nullable jika bisa kosong

  Anak({
    required this.id,
    required this.name,
    required this.birth_date,
    required this.gender,
    required this.birth_weight,
    required this.birth_height,
    this.blood_type,
    this.photo,
    this.nik,
  });

  // Factory constructor untuk membuat objek Anak dari data Map (JSON) yang diterima dari Supabase.
  factory Anak.fromMap(Map<String, dynamic> map) {
    return Anak(
      id: map['id'],
      name: map['name'] as String,
      birth_date: DateTime.parse(map['birth_date'] as String),
      gender: map['gender'] as String,
      // Konversi dari numeric/double
      birth_weight: (map['birth_weight'] as num).toDouble(),
      birth_height: (map['birth_height'] as num).toDouble(),
      blood_type: map['blood_type'] as String?,
      photo: map['photo'] as String?,
      nik: map['nik'] as String?,
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // [MODIFIKASI 2]: Data dummy dihapus dan diganti dengan Future.
  // Future ini akan menampung proses pengambilan data dari Supabase.
  late final Future<List<Anak>> _anakFuture;

  @override
  void initState() {
    super.initState();
    // Memanggil fungsi untuk mengambil data saat halaman pertama kali dibuka.
    _anakFuture = _getAnakData();
  }

  // [MODIFIKASI 3]: Fungsi baru untuk mengambil data dari Supabase.
  // Fungsi ini bersifat async dan akan mengembalikan List<Anak> di masa depan (Future).
  Future<List<Anak>> _getAnakData() async {
    // Mengambil data dari tabel 'children', diurutkan berdasarkan created_at terbaru.
    final response = await Supabase.instance.client
        .from('children')
        .select()
        .order('created_at', ascending: false);

    // Supabase mengembalikan List<Map<String, dynamic>>.
    // Kita perlu mengubahnya menjadi List<Anak> menggunakan factory constructor.
    final List<Anak> anakList = response.map((data) {
      return Anak.fromMap(data);
    }).toList();

    return anakList;
  }

  // Fungsi untuk menghitung umur dalam bulan dari tanggal lahir.
  int _calculateAgeInMonths(DateTime birthDate) {
    final now = DateTime.now();
    int yearDiff = now.year - birthDate.year;
    int monthDiff = now.month - birthDate.month;
    if (monthDiff < 0) {
      yearDiff--;
      monthDiff += 12;
    }
    return yearDiff * 12 + monthDiff;
  }
  
  Future<void> _logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal logout: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
      // [MODIFIKASI 4]: Menggunakan FutureBuilder untuk menampilkan data.
      // Widget ini akan "membangun" UI berdasarkan status dari _anakFuture.
      body: FutureBuilder<List<Anak>>(
        future: _anakFuture,
        builder: (context, snapshot) {
          // 1. Saat data sedang dimuat
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. Jika terjadi error saat memuat data
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi error: ${snapshot.error}'));
          }
          // 3. Jika data berhasil dimuat
          if (snapshot.hasData) {
            final dataAnak = snapshot.data!;
            // Jika tidak ada data di database
            if (dataAnak.isEmpty) {
              return const Center(child: Text('Belum ada data anak.'));
            }
            // Jika ada data, tampilkan dalam ListView
            return ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: dataAnak.length,
              itemBuilder: (context, index) {
                final anak = dataAnak[index];
                return _buildAnakCard(anak);
              },
            );
          }
          // State default (seharusnya tidak pernah terjadi)
          return const Center(child: Text('Memulai...'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur Tambah Data Anak')),
          );
        },
        tooltip: 'Tambah Data Anak',
        child: const Icon(Icons.add),
      ),
    );
  }

  // [MODIFIKASI 5]: Widget kartu disesuaikan dengan model data yang baru.
  Widget _buildAnakCard(Anak anak) {
    // Hitung umur dari tanggal lahir
    final umurBulan = _calculateAgeInMonths(anak.birth_date);
    // URL foto default jika data photo di Supabase kosong (null)
    final fotoUrl = anak.photo ?? 'https://i.pravatar.cc/150?u=${anak.id}';

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Melihat detail ${anak.name}')),
          );
        },
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(fotoUrl),
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          anak.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          '$umurBulan bulan',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoKolom(
                    context,
                    icon: Icons.monitor_weight_outlined,
                    label: 'Berat',
                    value: '${anak.birth_weight} kg',
                    color: Colors.blue,
                  ),
                  _buildInfoKolom(
                    context,
                    icon: Icons.height_outlined,
                    label: 'Tinggi',
                    value: '${anak.birth_height} cm',
                    color: Colors.green,
                  ),
                  _buildInfoKolom(
                    context,
                    icon: Icons.bloodtype_outlined, // Icon diubah
                    label: 'Gol. Darah', // Label diubah
                    value: anak.blood_type ?? '-', // Menampilkan '-' jika data null
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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