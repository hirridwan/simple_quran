import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart'; 
import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AudioPlayer _previewPlayer = AudioPlayer();
  bool _isPlayingPreview = false;
  bool _isLoadingPreview = false;

  @override
  void dispose() {
    _previewPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPreview(String qoriId) async {
    final url = "https://cdn.equran.id/audio-full/$qoriId/001.mp3";
    try {
      if (_isPlayingPreview) {
        await _previewPlayer.stop();
        setState(() => _isPlayingPreview = false);
      } else {
        setState(() {
          _isLoadingPreview = true;
        });
        await _previewPlayer.setUrl(url);
        setState(() {
          _isLoadingPreview = false;
          _isPlayingPreview = true;
        });
        await _previewPlayer.play();
        setState(() => _isPlayingPreview = false);
      }
    } catch (e) {
      setState(() {
        _isLoadingPreview = false;
        _isPlayingPreview = false;
      });
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("Gagal memutar preview: $e")),
        );
      }
    }
  }

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
        elevation: 0,
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 80, 
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        title: Text(
          settings.getText('settings'),
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          
          // --- 1. PENGATURAN APLIKASI ---
          Text(
            settings.languageCode == 'id' ? "Pengaturan Aplikasi" : "App Settings", 
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)
          ),
          const SizedBox(height: 8),
          
          Card(
            elevation: 0,
            color: cardColor,
            shape: cardShape,
            child: Column(
              children: [
                // Toggle Bahasa
                _buildToggleItem(
                  settings.languageCode == 'en' ? 'English' : 'Bahasa Indonesia', 
                  settings.languageCode == 'en', 
                  (val) {
                    settings.setLanguage(val ? 'en' : 'id');
                  }
                ),

                Divider(height: 1, color: Colors.grey.withOpacity(0.1)),

                // Toggle Mode Gelap
                _buildToggleItem(
                  settings.getText('dark_mode'), 
                  settings.isDarkMode, 
                  (val) => settings.toggleTheme(val)
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),

          // --- 2. QORI SELECTION (UKURAN PAS) ---
          Text(settings.getText('select_qori'), style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          
          Card(
            elevation: 0,
            color: cardColor,
            shape: cardShape,
            child: Padding(
              // REVISI: Padding 8 (Jalan tengah yang pas)
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isDense: true, // Tetap compact tapi tidak gepeng
                        isExpanded: true,
                        value: settings.selectedQoriIdentifier,
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1B5E20)),
                        items: settings.availableQoris.entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.value,
                            child: Text(
                              entry.key, 
                              style: GoogleFonts.inter(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            _previewPlayer.stop(); 
                            setState(() => _isPlayingPreview = false);
                            settings.setQori(newValue);
                          }
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 10),
                  Container(width: 1, height: 24, color: Colors.grey.shade300),
                  const SizedBox(width: 5), 
                  
                  IconButton(
                    // Hapus visualDensity compact agar area sentuh normal
                    onPressed: () => _playPreview(settings.selectedQoriIdentifier),
                    icon: _isLoadingPreview 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Icon(
                          _isPlayingPreview ? Icons.stop_circle : Icons.play_circle_fill,
                          color: const Color(0xFF1B5E20),
                          size: 30, // Ukuran pas 30
                        ),
                    tooltip: settings.getText('preview_voice'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          
          // --- 3. TAMPILAN AYAT ---
          Text(settings.getText('view_settings'), style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Card(
            elevation: 0, color: cardColor, shape: cardShape,
            child: Column(
              children: [
                _buildToggleItem(settings.getText('arabic_text'), settings.isShowArabic, (val) => settings.toggleShowArabic(val)),
                Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
                _buildToggleItem(settings.getText('latin_text'), settings.isShowLatin, (val) => settings.toggleShowLatin(val)),
                Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
                _buildToggleItem(settings.getText('translation'), settings.isShowTranslation, (val) => settings.toggleShowTranslation(val)),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          Text(settings.getText('text_size'), style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),

          // --- 4. SLIDER UKURAN ---
          Card(
            elevation: 0, color: cardColor, shape: cardShape,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(settings.getText('arabic_size'), style: const TextStyle(fontWeight: FontWeight.bold)),
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

          Card(
            elevation: 0, color: cardColor, shape: cardShape,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(settings.getText('translation_size'), style: const TextStyle(fontWeight: FontWeight.bold)),
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
                onPressed: () {
                  _previewPlayer.stop(); 
                  settings.resetSettings();
                },
                icon: const Icon(Icons.refresh, color: Colors.red),
                label: Text(settings.getText('reset_default'), style: const TextStyle(color: Colors.red)),
              ),
          )
        ],
      ),
    );
  }

  Widget _buildToggleItem(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
          Switch(
            value: value,
            activeTrackColor: const Color(0xFF1B5E20).withOpacity(0.5),
            activeThumbColor: const Color(0xFF1B5E20),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}