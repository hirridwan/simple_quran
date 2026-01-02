import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quran_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      
      // Custom Navigation Bar V3 (Revisi Stabil)
      bottomNavigationBar: Container(
        height: 80, 
        decoration: BoxDecoration(
          color: bgColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), 
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 1. Pengaturan
            _buildNavItem(
              index: 0,
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings,
              label: "Setting",
            ),

            // 2. Al-Quran (Tengah)
            _buildNavItem(
              index: 1,
              icon: Icons.menu_book_rounded,
              activeIcon: Icons.menu_book,
              label: "Al-Quran",
            ),

            // 3. Tentang
            _buildNavItem(
              index: 2,
              icon: Icons.info_outline_rounded,
              activeIcon: Icons.info_rounded,
              label: "About",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    bool isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      // Gunakan SizedBox dengan lebar tetap agar tidak goyang
      child: SizedBox(
        width: 80, // Lebar tetap untuk setiap item menu
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container Animasi (Kapsul)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              // Padding tetap agar ukuran container ikon konsisten
              width: 60, 
              height: 32,
              decoration: BoxDecoration(
                // Warna Hijau Muda saat aktif, transparan saat tidak
                color: isSelected ? const Color(0xFFE8F5E9) : Colors.transparent,
                borderRadius: BorderRadius.circular(20), // Bentuk Kapsul
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                // Warna Hijau Tua saat aktif, Abu-abu saat mati
                color: isSelected ? const Color(0xFF1B5E20) : Colors.grey,
                size: 24,
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Teks Label
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF1B5E20) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}