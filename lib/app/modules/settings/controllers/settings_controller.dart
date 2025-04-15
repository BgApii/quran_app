import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:quran/app/data/models/edition.dart';
import 'package:flutter/material.dart';

class SettingsController extends GetxController {
  // Settings variables
  RxDouble arabicFontSize = 23.0.obs;
  RxDouble translationFontSize = 16.0.obs;
  RxDouble transliterationFontSize = 16.0.obs;
  RxBool isTransliterationEnabled = false.obs;
  RxBool isTranslationEnabled = true.obs;
  Rx<Edition?> selectedTranslation = Rx<Edition?>(null);
  Rx<Edition?> selectedAudioEdition = Rx<Edition?>(null);
  RxList<Edition> audioEditions = <Edition>[].obs;
  RxBool isDarkMode = false.obs;

  // Available translations list
  RxList<Edition> translations = <Edition>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await loadSettings();
    await loadAvailableTranslations();
    await loadAvailableAudioEditions(); // Add this line
  }

  // Add this to your SettingsController
  Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Reset all settings to default values
    arabicFontSize.value = 23.0;
    translationFontSize.value = 16.0;
    transliterationFontSize.value = 16.0;
    isTransliterationEnabled.value = false;
    isTranslationEnabled.value = true;
    isDarkMode.value = false;

    // Reset to default translations
    selectedTranslation.value = translations.firstWhere(
      (t) => t.identifier == 'en.sahih',
      orElse: () => translations.first,
    );

    // Reset to default audio
    selectedAudioEdition.value = audioEditions.firstWhere(
      (t) => t.identifier == 'ar.alafasy',
      orElse: () => audioEditions.first,
    );

    // Apply theme mode
    Get.changeThemeMode(ThemeMode.light);

    // Save the reset settings
    await saveSettings();
  }

  // Load settings from SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    arabicFontSize.value = prefs.getDouble('arabicFontSize') ?? 23.0;
    translationFontSize.value = prefs.getDouble('translationFontSize') ?? 16.0;
    transliterationFontSize.value =
        prefs.getDouble('transliterationFontSize') ?? 16.0;
    isTransliterationEnabled.value =
        prefs.getBool('isTransliterationEnabled') ?? false;
    isTranslationEnabled.value = prefs.getBool('isTranslationEnabled') ?? true;
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;

    // Load selected translation
    final translationJson = prefs.getString('selectedTranslation');
    if (translationJson != null) {
      selectedTranslation.value = Edition.fromJson(
        json.decode(translationJson),
      );
    }

    final audioJson = prefs.getString('selectedAudio');
    if (audioJson != null) {
      selectedAudioEdition.value = Edition.fromJson(json.decode(audioJson));
    }

    // Apply theme mode
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  // Save settings to SharedPreferences
  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('arabicFontSize', arabicFontSize.value);
    await prefs.setDouble('translationFontSize', translationFontSize.value);
    await prefs.setDouble(
      'transliterationFontSize',
      transliterationFontSize.value,
    );
    await prefs.setBool(
      'isTransliterationEnabled',
      isTransliterationEnabled.value,
    );
    await prefs.setBool('isTranslationEnabled', isTranslationEnabled.value);
    await prefs.setBool('isDarkMode', isDarkMode.value);

    if (selectedTranslation.value != null) {
      await prefs.setString(
        'selectedTranslation',
        json.encode(selectedTranslation.value!.toJson()),
      );
    }
    if (selectedAudioEdition.value != null) {
      await prefs.setString(
        'selectedAudio',
        json.encode(selectedAudioEdition.value!.toJson()),
      );
    }
  }

  Future<void> loadAvailableAudioEditions() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.alquran.cloud/v1/edition/format/audio'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        audioEditions.value =
            data.map((json) => Edition.fromJson(json)).toList();

        // If no audio edition is selected, choose Alafasy by default
        if (selectedAudioEdition.value == null) {
          selectedAudioEdition.value = audioEditions.firstWhere(
            (t) => t.identifier == 'ar.alafasy',
            orElse: () => audioEditions.first,
          );
          await saveSettings();
        }
      }
    } catch (e) {
      print('Error loading audio editions: $e');
    }
  }

  // Load available translations from API
  Future<void> loadAvailableTranslations() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.alquran.cloud/v1/edition/type/translation'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        translations.value =
            data.map((json) => Edition.fromJson(json)).toList();

        // If no translation is selected, choose the first Indonesian one by default
        if (selectedTranslation.value == null) {
          selectedTranslation.value = translations.firstWhere(
            (t) => t.identifier == 'en.sahih',
            orElse: () => translations.first,
          );
          await saveSettings();
        }
      }
    } catch (e) {
      print('Error loading translations: $e');
    }
  }

  Future<void> changeAudioEdition(Edition edition) async {
    selectedAudioEdition.value = edition;
    await saveSettings();
  }

  // Toggle dark mode
  Future<void> toggleDarkMode(bool value) async {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    await saveSettings();
  }

  // Update font sizes
  Future<void> updateArabicFontSize(double size) async {
    arabicFontSize.value = size;
    await saveSettings();
  }

  Future<void> updateTranslationFontSize(double size) async {
    translationFontSize.value = size;
    await saveSettings();
  }

  Future<void> updateTransliterationFontSize(double size) async {
    transliterationFontSize.value = size;
    await saveSettings();
  }

  // Toggle features
  Future<void> toggleTransliteration(bool value) async {
    isTransliterationEnabled.value = value;
    await saveSettings();
  }

  Future<void> toggleTranslation(bool value) async {
    isTranslationEnabled.value = value;
    await saveSettings();
  }

  // Change translation
  Future<void> changeTranslation(Edition translation) async {
    selectedTranslation.value = translation;
    await saveSettings();
  }
}
