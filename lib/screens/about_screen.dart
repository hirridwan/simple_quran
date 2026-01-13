import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../providers/settings_provider.dart'; // Import Settings Provider

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Panggil Provider
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 80, 
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        title: Text(
          settings.getText('about'), // TEXT DINAMIS
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.menu_book_rounded, size: 80, color: Color(0xFF1B5E20)),
              const SizedBox(height: 20),
              Text(
                "Simple Quran",
                style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF1B5E20)),
              ),
              const SizedBox(height: 5),
              Text(
                "${settings.getText('version')} 1.3.0", // TEXT DINAMIS "Versi"
                style: GoogleFonts.inter(color: Colors.grey)
              ),
              const SizedBox(height: 30),
              Text(
                settings.getText('app_desc'), // TEXT DINAMIS DESKRIPSI
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}