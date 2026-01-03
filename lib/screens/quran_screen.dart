import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; 
import '../providers/settings_provider.dart'; 
import '../services/api_service.dart';
import '../models/models.dart';
import '../services/bookmark_service.dart';
import '../models/surah_translation.dart'; // Import Kamus
import 'detail_surah_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final ApiService api = ApiService();
  final BookmarkService bookmarkService = BookmarkService();
  
  List<Surah> _allSurah = [];
  List<Surah> _filteredSurah = [];
  Map<String, dynamic>? _lastRead;
  
  bool _isLoading = true;
  bool _isError = false;
  
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (_allSurah.isEmpty) {
      setState(() {
        _isLoading = true;
        _isError = false;
      });
    }

    try {
      final results = await Future.wait([
        api.getDaftarSurah(),
        bookmarkService.getLastRead(),
      ]);

      if (mounted) {
        setState(() {
          _allSurah = results[0] as List<Surah>;
          if (_searchController.text.isEmpty) {
            _filteredSurah = _allSurah;
          }
          _lastRead = results[1] as Map<String, dynamic>?;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isError = true;
        });
      }
    }
  }

  void _refreshLastRead() async {
    final lastRead = await bookmarkService.getLastRead();
    if (mounted) {
      setState(() {
        _lastRead = lastRead;
      });
    }
  }

  void _filterSurah(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredSurah = _allSurah;
      });
    } else {
      final lowerQuery = query.toLowerCase();
      final filtered = _allSurah.where((surah) {
        return surah.namaLatin.toLowerCase().contains(lowerQuery) || 
               surah.arti.toLowerCase().contains(lowerQuery) ||
               surah.nomor.toString().contains(lowerQuery);
      }).toList();

      setState(() {
        _filteredSurah = filtered;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isEnglish = settings.languageCode == 'en';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Al-Quran'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1B5E20), 
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80, 
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80), 
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
            child: TextField(
              controller: _searchController,
              onChanged: _filterSurah,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: isEnglish 
                    ? "Search Surah (ex: Yasin, 36)..." 
                    : "Cari Surat (ex: Yasin, 36)...",
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1B5E20)),
                suffixIcon: _searchController.text.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        _filterSurah('');
                        FocusScope.of(context).unfocus();
                      },
                    )
                  : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),
        ),
      ),
      
      body: _buildBody(settings, isEnglish),
    );
  }

  Widget _buildBody(SettingsProvider settings, bool isEnglish) {
    if (_isLoading && _allSurah.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF1B5E20)));
    }

    if (_isError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.wifi_off_rounded, size: 50, color: Colors.red.shade400),
              ),
              const SizedBox(height: 24),
              Text(
                isEnglish ? "Connection Required" : "Koneksi Diperlukan",
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Text(
                isEnglish 
                  ? "The app needs to download Quran data once. Please enable internet and try again."
                  : "Aplikasi perlu mengunduh data Al-Qur'an sekali saja di awal. Mohon aktifkan internet Anda, lalu coba lagi.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _loadData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: Text(
                    isEnglish ? "Try Again" : "Coba Lagi", 
                    style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    if (_filteredSurah.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 10),
            Text(
              isEnglish ? "Surah not found" : "Surat tidak ditemukan", 
              style: TextStyle(color: Colors.grey.shade600)
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFF1B5E20),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        itemCount: (_lastRead != null && _searchController.text.isEmpty) 
            ? _filteredSurah.length + 1 
            : _filteredSurah.length,
        itemBuilder: (context, index) {
          if (_lastRead != null && _searchController.text.isEmpty) {
            if (index == 0) {
              return _buildLastReadWidget(isEnglish);
            }
            return _buildSurahItem(_filteredSurah[index - 1], settings, isEnglish);
          }
          return _buildSurahItem(_filteredSurah[index], settings, isEnglish);
        },
      ),
    );
  }

  Widget _buildLastReadWidget(bool isEnglish) {
    return InkWell(
      onTap: () async {
        try {
          final targetSurah = _allSurah.firstWhere(
            (s) => s.nomor == _lastRead!['surah'],
          );
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailSurahScreen(
                surah: targetSurah,
                initialAyat: _lastRead!['ayat'], 
              ),
            ),
          );
          _refreshLastRead();
        } catch (e) {
          // Handle error
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFE65100), Colors.orange.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bookmark, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEnglish ? "Last Read" : "Terakhir Dibaca",
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${_lastRead!['nama']}",
                    style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    isEnglish 
                      ? "Ayah ${_lastRead!['ayat']}" 
                      : "Ayat ${_lastRead!['ayat']}",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahItem(Surah surah, SettingsProvider settings, bool isEnglish) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 0,
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailSurahScreen(surah: surah),
              ),
            );
            _refreshLastRead();
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Nomor Surat
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${surah.nomor}',
                    style: const TextStyle(color: Color(0xFF1B5E20), fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                const SizedBox(width: 16),
                
                // --- INFO UTAMA (Nama Latin & Meta) ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Latin
                      if (settings.isShowLatin)
                        Text(
                          surah.namaLatin,
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                      
                      const SizedBox(height: 4),
                      
                      // Info Tempat & Jumlah Ayat
                      Row(
                        children: [
                          Text(surah.tempatTurun, style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w500)),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: 4, height: 4,
                            decoration: BoxDecoration(color: Colors.grey[400], shape: BoxShape.circle),
                          ),
                          Text(
                            isEnglish 
                              ? "${surah.jumlahAyat} Ayahs" 
                              : "${surah.jumlahAyat} Ayat", 
                            style: TextStyle(color: Colors.grey[600], fontSize: 12)
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // --- INFO ARAB (Nama Surat) ---
                if (settings.isShowArabic)
                  Text(
                    surah.nama,
                    style: GoogleFonts.amiri(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1B5E20)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}