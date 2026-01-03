import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
// import 'package:flutter/foundation.dart'; // Tidak perlu jika pakai print biasa

class ApiService {
  static const String baseUrlQuran = 'https://equran.id/api/v2';
  // API Cadangan untuk Bahasa Inggris (Saheeh International)
  static const String baseUrlEnglish = 'https://api.alquran.cloud/v1/surah';

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

  // --- 2. GET DETAIL SURAH (MODIFIED FOR MULTI-LANG) ---
  Future<List<Ayat>> getDetailSurah(int nomor, {String languageCode = 'id'}) async {
    // Bedakan Cache Key berdasarkan bahasa
    final String cacheKey = 'cache_detail_surah_${nomor}_$languageCode';
    final prefs = await SharedPreferences.getInstance();

    // 1. Cek Cache
    if (prefs.containsKey(cacheKey)) {
      final String? cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        final List<dynamic> jsonList = jsonDecode(cachedData); 
        return jsonList.map((e) => Ayat.fromJson(e)).toList();
      }
    }

    try {
      // 2. Ambil Data UTAMA (Indo/Arab/Latin/Audio) dari equran.id
      final responseIndo = await http.get(Uri.parse('$baseUrlQuran/surat/$nomor'));

      if (responseIndo.statusCode != 200) {
        throw Exception('Gagal memuat surat');
      }

      final Map<String, dynamic> jsonIndo = jsonDecode(responseIndo.body);
      List<dynamic> listAyatRaw = jsonIndo['data']['ayat'];

      // 3. LOGIKA BAHASA INGGRIS
      if (languageCode == 'en') {
        try {
          // Ambil data terjemahan Inggris dari API Internasional
          final responseEnglish = await http.get(
            Uri.parse('$baseUrlEnglish/$nomor/en.sahih')
          );

          if (responseEnglish.statusCode == 200) {
            final Map<String, dynamic> jsonEn = jsonDecode(responseEnglish.body);
            final List<dynamic> listAyatEn = jsonEn['data']['ayahs'];

            // 4. MERGE / GABUNGKAN DATA
            for (int i = 0; i < listAyatRaw.length; i++) {
              if (i < listAyatEn.length) {
                // Timpa teksIndonesia dengan teks Inggris
                listAyatRaw[i]['teksIndonesia'] = listAyatEn[i]['text'];
              }
            }
          }
        } catch (e) {
          // Gunakan print biasa agar tidak perlu import flutter/foundation
          print("Gagal mengambil bahasa Inggris, fallback ke Indo: $e");
        }
      }

      // 5. Simpan ke Cache
      await prefs.setString(cacheKey, jsonEncode(listAyatRaw));

      return listAyatRaw.map((e) => Ayat.fromJson(e)).toList();

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