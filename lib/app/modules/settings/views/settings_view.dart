import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/app/constant/color.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF206B3A),
          ),
        ),
      ),
      body: ListView(
        children: [
          // Arabic Settings
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Text("Arabic"),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                      Get.isDarkMode
                          ? appGreyLight.withOpacity(0.1)
                          : appGrey.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: ListTile(
              onTap: () => _showFontSizeBottomSheet(true, false, false),
              title: Text("Font Size"),
              subtitle: Obx(
                () => Text("Current: ${controller.arabicFontSize.value}"),
              ),
            ),
          ),

          // Transliteration Settings
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Text("Transliteration"),
          ),
          Obx(
            () => SwitchListTile(
              onChanged: controller.toggleTransliteration,
              title: Text("Enable Transliteration"),
              subtitle: Text("Show transliteration text"),
              value: controller.isTransliterationEnabled.value,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                      Get.isDarkMode
                          ? appGreyLight.withOpacity(0.1)
                          : appGrey.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: ListTile(
              onTap: () => _showFontSizeBottomSheet(false, true, false),
              title: Text("Font Size"),
              subtitle: Obx(
                () => Text(
                  "Current: ${controller.transliterationFontSize.value}",
                ),
              ),
            ),
          ),

          // Translation Settings
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Text("Translations"),
          ),
          Obx(
            () => SwitchListTile(
              onChanged: controller.toggleTranslation,
              title: Text("Enable Translation"),
              subtitle: Text("Show translation text"),
              value: controller.isTranslationEnabled.value,
            ),
          ),
          Obx(
            () => ListTile(
              onTap: () => _showTranslationSelector(),
              title: Text("Select Language"),
              subtitle: Text(
                controller.selectedTranslation.value?.name ?? "Not selected",
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                      Get.isDarkMode
                          ? appGreyLight.withOpacity(0.1)
                          : appGrey.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: ListTile(
              onTap: () => _showFontSizeBottomSheet(false, false, true),
              title: Text("Font Size"),
              subtitle: Obx(
                () => Text("Current: ${controller.translationFontSize.value}"),
              ),
            ),
          ),

          // Audio Settings
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Text("Audio"),
          ),
          Obx(
            () => Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        Get.isDarkMode
                            ? appGreyLight.withOpacity(0.1)
                            : appGrey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: ListTile(
                onTap: () => _showAudioEditionSelector(),
                title: Text("Select Reciter"),
                subtitle: Text(
                  controller.selectedAudioEdition.value?.englishName ??
                      "Not selected",
                ),
              ),
            ),
          ),

          // General Settings
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Text("General"),
          ),
          Obx(
            () => SwitchListTile(
              onChanged: controller.toggleDarkMode,
              title: Text("Dark Mode"),
              subtitle: Text("Enable dark theme"),
              value: controller.isDarkMode.value,
            ),
          ),
        ],
      ),
    );
  }

  void _showFontSizeBottomSheet(
    bool isArabic,
    bool isTransliteration,
    bool isTranslation,
  ) {
    final controller = Get.find<SettingsController>();
    double currentSize =
        isArabic
            ? controller.arabicFontSize.value
            : isTransliteration
            ? controller.transliterationFontSize.value
            : controller.translationFontSize.value;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isArabic
                      ? "Arabic Font Size"
                      : isTransliteration
                      ? "Transliteration Font Size"
                      : "Translation Font Size",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  "${currentSize.toStringAsFixed(1)}",
                  style: TextStyle(fontSize: 24),
                ),
                Slider(
                  value: currentSize,
                  min: 12,
                  max: 32,
                  divisions: 20,
                  label: currentSize.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      currentSize = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text("Cancel"),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        if (isArabic) {
                          controller.arabicFontSize.value = currentSize;
                        } else if (isTransliteration) {
                          controller.transliterationFontSize.value =
                              currentSize;
                        } else {
                          controller.translationFontSize.value = currentSize;
                        }
                        await controller.saveSettings();
                        Get.back();
                      },
                      child: Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAudioEditionSelector() {
    final controller = Get.find<SettingsController>();
    final searchController = TextEditingController();
    final RxString searchQuery = ''.obs;

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Select Reciter",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search reciters...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  searchQuery.value = value.toLowerCase();
                },
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final filteredEditions =
                    controller.audioEditions.where((edition) {
                      final englishName =
                          edition.englishName?.toLowerCase() ?? '';
                      final language = edition.language?.toLowerCase() ?? '';
                      return englishName.contains(searchQuery.value) ||
                          language.contains(searchQuery.value);
                    }).toList();

                return ListView.builder(
                  itemCount: filteredEditions.length,
                  itemBuilder: (context, index) {
                    final edition = filteredEditions[index];
                    return ListTile(
                      title: Text(edition.englishName ?? 'Unknown'),
                      subtitle: Text(edition.language ?? 'Unknown'),
                      trailing:
                          controller.selectedAudioEdition.value?.identifier ==
                                  edition.identifier
                              ? Icon(Icons.check, color: Colors.green)
                              : null,
                      onTap: () async {
                        await controller.changeAudioEdition(edition);
                        Get.back();
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showTranslationSelector() {
    final controller = Get.find<SettingsController>();
    final searchController = TextEditingController();
    final RxString searchQuery = ''.obs;

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Select Translation",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search translations...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  searchQuery.value = value.toLowerCase();
                },
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final filteredTranslations =
                    controller.translations.where((translation) {
                      final name = translation.name?.toLowerCase() ?? '';
                      final language =
                          translation.language?.toLowerCase() ?? '';
                      return name.contains(searchQuery.value) ||
                          language.contains(searchQuery.value);
                    }).toList();

                return ListView.builder(
                  itemCount: filteredTranslations.length,
                  itemBuilder: (context, index) {
                    final translation = filteredTranslations[index];
                    return ListTile(
                      title: Text(translation.englishName ?? 'Unknown'),
                      subtitle: Text(translation.language ?? 'Unknown'),
                      trailing:
                          controller.selectedTranslation.value?.identifier ==
                                  translation.identifier
                              ? Icon(Icons.check, color: Colors.green)
                              : null,
                      onTap: () async {
                        await controller.changeTranslation(translation);
                        Get.back();
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
