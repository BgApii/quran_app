import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:quran/app/data/models/meta.dart';
import 'package:quran/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  Surahs? allSurahs; // Menyimpan semua data Surah
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Object?>> getData() async {
    CollectionReference bookmarks = firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('bookmarks');
    return bookmarks.get();
  }

  Stream<QuerySnapshot<Object?>> getDataStream() {
    CollectionReference bookmarks = firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('bookmarks');
    return bookmarks
        // .where('last_read', isEqualTo: 0)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLastReadStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('bookmarks')
        .where('last_read', isEqualTo: 1)
        .snapshots();
  }

  void deleteLastread() async {
    final bookmarks = firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('bookmarks');

    final snapshot = await bookmarks.where('last_read', isEqualTo: 1).get();

    for (var doc in snapshot.docs) {
      await bookmarks.doc(doc.id).delete();
    }
  }

  void deleteBookmark(String id) async {
    DocumentReference bookmarks = firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('bookmarks')
        .doc(id);
    await bookmarks.delete();
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(Routes.LOGIN); // kembali ke login screen
  }

  // Di HomeController
  Future<void> navigateToBookmark(Map<String, dynamic> bookmark) async {
    try {
      // Navigasi ke Surah
      final allSurahs = await getAllSurah();
      if (allSurahs != null) {
        final surah = allSurahs.references?.firstWhere(
          (s) => s.englishName == bookmark['surah'],
          orElse: () => References(number: 1),
        );

        if (surah != null) {
          int ayahNumber = int.tryParse(bookmark['ayah'].toString()) ?? 1;
          Get.toNamed(
            Routes.DETAIL_SURAH,
            arguments: surah,
            parameters: {'ayah': ayahNumber.toString()},
          );
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal membuka bookmark: $e");
    }
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
