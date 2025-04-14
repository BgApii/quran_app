import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quran/app/data/db/bookmark.dart';
import 'package:quran/app/data/models/meta.dart';
import 'package:sqflite/sqflite.dart';

class HomeController extends GetxController {
  Surahs? allSurahs; // Menyimpan semua data Surah
  DatabaseManager database = DatabaseManager.instance;


  void deleteBookmark(int id) async {
    Database db = await database.db;
    db.delete("bookmarks", where: "id = $id");
    update();
    Get.snackbar("Berhasil", "Telah berhasil Menghapus Bookmark");
  }

  Future<Map<String, dynamic>?> getLastRead() async {
    // Mengambil data bookmark dari database
    Database db = await database.db;
    List<Map<String, dynamic>> dataLastRead = await db.query(
      "bookmarks",
      where: "last_read = ?",
      whereArgs: [1],
    );
    if (dataLastRead.isEmpty) {
      return null;
    } else {
      return dataLastRead.first;
    }
  }

  Future<List<Map<String, dynamic>>> getBookmark() async {
    // Mengambil data bookmark dari database
    Database db = await database.db;
    List<Map<String, dynamic>> allBookmarks = await db.query(
      "bookmarks",
      where: "last_read = ?",
      whereArgs: [0],
    );
    return allBookmarks;
  }

  Future<void> fetchAllSurah() async {
    allSurahs = await getAllSurah();
    update(); // Memperbarui UI setelah data diambil
  }

  String getSurahName(int surahNumber) {
    // Mencari nama Surah berdasarkan nomor
    return allSurahs?.references
            ?.firstWhere(
              (surah) => surah.number == surahNumber,
              orElse: () => References(englishName: "Unknown"),
            )
            .englishName ??
        "Unknown";
  }

  Future<Surahs?> getAllSurah() async {
    Uri url = Uri.parse("https://api.alquran.cloud/v1/meta");
    var res = await http.get(url);

    if (res.statusCode == 200) {
      var data = json.decode(res.body) as Map<String, dynamic>;
      if (data["data"] != null) {
        return Meta.fromJson(data["data"]).surahs;
      }
    }
    return null; // Return null if the request fails or data is not available
  }

  Future<Juzs?> getAllJuz() async {
    Uri url = Uri.parse("https://api.alquran.cloud/v1/meta");
    var res = await http.get(url);

    if (res.statusCode == 200) {
      var data = json.decode(res.body) as Map<String, dynamic>;
      if (data["data"] != null) {
        return Meta.fromJson(data["data"]).juzs;
      }
    }
    return null; // Return null if the request fails or data is not available
  }
}
