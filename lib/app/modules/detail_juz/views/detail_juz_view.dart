import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/app/constant/color.dart';
import 'package:quran/app/modules/home/controllers/home_controller.dart';
import 'package:quran/app/modules/settings/controllers/settings_controller.dart';
import 'package:quran/app/data/models/detail_juz.dart';
import '../controllers/detail_juz_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  final homeC = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final int juzNumber = Get.arguments + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Juz $juzNumber",
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Get.isDarkMode ? appGreenLight2 : appGreenDark,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, DetailJuz>>(
        future: controller.getDetailJuz(juzNumber),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Get.isDarkMode ? appGreenLight : appGreenDark,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
          final translation = data['translation'];

          if (arab == null) {
            return Center(
              child: Text(
                "Data Arab tidak tersedia",
                style: GoogleFonts.nunito(),
              ),
            );
          }
          if (latin == null) {
            return Center(
              child: Text(
                "Data Latin tidak tersedia",
                style: GoogleFonts.nunito(),
              ),
            );
          }
          if (translation == null) {
            return Center(
              child: Text(
                "Data Terjemahan tidak tersedia",
                style: GoogleFonts.nunito(),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            itemCount: arab.data?.ayahs?.length ?? 0,
            itemBuilder: (context, index) {
              final arabAyah = arab.data!.ayahs![index];
              final latinAyah = latin.data!.ayahs![index];
              final indoAyah = translation.data!.ayahs![index];

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
              cleanedArabicText = cleanedArabicText.replaceAll('۩', '').trim();
              final settingsController = Get.find<SettingsController>();

              List<Widget> ayahWidgets = [];

              // Tampilkan container surah setiap ayat pertama dari surah
              if (isFirstAyah) {
                ayahWidgets.add(
                  Padding(padding: const EdgeInsets.only(top: 16.0)),
                );
                ayahWidgets.add(
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${arabAyah.surah?.englishName ?? ''}",
                                style: GoogleFonts.nunito(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "(${arabAyah.surah?.englishNameTranslation ?? ''})",
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              Divider(
                                indent: 70,
                                endIndent: 70,
                                color: appWhite,
                              ),
                              Text(
                                "${arabAyah.surah?.numberOfAyahs} Verse | ${arabAyah.surah?.revelationType}",
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              if (hasBismillah)
                                Image.asset(
                                  "assets/images/bismillah.png",
                                  width: 200, // Set the desired width
                                  height: 50, // Set the desired height
                                  fit:
                                      BoxFit
                                          .contain, // Adjust the fit as needed
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Teks ayat dan terjemahan
              ayahWidgets.addAll([
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
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
                          settingsController.transliterationFontSize.value,
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
                      fontSize: settingsController.translationFontSize.value,
                    ),
                  ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Get.isDarkMode ? Color(0xFF2C2C2C) : appWhiteLight,
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
                                    middleTextStyle: GoogleFonts.nunito(),
                                    contentPadding: EdgeInsets.all(24),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          controller.add(
                                            true,
                                            arabAyah.surah!,
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
                                            arabAyah.surah!,
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
                                  controller.audioCondition.value == "play")
                                IconButton(
                                  onPressed: () {
                                    controller.pauseAudio();
                                  },
                                  icon: Icon(Icons.pause_circle_rounded),
                                )
                              else if (controller.currentPlayingAyah.value ==
                                      arabAyah.number &&
                                  controller.audioCondition.value == "pause")
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
              ]);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: ayahWidgets,
              );
            },
          );
        },
      ),
    );
  }
}
