import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class ApiService {
  static const String baseUrlQuran = 'https://equran.id/api/v2';

  // --- 1. GET DAFTAR SURAH ---
  Future<List<Surah>> getDaftarSurah() async {
    const String cacheKey = 'cache_daftar_surah';
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(cacheKey)) {
      final String? cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        final Map<String, dynamic> json = jsonDecode(cachedData);
        final List<dynamic> data = json['data'];
        return data.map((e) => Surah.fromJson(e)).toList();
      }
    }

    try {
      final response = await http.get(Uri.parse('$baseUrlQuran/surat'));
      if (response.statusCode == 200) {
        await prefs.setString(cacheKey, response.body);
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> data = json['data'];
        return data.map((e) => Surah.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat daftar surat');
      }
    } catch (e) {
      throw Exception('Error koneksi: $e');
    }
  }

  // --- 2. GET DETAIL SURAH ---
  Future<List<Ayat>> getDetailSurah(int nomor) async {
    final String cacheKey = 'cache_detail_surah_$nomor';
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(cacheKey)) {
      final String? cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        final Map<String, dynamic> json = jsonDecode(cachedData);
        final List<dynamic> ayatData = json['data']['ayat'];
        return ayatData.map((e) => Ayat.fromJson(e)).toList();
      }
    }

    try {
      final response = await http.get(Uri.parse('$baseUrlQuran/surat/$nomor'));
      if (response.statusCode == 200) {
        await prefs.setString(cacheKey, response.body);
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> ayatData = json['data']['ayat'];
        return ayatData.map((e) => Ayat.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat detail surat');
      }
    } catch (e) {
      throw Exception('Error koneksi: $e');
    }
  }

  // --- 3. GET TAFSIR SURAH ---
  Future<List<Tafsir>> getTafsirSurah(int nomor) async {
    final String cacheKey = 'cache_tafsir_surah_$nomor';
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(cacheKey)) {
      final String? cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        final Map<String, dynamic> json = jsonDecode(cachedData);
        final List<dynamic> tafsirData = json['data']['tafsir'];
        return tafsirData.map((e) => Tafsir.fromJson(e)).toList();
      }
    }

    try {
      final response = await http.get(Uri.parse('$baseUrlQuran/tafsir/$nomor'));
      if (response.statusCode == 200) {
        await prefs.setString(cacheKey, response.body);
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> tafsirData = json['data']['tafsir'];
        return tafsirData.map((e) => Tafsir.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat tafsir');
      }
    } catch (e) {
      throw Exception('Error koneksi: $e');
    }
  }
}