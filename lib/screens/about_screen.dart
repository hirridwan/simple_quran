import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tentang"),
        centerTitle: true,
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
              Text("Versi 1.1.0", style: GoogleFonts.inter(color: Colors.grey)),
              const SizedBox(height: 30),
              Text(
                "Aplikasi Al-Quran digital yang didesain minimalis untuk kenyamanan membaca. Dilengkapi dengan audio dari berbagai Qori pilihan.",
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