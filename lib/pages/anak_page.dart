import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Anak {
  final int id;
  final String name;
  final DateTime birth_date;
  final String gender;
  final double birth_weight;
  final double birth_height;
  final String? blood_type;
  final String? photo;
  final String? nik;

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

  factory Anak.fromMap(Map<String, dynamic> map) {
    return Anak(
      id: map['id'],
      name: map['name'] as String,
      birth_date: DateTime.parse(map['birth_date'] as String),
      gender: map['gender'] as String,
      birth_weight: (map['birth_weight'] as num).toDouble(),
      birth_height: (map['birth_height'] as num).toDouble(),
      blood_type: map['blood_type'] as String?,
      photo: map['photo'] as String?,
      nik: map['nik'] as String?,
    );
  }
}

class AnakPage extends StatefulWidget {
  const AnakPage({super.key});

  @override
  State<AnakPage> createState() => _AnakPageState();
}

class _AnakPageState extends State<AnakPage> {
  late Future<List<Anak>> _anakFuture;

  @override
  void initState() {
    super.initState();
    _anakFuture = _getAnakData();
  }

  Future<List<Anak>> _getAnakData() async {
    final response = await Supabase.instance.client
        .from('children')
        .select()
        .order('created_at', ascending: false);

    final List<Anak> anakList = response.map((data) {
      return Anak.fromMap(data);
    }).toList();

    return anakList;
  }

  void _retryFetch() {
    setState(() {
      _anakFuture = _getAnakData();
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Anak>>(
      future: _anakFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Kondisi 1: Terjadi error saat mengambil data (misal: tidak ada internet)
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                const Text(
                  'Gagal Memuat Data',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Silakan periksa koneksi internet Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _retryFetch,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }
        
        // Kondisi 2: Data berhasil diambil
        if (snapshot.hasData) {
          final dataAnak = snapshot.data!;

          // Kondisi jika data berhasil diambil TAPI daftarnya kosong
          if (dataAnak.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Tidak Ada Data Anak',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Anda belum menambahkan data anak.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Kondisi jika data berhasil diambil dan ada isinya
          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: dataAnak.length,
            itemBuilder: (context, index) {
              final anak = dataAnak[index];
              return _buildAnakCard(anak);
            },
          );
        }
        
        return const Center(child: Text('Memulai...'));
      },
    );
  }

  Widget _buildAnakCard(Anak anak) {
    final umurBulan = _calculateAgeInMonths(anak.birth_date);
    final fotoUrl = anak.photo ?? 'https://i.pravatar.cc/150?u=${anak.id}';

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: () {},
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
                    icon: Icons.bloodtype_outlined,
                    label: 'Gol. Darah',
                    value: anak.blood_type ?? '-',
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