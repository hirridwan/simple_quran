import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDark = settings.isDarkMode;
    final cardColor = isDark ? Theme.of(context).cardColor : Colors.white;
    
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: isDark ? Colors.transparent : Colors.grey.shade200,
        width: 1,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          
          // --- 1. TEMA (DIPERBAIKI UKURANNYA) ---
          Card(
            elevation: 0,
            color: cardColor,
            shape: cardShape,
            // Hapus ListTile, ganti dengan Padding & Row manual
            // agar ukurannya Compact sama seperti Dropdown
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
              child: Row(
                children: [
                  // Icon Kotak
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: const Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Text Judul
                  const Text(
                    "Mode Gelap", 
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)
                  ),
                  
                  const Spacer(),
                  
                  // Switch
                  Switch(
                    value: settings.isDarkMode,
                    activeTrackColor: const Color(0xFF1B5E20).withOpacity(0.5),
                    activeThumbColor: const Color(0xFF1B5E20),
                    onChanged: (value) => settings.toggleTheme(value),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),

          // --- 2. QORI SELECTION ---
          Text("Audio Qori", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          
          Card(
            elevation: 0,
            color: cardColor,
            shape: cardShape,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: settings.selectedQoriIdentifier,
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1B5E20)),
                  items: settings.availableQoris.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.value,
                      child: Text(entry.key, style: GoogleFonts.inter()),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) settings.setQori(newValue);
                  },
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          Text("Ukuran Teks", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),

          // --- 3. FONT ARAB ---
          Card(
            elevation: 0, color: cardColor, shape: cardShape,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Arab", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Level ${settings.arabicLevel.round()}", style: const TextStyle(color: Color(0xFF1B5E20), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: settings.arabicLevel,
                    min: 1.0, max: 10.0, divisions: 9,
                    activeColor: const Color(0xFF1B5E20),
                    onChanged: (val) => settings.setArabicLevel(val),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ",
                      style: GoogleFonts.amiri(fontSize: settings.arabicFontSize, height: 2.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 10),

          // --- 4. FONT LATIN ---
          Card(
            elevation: 0, color: cardColor, shape: cardShape,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Terjemahan", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Level ${settings.latinLevel.round()}", style: const TextStyle(color: Color(0xFF1B5E20), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: settings.latinLevel,
                    min: 1.0, max: 10.0, divisions: 9,
                    activeColor: const Color(0xFF1B5E20),
                    onChanged: (val) => settings.setLatinLevel(val),
                  ),
                   Text(
                    "Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang.",
                    style: GoogleFonts.inter(fontSize: settings.latinFontSize),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          Center(
             child: TextButton.icon(
               onPressed: () => settings.resetSettings(),
               icon: const Icon(Icons.refresh, color: Colors.red),
               label: const Text("Reset Default", style: TextStyle(color: Colors.red)),
             ),
          )
        ],
      ),
    );
  }
}