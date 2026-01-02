import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/quran_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/about_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Default di Tengah (Quran)

  final List<Widget> _pages = [
    const SettingsScreen(), // 0
    const QuranScreen(),    // 1
    const AboutScreen(),    // 2
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan IndexedStack agar halaman tidak reload saat pindah
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      
      // Tombol Tengah Melayang (Al-Quran)
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(1),
        backgroundColor: const Color(0xFF1B5E20),
        elevation: 4,
        shape: const CircleBorder(), 
        child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      // Bottom Bar Melengkung
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), // Efek Coak
        notchMargin: 8.0,
        color: Theme.of(context).cardColor,
        elevation: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Kiri: Pengaturan
              _buildNavItem(
                icon: Icons.settings_outlined, 
                activeIcon: Icons.settings,
                label: "Pengaturan", 
                index: 0
              ),

              // Spacer Tengah
              const SizedBox(width: 48), 

              // Kanan: About
              _buildNavItem(
                icon: Icons.info_outline_rounded, 
                activeIcon: Icons.info_rounded,
                label: "Tentang", 
                index: 2
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required IconData activeIcon, required String label, required int index}) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? const Color(0xFF1B5E20) : Colors.grey,
              size: 26,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: isSelected ? const Color(0xFF1B5E20) : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
              ),
            )
          ],
        ),
      ),
    );
  }
}