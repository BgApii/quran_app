import 'package:flutter/material.dart';

import 'package:get/get.dart';
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF206B3A),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, DetailSurah>>(
        future: controller.getAyahSurah(surah.number.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text("Tidak ada data!"));
          }
          final data = snapshot.data!;
          final arab = data['arab'];
          final latin = data['latin'];
          final indo = data['indo'];

          if (arab == null || latin == null || indo == null) {
            return Center(child: Text("Sebagian data tidak tersedia."));
          }

          return ListView(
            controller: controller.scrollC,
            padding: const EdgeInsets.all(16.0),
            children: [
              AutoScrollTag(
                key: ValueKey(0),
                index: 0,
                controller: controller.scrollC,
                child: Column(
                  children: [
                    AutoScrollTag(
                      key: ValueKey(1),
                      index: 1,
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
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {},
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${surah.englishName}",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFAF9F6),
                                          ),
                                        ),
                                        Text(
                                          "(${surah.englishNameTranslation})",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFFAF9F6),
                                          ),
                                        ),
                                        Divider(indent: 70, endIndent: 70),
                                        Text(
                                          "${surah.numberOfAyahs} Ayat | ${surah.revelationType}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFFAF9F6),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        if (surah.number != 1 &&
                                            surah.number != 9) ...[
                                          Text(
                                            "بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Color(0xFFFAF9F6),
                                            ),
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
                      ),
                    ),
                    AutoScrollTag(
                      key: ValueKey(2),
                      index: 2,
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
                        final settingsController =
                            Get.find<SettingsController>();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AutoScrollTag(
                          key: ValueKey(index + 3),
                          index: index + 3,
                          controller: controller.scrollC,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  cleanedArabicText,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize:
                                        settingsController.arabicFontSize.value,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            if (settingsController
                                .isTransliterationEnabled
                                .value)
                              Text(
                                latinAyah.text ?? '',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize:
                                      settingsController
                                          .transliterationFontSize
                                          .value,
                                  color: Color(0xFF206B3A),
                                ),
                              ),
                            if (settingsController
                                .isTransliterationEnabled
                                .value)
                              SizedBox(height: 8),
                            if (settingsController.isTranslationEnabled.value)
                              Text(
                                indoAyah.text ?? '',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize:
                                      settingsController
                                          .translationFontSize
                                          .value,
                                ),
                              ),
                            SizedBox(height: 8),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      child: Text(
                                        "${arabAyah.numberInSurah}",
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
                                                middleText:
                                                    "Pilih jenis bookmark",
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      await controller
                                                          .addBookmark(
                                                            true,
                                                            arab,
                                                            arabAyah,
                                                            index,
                                                          );
                                                      homeC.update();
                                                    },
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              appGreenDark,
                                                        ),
                                                    child: Text(
                                                      "Last Read",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      controller.addBookmark(
                                                        false,
                                                        arab,
                                                        arabAyah,
                                                        index,
                                                      );
                                                    },
                                                    child: Text(
                                                      "Bookmark",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                            icon: Icon(
                                              Icons.bookmark_outline,
                                            ),
                                          ),
                                          // Play, Pause, Resume, or Stop Icon
                                          if (controller
                                                      .currentPlayingAyah
                                                      .value ==
                                                  arabAyah.number &&
                                              controller
                                                      .audioCondition
                                                      .value ==
                                                  "play")
                                            IconButton(
                                              onPressed: () {
                                                controller.pauseAudio();
                                              },
                                              icon: Icon(Icons.pause),
                                            )
                                          else if (controller
                                                      .currentPlayingAyah
                                                      .value ==
                                                  arabAyah.number &&
                                              controller
                                                      .audioCondition
                                                      .value ==
                                                  "pause")
                                            IconButton(
                                              onPressed: () {
                                                controller.resumeAudio();
                                              },
                                              icon: Icon(Icons.play_arrow),
                                            )
                                          else
                                            IconButton(
                                              onPressed: () {
                                                controller.playAudio(
                                                  arabAyah.number.toString(),
                                                  arabAyah.number!,
                                                );
                                              },
                                              icon: Icon(Icons.play_arrow),
                                            ),
                                          // Stop Icon
                                          if (controller
                                                  .currentPlayingAyah
                                                  .value ==
                                              arabAyah.number)
                                            IconButton(
                                              onPressed: () {
                                                controller.stopAudio();
                                              },
                                              icon: Icon(Icons.stop),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
