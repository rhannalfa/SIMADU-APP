import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard_page.dart';
import 'anak_page.dart';
import 'jadwal_page.dart';

final supabase = Supabase.instance.client;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // Daftar judul dan subjudul untuk AppBar
  final List<String> _appBarTitles = [
    'SIMADU',
    'Data Anak',
    'Jadwal Posyandu',
  ];

  final List<String> _appBarSubtitles = [
    'Sistem Informasi Posyandu Terpadu',
    'Pantau perkembangan si kecil',
    'Pantau kegiatan posyandu',
  ];

  final List<Widget> _pages = [
    const DashboardPage(),
    const AnakPage(),
    const JadwalPage(),
  ];

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B82F6),
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              _appBarTitles[_selectedIndex], 
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            Text(
              _appBarSubtitles[_selectedIndex], 
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF3B82F6),
        unselectedItemColor: Colors.grey[500],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dasbor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.child_care_rounded),
            label: 'Anak',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule_rounded),
            label: 'Jadwal',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}