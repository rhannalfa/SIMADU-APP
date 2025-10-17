import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 1. Impor package
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Muat file .env
  await dotenv.load(fileName: ".env");

  // 3. Gunakan variabel dari dotenv untuk inisialisasi Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!, // Gunakan variabel
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!, // Gunakan variabel
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Aplikasi Posyandu',
      home: AuthGate(),
    );
  }
}