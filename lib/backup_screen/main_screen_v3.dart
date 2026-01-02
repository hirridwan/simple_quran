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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Warna untuk Active State
    const activeColor = Color(0xFF1B5E20);
    final inactiveColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      
      // --- BAGIAN UTAMA (HIGHLIGHT QURAN) ---
      // Tombol Tengah Besar (FAB)
      floatingActionButton: SizedBox(
        width: 70, // Ukuran Besar
        height: 70,
        child: FloatingActionButton(
          onPressed: () => _onItemTapped(1), // Ke Quran
          backgroundColor: activeColor, // Warna Hijau Tegas
          elevation: 4, // Sedikit bayangan biar muncul
          shape: const CircleBorder(), // Bulat Sempurna
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu_book_rounded, size: 30, color: Colors.white),
              // Opsional: Teks kecil di dalam tombol
              // Text("Quran", style: TextStyle(fontSize: 8, color: Colors.white)) 
            ],
          ),
        ),
      ),
      // Posisi 'ditanam' di tengah bar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // --- NAVIGASI BAWAH (GROUNDED) ---
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), // Coak setengah lingkaran untuk tombol
        notchMargin: 8.0, // Jarak antara tombol dan coakan
        color: bgColor,
        elevation: 10,
        height: 70, // Tinggi bar
        padding: EdgeInsets.zero, // Hapus padding default
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Bagi dua sisi (Kiri & Kanan)
          children: [
            // SISI KIRI (Setting)
            _buildNavItem(
              index: 0,
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings,
              label: "Pengaturan",
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),

            // SPACER TENGAH (Supaya tombol tidak ketutup)
            const SizedBox(width: 60), 

            // SISI KANAN (About)
            _buildNavItem(
              index: 2,
              icon: Icons.info_outline_rounded,
              activeIcon: Icons.info,
              label: "Tentang",
              activeColor: activeColor,
              inactiveColor: inactiveColor,
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
    required Color activeColor,
    required Color? inactiveColor,
  }) {
    bool isSelected = _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}