import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/app/constant/color.dart';
import 'package:quran/app/modules/home/controllers/home_controller.dart';
import 'package:quran/app/modules/settings/controllers/settings_controller.dart';
import 'package:quran/app/data/models/detail_surah.dart';
import 'package:quran/app/data/models/meta.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  final References surah = Get.arguments;
  final homeC = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Surah ${surah.englishName}",
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Get.isDarkMode ? appGreenLight2 : appGreenDark,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, DetailSurah>>(
        future: controller.getAyahSurah(surah.number.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Get.isDarkMode ? appGreenLight2 : appGreenDark,
              ),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Gagal memuat data!", style: GoogleFonts.nunito()),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Get.isDarkMode ? appGreenLight : appGreenDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Back",
                      style: GoogleFonts.nunito(
                        color: appWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          final data = snapshot.data!;
          final arab = data['arab'];
          final latin = data['latin'];
          final indo = data['indo'];

          if (arab == null || latin == null || indo == null) {
            return Center(
              child: Text(
                "Sebagian data tidak tersedia.",
                style: GoogleFonts.nunito(),
              ),
            );
          }

          return ListView(
            controller: controller.scrollC,
            padding: const EdgeInsets.all(16.0),
            children: [
              AutoScrollTag(
                key: ValueKey(0),
                index: 0,
                controller: controller.scrollC,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1BE20D), Color(0xFF12870A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        right: 10,
                        child: Opacity(
                          opacity: 0.3,
                          child: Image.asset(
                            "assets/images/quran.png",
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(24.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${surah.englishName}",
                                style: GoogleFonts.nunito(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: appWhite,
                                ),
                              ),
                              Text(
                                "(${surah.englishNameTranslation})",
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: appWhite,
                                ),
                              ),
                              Divider(
                                indent: 70,
                                endIndent: 70,
                                color: appWhite,
                              ),
                              Text(
                                "${surah.numberOfAyahs} Verse | ${surah.revelationType}",
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: appWhite,
                                ),
                              ),
                              SizedBox(height: 10),
                              if (surah.number != 1 && surah.number != 9) ...[
                                Image.asset(
                                  "assets/images/bismillah.png",
                                  width: 200, // Set the desired width
                                  height: 50, // Set the desired height
                                  fit:
                                      BoxFit
                                          .contain, // Adjust the fit as needed
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AutoScrollTag(
                key: ValueKey(1),
                index: 1,
                controller: controller.scrollC,
                child: SizedBox(height: 20),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: surah.numberOfAyahs,
                itemBuilder: (context, index) {
                  final arabAyah = arab.ayahs![index];
                  final latinAyah = latin.ayahs![index];
                  final indoAyah = indo.ayahs![index];

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (Get.parameters['ayah'] != null) {
                      int ayahNumber =
                          int.tryParse(Get.parameters['ayah'] ?? '') ?? 0;
                      if (ayahNumber > 0) {
                        controller.scrollToAyah(ayahNumber);
                      }
                    }
                  });

                  final isFirstAyah = arabAyah.numberInSurah == 1;
                  final hasBismillah =
                      arabAyah.text?.startsWith(
                        'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                      ) ??
                      false;

                  String cleanedArabicText = arabAyah.text ?? '';
                  if (isFirstAyah && hasBismillah) {
                    cleanedArabicText =
                        cleanedArabicText
                            .replaceFirst(
                              'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                              '',
                            )
                            .trim();
                  }
                  cleanedArabicText =
                      cleanedArabicText.replaceAll('۩', '').trim();
                  final settingsController = Get.find<SettingsController>();
                  return AutoScrollTag(
                    key: ValueKey(index + 2),
                    index: index + 2,
                    controller: controller.scrollC,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 8.0,
                          ),
                          child: Text(
                            cleanedArabicText,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.scheherazadeNew(
                              fontSize: settingsController.arabicFontSize.value,
                              height: 2,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        if (settingsController.isTransliterationEnabled.value)
                          Text(
                            latinAyah.text ?? '',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.nunito(
                              fontSize:
                                  settingsController
                                      .transliterationFontSize
                                      .value,
                              color: appGreenDark,
                            ),
                          ),
                        if (settingsController.isTransliterationEnabled.value)
                          SizedBox(height: 8),
                        if (settingsController.isTranslationEnabled.value)
                          Text(
                            indoAyah.text ?? '',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.nunito(
                              fontSize:
                                  settingsController.translationFontSize.value,
                            ),
                          ),
                        SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color:
                                Get.isDarkMode
                                    ? Color(0xFF2C2C2C)
                                    : appWhiteLight,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        Get.isDarkMode
                                            ? "assets/images/list_dark.png"
                                            : "assets/images/list_light.png",
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${arabAyah.numberInSurah}",
                                      style: GoogleFonts.nunito(),
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => Row(
                                    children: [
                                      // Bookmark Icon
                                      IconButton(
                                        onPressed: () {
                                          Get.defaultDialog(
                                            title: "BOOKMARK",
                                            titleStyle: GoogleFonts.nunito(),
                                            middleText: "Pilih jenis bookmark",
                                            middleTextStyle:
                                                GoogleFonts.nunito(),
                                            contentPadding: EdgeInsets.all(24),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  controller.add(
                                                    true,
                                                    arab,
                                                    arabAyah,
                                                    index,
                                                  );
                                                  homeC.update();
                                                },
                                                child: Text(
                                                  "Last Read",
                                                  style: GoogleFonts.nunito(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  controller.add(
                                                    false,
                                                    arab,
                                                    arabAyah,
                                                    index,
                                                  );
                                                },
                                                child: Text(
                                                  "Bookmark",
                                                  style: GoogleFonts.nunito(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        icon: Icon(Icons.bookmark_add_rounded),
                                      ),
                                      // Play, Pause, Resume, or Stop Icon
                                      if (controller.currentPlayingAyah.value ==
                                              arabAyah.number &&
                                          controller.audioCondition.value ==
                                              "play")
                                        IconButton(
                                          onPressed: () {
                                            controller.pauseAudio();
                                          },
                                          icon: Icon(
                                            Icons.pause_circle_rounded,
                                          ),
                                        )
                                      else if (controller
                                                  .currentPlayingAyah
                                                  .value ==
                                              arabAyah.number &&
                                          controller.audioCondition.value ==
                                              "pause")
                                        IconButton(
                                          onPressed: () {
                                            controller.resumeAudio();
                                          },
                                          icon: Icon(Icons.play_circle_rounded),
                                        )
                                      else
                                        IconButton(
                                          onPressed: () {
                                            controller.playAudio(
                                              arabAyah.number.toString(),
                                              arabAyah.number!,
                                            );
                                          },
                                          icon: Icon(Icons.play_circle_rounded),
                                        ),
                                      // Stop Icon
                                      if (controller.currentPlayingAyah.value ==
                                          arabAyah.number)
                                        IconButton(
                                          onPressed: () {
                                            controller.stopAudio();
                                          },
                                          icon: Icon(Icons.stop_circle_rounded),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
