import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const double defaultLevel = 2.0;

  ThemeMode _themeMode = ThemeMode.light;
  double _arabicLevel = defaultLevel;
  double _latinLevel = defaultLevel;

  // --- VIEW SETTINGS (BARU: FITUR TOGGLE) ---
  bool _isShowArabic = true;
  bool _isShowLatin = true;
  bool _isShowTranslation = true;

  // --- QORI SELECTION ---
  String _selectedQoriIdentifier = 'Misyari-Rasyid-Al-Afasi';

  // UPDATED: Daftar Lengkap 6 Qori sesuai gambar CDN
  final Map<String, String> availableQoris = {
    'Misyari Rasyid Al-Afasi': 'Misyari-Rasyid-Al-Afasi',
    'Abdullah Al-Juhany': 'Abdullah-Al-Juhany',
    'Abdul Muhsin Al-Qasim': 'Abdul-Muhsin-Al-Qasim',
    'Abdurrahman as-Sudais': 'Abdurrahman-as-Sudais',
    'Ibrahim Al-Dossari': 'Ibrahim-Al-Dossari', // Baru
    'Yasser Al-Dosari': 'Yasser-Al-Dosari',     // Baru
  };

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  double get arabicLevel => _arabicLevel;
  double get latinLevel => _latinLevel;
  String get selectedQoriIdentifier => _selectedQoriIdentifier;
  
  // Getters untuk Toggle View
  bool get isShowArabic => _isShowArabic;
  bool get isShowLatin => _isShowLatin;
  bool get isShowTranslation => _isShowTranslation;

  double get arabicFontSize => 16.0 + (_arabicLevel * 4.0);
  double get latinFontSize => 10.0 + (_latinLevel * 2.0);

  SettingsProvider() {
    _loadSettings();
  }

  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDark);
  }

  // --- FUNGSI TOGGLE VIEW (BARU) ---
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
    
    // Reset Toggles ke Default (True)
    _isShowArabic = true;
    _isShowLatin = true;
    _isShowTranslation = true;

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
    final isDark = prefs.getBool('is_dark_mode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    
    _arabicLevel = prefs.getDouble('arabic_level') ?? defaultLevel;
    _latinLevel = prefs.getDouble('latin_level') ?? defaultLevel;
    _selectedQoriIdentifier = prefs.getString('qori_id') ?? 'Misyari-Rasyid-Al-Afasi';
    
    // Load Toggles
    _isShowArabic = prefs.getBool('show_arabic') ?? true;
    _isShowLatin = prefs.getBool('show_latin') ?? true;
    _isShowTranslation = prefs.getBool('show_translation') ?? true;
    
    notifyListeners();
  }
}