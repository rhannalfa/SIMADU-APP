import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'anak_modal.dart'; // Import the new modal file


// NOTE: The Anak class remains exactly the same
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
      nik: map.containsKey('nik') ? map['nik'] as String? : null,
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

  // --- MODAL FUNCTION (SIMPLIFIED) ---
  void _showGrowthChartModal(Anak anak) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      // Now, we simply return the new GrowthChartModal widget
      builder: (context) {
        return GrowthChartModal(anak: anak);
      },
    );
  }
  // --- END OF MODAL FUNCTION ---

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Anak>>(
      future: _anakFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error and Empty data conditions remain the same...
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

        if (snapshot.hasData) {
          final dataAnak = snapshot.data!;

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

          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: dataAnak.length,
            itemBuilder: (context, index) {
              final anak = dataAnak[index];
              return _buildAnakCardListStyle(anak);
            },
          );
        }
        
        return const Center(child: Text('Memulai...'));
      },
    );
  }

  // Utility widget to build a full-width data row
  Widget _buildInfoRow(BuildContext context, {
    required String label,
    required String value,
    Color? labelColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: labelColor ?? Colors.black87,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  // Card implementation with the new button
  Widget _buildAnakCardListStyle(Anak anak) {
    final umurBulan = _calculateAgeInMonths(anak.birth_date);
    final fotoUrl = anak.photo ?? 'https://i.pravatar.cc/150?u=${anak.id}';
    final cardBackgroundColor = Colors.white;

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: cardBackgroundColor,
      child: InkWell(
        onTap: () {
          // You can also use this to open the modal if you prefer the whole card to be clickable
          // _showGrowthChartModal(anak);
        },
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Profile, Name, Age, and Status Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(fotoUrl),
                    backgroundColor: Colors.blue.shade100,
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
                                fontSize: 18,
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
                  // Gizi Baik Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'Gizi Baik',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12.0),
              
              // 2. Data Rows (Berat, Tinggi, Gol. Darah)
              _buildInfoRow(
                context,
                label: 'Berat Badan',
                value: '${anak.birth_weight} kg',
              ),
              SizedBox(
                height: 1,
                child: Divider(color: Colors.grey.shade300, indent: 8, endIndent: 8),
              ),
              _buildInfoRow(
                context,
                label: 'Tinggi Badan',
                value: '${anak.birth_height} cm',
              ),
              SizedBox(
                height: 1,
                child: Divider(color: Colors.grey.shade300, indent: 8, endIndent: 8),
              ),
              // Replaced 'Orang Tua' with 'Golongan Darah'
              _buildInfoRow(
                context,
                label: 'Golongan Darah',
                value: anak.blood_type?.toUpperCase() ?? '-',
              ),
              
              const SizedBox(height: 12.0),
              
              // 3. Button to open the Modal
              OutlinedButton.icon(
                onPressed: () => _showGrowthChartModal(anak), // CALLS THE NEW MODAL FUNCTION
                icon: const Icon(Icons.show_chart, size: 20),
                label: const Text('Lihat Grafik Pertumbuhan'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                  side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
