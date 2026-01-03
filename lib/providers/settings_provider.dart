import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const double defaultLevel = 2.0;

  ThemeMode _themeMode = ThemeMode.light;
  double _arabicLevel = defaultLevel;
  double _latinLevel = defaultLevel;

  // --- VIEW SETTINGS ---
  bool _isShowArabic = true;
  bool _isShowLatin = true;
  bool _isShowTranslation = true;

  // --- LANGUAGE SETTINGS (BARU) ---
  String _languageCode = 'id'; // Default 'id' (Indonesia)

  // --- KAMUS BAHASA (BARU) ---
  final Map<String, Map<String, String>> _localizedStrings = {
    'id': {
      // Navigasi & Judul
      'settings': 'Pengaturan',
      'quran': 'Al-Quran',
      'about': 'Tentang',
      'language': 'Bahasa',
      'choose_language': 'Pilih Bahasa',
      
      // Settings Item
      'dark_mode': 'Mode Gelap',
      'select_qori': 'Pilih Qori',
      'view_settings': 'Tampilan Ayat',
      'arabic_text': 'Teks Arab',
      'latin_text': 'Teks Latin',
      'translation': 'Terjemahan',
      'text_size': 'Ukuran Teks',
      'arabic_size': 'Ukuran Arab',
      'translation_size': 'Ukuran Terjemahan',
      'reset_default': 'Reset Default',
      'preview_voice': 'Preview Suara',
      
      // About
      'app_desc': 'Aplikasi Al-Quran digital yang didesain minimalis untuk kenyamanan membaca. Dilengkapi dengan audio dari berbagai Qori pilihan.',
      'version': 'Versi',
      
      // Error / Status
      'loading': 'Memuat...',
      'error_load': 'Gagal memuat data',
      'retry': 'Coba Lagi',
      'no_data': 'Data tidak tersedia',
      'tafsir_unavailable': 'Tafsir belum tersedia',
    },
    'en': {
      // Navigation & Title
      'settings': 'Settings',
      'quran': 'Al-Quran',
      'about': 'About',
      'language': 'Language',
      'choose_language': 'Choose Language',
      
      // Settings Item
      'dark_mode': 'Dark Mode',
      'select_qori': 'Select Reciter',
      'view_settings': 'Verse View',
      'arabic_text': 'Arabic Text',
      'latin_text': 'Latin Text',
      'translation': 'Translation',
      'text_size': 'Text Size',
      'arabic_size': 'Arabic Size',
      'translation_size': 'Translation Size',
      'reset_default': 'Reset Default',
      'preview_voice': 'Voice Preview',

      // About
      'app_desc': 'A digital Quran app designed for minimalist reading comfort. Equipped with audio from selected Reciters.',
      'version': 'Version',

      // Error / Status
      'loading': 'Loading...',
      'error_load': 'Failed to load data',
      'retry': 'Try Again',
      'no_data': 'Data not available',
      'tafsir_unavailable': 'Tafsir not available',
    },
  };

  // --- QORI SELECTION ---
  String _selectedQoriIdentifier = 'Misyari-Rasyid-Al-Afasi';

  final Map<String, String> availableQoris = {
    'Misyari Rasyid Al-Afasi': 'Misyari-Rasyid-Al-Afasi',
    'Abdullah Al-Juhany': 'Abdullah-Al-Juhany',
    'Abdul Muhsin Al-Qasim': 'Abdul-Muhsin-Al-Qasim',
    'Abdurrahman as-Sudais': 'Abdurrahman-as-Sudais',
    'Ibrahim Al-Dossari': 'Ibrahim-Al-Dossari', 
    'Yasser Al-Dosari': 'Yasser-Al-Dosari',     
  };

  // --- GETTERS ---
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  double get arabicLevel => _arabicLevel;
  double get latinLevel => _latinLevel;
  String get selectedQoriIdentifier => _selectedQoriIdentifier;
  
  bool get isShowArabic => _isShowArabic;
  bool get isShowLatin => _isShowLatin;
  bool get isShowTranslation => _isShowTranslation;
  
  // Getter Bahasa (BARU)
  String get languageCode => _languageCode;

  double get arabicFontSize => 16.0 + (_arabicLevel * 4.0);
  double get latinFontSize => 10.0 + (_latinLevel * 2.0);

  SettingsProvider() {
    _loadSettings();
  }

  // --- FUNGSI AMBIL TEKS (PENTING) ---
  String getText(String key) {
    // Ambil map bahasa yang aktif, kalau null default ke 'id'
    final dict = _localizedStrings[_languageCode] ?? _localizedStrings['id']!;
    // Ambil value berdasarkan key, kalau tidak ada kembalikan key-nya
    return dict[key] ?? key;
  }

  // --- SETTERS ---

  // Ganti Bahasa (BARU)
  void setLanguage(String code) async {
    if (code != 'id' && code != 'en') return;
    _languageCode = code;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', code);
  }

  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDark);
  }

  void toggleShowArabic(bool value) async {
    _isShowArabic = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_arabic', value);
  }

  void toggleShowLatin(bool value) async {
    _isShowLatin = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_latin', value);
  }

  void toggleShowTranslation(bool value) async {
    _isShowTranslation = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_translation', value);
  }

  void setArabicLevel(double level) async {
    _arabicLevel = level;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('arabic_level', level);
  }

  void setLatinLevel(double level) async {
    _latinLevel = level;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latin_level', level);
  }

  void setQori(String identifier) async {
    _selectedQoriIdentifier = identifier;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('qori_id', identifier);
  }

  void resetSettings() async {
    _arabicLevel = defaultLevel;
    _latinLevel = defaultLevel;
    _selectedQoriIdentifier = 'Misyari-Rasyid-Al-Afasi';
    _isShowArabic = true;
    _isShowLatin = true;
    _isShowTranslation = true;
    // Kita TIDAK mereset bahasa ke default, biarkan user tetap di bahasa pilihannya
    
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('arabic_level', defaultLevel);
    await prefs.setDouble('latin_level', defaultLevel);
    await prefs.setString('qori_id', 'Misyari-Rasyid-Al-Afasi');
    await prefs.setBool('show_arabic', true);
    await prefs.setBool('show_latin', true);
    await prefs.setBool('show_translation', true);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load Bahasa (BARU)
    _languageCode = prefs.getString('language_code') ?? 'id';

    final isDark = prefs.getBool('is_dark_mode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    
    _arabicLevel = prefs.getDouble('arabic_level') ?? defaultLevel;
    _latinLevel = prefs.getDouble('latin_level') ?? defaultLevel;
    _selectedQoriIdentifier = prefs.getString('qori_id') ?? 'Misyari-Rasyid-Al-Afasi';
    
    _isShowArabic = prefs.getBool('show_arabic') ?? true;
    _isShowLatin = prefs.getBool('show_latin') ?? true;
    _isShowTranslation = prefs.getBool('show_translation') ?? true;
    
    notifyListeners();
  }
}