import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const double defaultLevel = 2.0;

  ThemeMode _themeMode = ThemeMode.light;
  double _arabicLevel = defaultLevel;
  double _latinLevel = defaultLevel;

  // --- QORI SELECTION (BARU) ---
  String _selectedQoriIdentifier = 'Misyari-Rasyid-Al-Afasi'; 

  // Daftar Qori: Nama Tampil -> ID API
  final Map<String, String> availableQoris = {
    'Misyari Rasyid Al-Afasi': 'Misyari-Rasyid-Al-Afasi',
    'Abdullah Al-Juhany': 'Abdullah-Al-Juhany',
    'Abdul Muhsin Al-Qasim': 'Abdul-Muhsin-Al-Qasim',
    'Abdurrahman as-Sudais': 'Abdurrahman-as-Sudais',
  };

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  double get arabicLevel => _arabicLevel;
  double get latinLevel => _latinLevel;
  String get selectedQoriIdentifier => _selectedQoriIdentifier;

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

  // --- SET QORI ---
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
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('arabic_level', defaultLevel);
    await prefs.setDouble('latin_level', defaultLevel);
    await prefs.setString('qori_id', 'Misyari-Rasyid-Al-Afasi');
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('is_dark_mode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    
    _arabicLevel = prefs.getDouble('arabic_level') ?? defaultLevel;
    _latinLevel = prefs.getDouble('latin_level') ?? defaultLevel;
    _selectedQoriIdentifier = prefs.getString('qori_id') ?? 'Misyari-Rasyid-Al-Afasi';
    
    notifyListeners();
  }
}