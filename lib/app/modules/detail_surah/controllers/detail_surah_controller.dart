import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:quran/app/modules/settings/controllers/settings_controller.dart';
import 'package:quran/app/data/models/detail_surah.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class DetailSurahController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  AutoScrollController scrollC = AutoScrollController();
  RxString audioCondition = "stop".obs; // Status audio: play, pause, stop
  RxInt currentPlayingAyah =
      (-1).obs; // Ayat yang sedang diputar (-1 berarti tidak ada)
  RxList<Ayahs> ayahs = <Ayahs>[].obs; // Daftar ayat dalam surah

  final player = AudioPlayer();

  @override
  void onInit() {
    super.onInit();

    // Tambahkan listener untuk mendeteksi ketika audio selesai
    player.playerStateStream.listen((state) {
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

  // Di DetailSurahController, tambahkan method:
  void scrollToAyah(int ayahNumber) async {
    // Cari index ayah berdasarkan nomor
    int index = ayahs.indexWhere((ayah) => ayah.numberInSurah == ayahNumber);

    if (index != -1) {
      await scrollC.scrollToIndex(
        index + 2, // +3 karena ada widget lain di atas
        preferPosition: AutoScrollPosition.begin,
      );
    }
  }

  void add(bool lastRead, DetailSurah surah, Ayahs ayah, int index) async {
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
            .where('last_read', isEqualTo: lastRead ? 1 : 0)
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
          "created_at": FieldValue.serverTimestamp(),
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

  Future<Map<String, DetailSurah>> getAyahSurah(String id) async {
    final settingsController = Get.find<SettingsController>();
    final translationIdentifier =
        settingsController.selectedTranslation.value?.identifier ??
        'id.indonesian';

    Uri url = Uri.parse(
      "https://api.alquran.cloud/v1/surah/$id/editions/quran-uthmani,en.transliteration,$translationIdentifier",
    );
    var res = await http.get(url);

    List? data = (json.decode(res.body) as Map<String, dynamic>)["data"];

    if (data == null) {
      return {};
    } else {
      // Simpan daftar ayat untuk melanjutkan audio
      ayahs.value = DetailSurah.fromJson(data[0]).ayahs ?? [];
      return {
        "arab": DetailSurah.fromJson(data[0]),
        "latin": DetailSurah.fromJson(data[1]),
        "indo": DetailSurah.fromJson(data[2]),
      };
    }
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
