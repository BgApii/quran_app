import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:quran/app/data/db/bookmark.dart';
import 'package:quran/app/modules/settings/controllers/settings_controller.dart';
import 'package:quran/app/data/models/detail_juz.dart';
import 'package:sqflite/sqflite.dart';

class DetailJuzController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxString audioCondition = "stop".obs; // Status audio: play, pause, stop
  RxInt currentPlayingAyah =
      (-1).obs; // Ayat yang sedang diputar (-1 berarti tidak ada)
  RxList<Ayahs> ayahs = <Ayahs>[].obs; // Daftar ayat dalam Juz

  final player = AudioPlayer();
  DatabaseManager database = DatabaseManager.instance;

  @override
  void onInit() {
    super.onInit();

    // Tambahkan listener untuk mendeteksi ketika audio selesai
    player.playerStateStream.listen((state) async {
      if (state.processingState == ProcessingState.completed) {
        // Lanjutkan ke ayat berikutnya
        int currentIndex = ayahs.indexWhere(
          (ayah) => ayah.number == currentPlayingAyah.value,
        );

        if (currentIndex != -1 && currentIndex < ayahs.length - 1) {
          // Jika masih ada ayat berikutnya
          Ayahs nextAyah = ayahs[currentIndex + 1];
          playAudio(nextAyah.number.toString(), nextAyah.number!);
        } else {
          // Jika tidak ada ayat berikutnya, reset ke keadaan semula
          audioCondition.value = "stop";
          currentPlayingAyah.value = -1;
        }
      }
    });
  }

  void add(bool lastRead, Surah surah, Ayahs ayah, int index) async {
    CollectionReference bookmarks = firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('bookmarks');
    final existing =
        await bookmarks
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('surah', isEqualTo: surah.englishName)
            .where('ayah', isEqualTo: ayah.numberInSurah)
            .where('juz', isEqualTo: ayah.juz)
            .where('index_ayah', isEqualTo: index)
            .where('last_read', isEqualTo: 0)
            .get();

    try {
      if (lastRead) {
        await bookmarks.where('last_read', isEqualTo: 1).get().then((value) {
          for (var doc in value.docs) {
            doc.reference.delete();
          }
        });
      }
      if (existing.docs.isEmpty) {
        await bookmarks.add({
          "uid": FirebaseAuth.instance.currentUser!.uid,
          "surah": surah.englishName,
          "ayah": ayah.numberInSurah,
          "juz": ayah.juz,
          "index_ayah": index,
          "last_read": lastRead ? 1 : 0,
        });
        Get.back();
        if (lastRead) {
          Get.snackbar("Berhasil", "Berhasil menyimpan Terakhir dibaca");
        } else {
          Get.snackbar("Berhasil", "Berhasil menyimpan bookmark");
        }
      } else {
        Get.back();
        Get.snackbar("Gagal", "Bookmark sudah ada");
      }
    } catch (e) {
      Get.snackbar("Gagal", "Gagal menyimpan bookmark: $e");
      print("Error inserting bookmark: $e");
    }
  }

  Future<void> addBookmark(
    bool lastRead,
    Surah surah,
    Ayahs ayah,
    int index,
  ) async {
    try {
      Database db = await database.db;
      bool isExist = false;

      if (lastRead == true) {
        await db.delete("bookmarks", where: "last_read = ?", whereArgs: [1]);
      } else {
        List checkdata = await db.query(
          "bookmarks",
          where:
              "surah = ? AND ayah = ? AND juz = ? AND index_ayah = ? AND last_read = ?",
          whereArgs: [
            surah.englishName,
            ayah.numberInSurah.toString(),
            ayah.juz.toString(),
            index.toString(),
            0,
          ],
        );
        if (checkdata.isNotEmpty) {
          isExist = true;
        }
      }

      if (!isExist) {
        await db.insert("bookmarks", {
          "surah": surah.englishName,
          "ayah": ayah.numberInSurah.toString(),
          "juz": ayah.juz.toString(),
          "index_ayah": index.toString(),
          "last_read": lastRead ? 1 : 0,
        });
        Get.back();
        if (lastRead) {
          Get.snackbar("Berhasil", "Berhasil menyimpan Terakhir dibaca");
        } else {
          Get.snackbar("Berhasil", "Berhasil menyimpan bookmark");
        }
      } else {
        Get.back();
        Get.snackbar("Gagal", "Bookmark sudah ada");
      }

      var data = await db.query("bookmarks");
      print(data);
    } catch (e) {
      Get.snackbar("Gagal", "Gagal menyimpan bookmark: $e");
      print("Error inserting bookmark: $e");
    }
  }

  Future<Map<String, DetailJuz>> getDetailJuz(int juzNumber) async {
    final settingsController = Get.find<SettingsController>();
    final translationIdentifier =
        settingsController.selectedTranslation.value?.identifier ??
        'id.indonesian';

    final urls = {
      "arab": "https://api.alquran.cloud/v1/juz/$juzNumber/quran-uthmani",
      "latin": "https://api.alquran.cloud/v1/juz/$juzNumber/en.transliteration",
      "translation":
          "https://api.alquran.cloud/v1/juz/$juzNumber/$translationIdentifier",
    };

    Map<String, DetailJuz> result = {};

    try {
      for (var entry in urls.entries) {
        Uri url = Uri.parse(entry.value);
        var res = await http.get(url);

        if (res.statusCode == 200) {
          var data = json.decode(res.body);
          result[entry.key] = DetailJuz.fromJson(data);
        } else {
          throw Exception("Failed to load ${entry.key} juz data");
        }
      }

      // Simpan daftar ayat untuk melanjutkan audio
      ayahs.value = result["arab"]?.data?.ayahs ?? [];
    } catch (e) {
      print("Error fetching juz data: $e");
    }

    return result;
  }

  // In both controllers, update the playAudio method:
  void playAudio(String? id, int ayahNumber) async {
    final settingsController = Get.find<SettingsController>();
    final audioEdition =
        settingsController.selectedAudioEdition.value?.identifier ??
        'ar.alafasy';

    String url =
        "https://cdn.islamic.network/quran/audio/64/$audioEdition/$id.mp3";

    if (id != null) {
      try {
        await player.stop();
        currentPlayingAyah.value = ayahNumber;
        audioCondition.value = "play";
        await player.setUrl(url);
        await player.play();
      } catch (e) {
        Get.defaultDialog(title: "Error", middleText: "An error occurred: $e");
      }
    } else {
      Get.defaultDialog(title: "Error", middleText: "Audio not found");
    }
  }

  void pauseAudio() async {
    try {
      await player.pause();
      audioCondition.value = "pause"; // Ubah status menjadi pause
    } catch (e) {
      Get.defaultDialog(title: "Error", middleText: "An error occurred: $e");
    }
  }

  void resumeAudio() async {
    try {
      audioCondition.value = "play"; // Ubah status menjadi play
      await player.play();
    } catch (e) {
      Get.defaultDialog(title: "Error", middleText: "An error occurred: $e");
    }
  }

  void stopAudio() async {
    try {
      await player.stop();
      audioCondition.value = "stop"; // Ubah status menjadi stop
      currentPlayingAyah.value = -1; // Reset ayat yang sedang diputar
    } catch (e) {
      Get.defaultDialog(title: "Error", middleText: "An error occurred: $e");
    }
  }

  @override
  void onClose() {
    player.stop();
    player.dispose();
    super.onClose();
  }
}
