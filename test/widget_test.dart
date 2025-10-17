// test/widget_test.dart

import 'package:SIMADU/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Ganti 'simadu' dengan nama proyekmu yang sebenarnya
import 'package:SIMADU/login_page.dart';

void main() {
  // Nama grup test, mendeskripsikan apa yang diuji
  group('Auth Flow Widget Tests', () {

    // Test case #1: Memverifikasi halaman login ditampilkan dengan benar
    testWidgets('Login page shows email, password fields and a login button', (WidgetTester tester) async {
      // 1. Bangun aplikasi kita. Karena kita menggunakan Supabase,
      //    kita perlu memastikan inisialisasinya dipanggil.
      //    Untuk testing, kita bisa langsung memanggil LoginPage jika AuthGate
      //    membutuhkan setup Supabase yang lebih kompleks.
      await tester.pumpWidget(const MyApp()); // MyApp akan menampilkan AuthGate -> LoginPage

      // Tunggu widget selesai di-render
      await tester.pumpAndSettle();

      // 2. Verifikasi bahwa widget-widget penting ada di layar
      
      // Cari TextFormField dengan teks label 'Email'
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      
      // Cari TextFormField dengan teks label 'Password'
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      
      // Cari tombol dengan teks 'Login'
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

      // Cari tombol teks dengan teks 'Belum punya akun? Register'
      expect(find.widgetWithText(TextButton, 'Belum punya akun? Register'), findsOneWidget);

      // Pastikan tidak ada teks 'Dashboard' (karena kita belum login)
      expect(find.text('Dashboard'), findsNothing);
    });

  });
}