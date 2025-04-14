import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF206B3A),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, DetailJuz>>(
        future: controller.getDetailJuz(juzNumber),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Tidak ada data!"));
          }

          final data = snapshot.data!;
          final arab = data['arab'];
          final latin = data['latin'];
          final translation = data['translation'];

          if (arab == null) {
            return Center(child: Text("Data Arab tidak tersedia"));
          }
          if (latin == null) {
            return Center(child: Text("Data Latin tidak tersedia"));
          }
          if (translation == null) {
            return Center(child: Text("Data Terjemahan tidak tersedia"));
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${arabAyah.surah?.englishName ?? ''}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "(${arabAyah.surah?.englishNameTranslation ?? ''})",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Divider(indent: 70, endIndent: 70),
                                  Text(
                                    "${arabAyah.surah?.numberOfAyahs} Ayat | ${arabAyah.surah?.revelationType}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  if (hasBismillah)
                                    Text(
                                      "بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                    style: TextStyle(
                      fontSize: settingsController.arabicFontSize.value,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                if (settingsController.isTransliterationEnabled.value)
                  Text(
                    latinAyah.text ?? '',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize:
                          settingsController.transliterationFontSize.value,
                      color: Color(0xFF206B3A),
                    ),
                  ),
                if (settingsController.isTransliterationEnabled.value)
                  SizedBox(height: 8),
                if (settingsController.isTranslationEnabled.value)
                  Text(
                    indoAyah.text ?? '',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: settingsController.translationFontSize.value,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(child: Text("${arabAyah.numberInSurah}")),
                        Obx(
                          () => Row(
                            children: [
                              // Bookmark Icon
                              IconButton(
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: "BOOKMARK",
                                    middleText: "Pilih jenis bookmark",
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          await controller.addBookmark(
                                            true,
                                            arabAyah.surah!,
                                            arabAyah,
                                            index,
                                          );
                                          homeC.update();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: appGreenDark,
                                        ),
                                        child: Text(
                                          "Last Read",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          controller.addBookmark(
                                            false,
                                            arabAyah.surah!,
                                            arabAyah,
                                            index,
                                          );
                                        },
                                        child: Text(
                                          "Bookmark",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                icon: Icon(Icons.bookmark_outline),
                              ),
                              // Play, Pause, Resume, or Stop Icon
                              if (controller.currentPlayingAyah.value ==
                                      arabAyah.number &&
                                  controller.audioCondition.value == "play")
                                IconButton(
                                  onPressed: () {
                                    controller.pauseAudio();
                                  },
                                  icon: Icon(Icons.pause),
                                )
                              else if (controller.currentPlayingAyah.value ==
                                      arabAyah.number &&
                                  controller.audioCondition.value == "pause")
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
                              if (controller.currentPlayingAyah.value ==
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
