# 📖 Al-Quran App

A beautiful and feature-rich Quran application built with Flutter, providing an immersive experience for reading and listening to the Holy Quran.

---

## ✨ Features

- 📖 **Complete Quran Text** (Arabic script)
- 🌐 **Indonesian & Multilingual Translations**
- 🔠 **Transliteration** for better pronunciation
- 🎿 **Audio Playback** with multiple reciters
- 🌃 **Dark & Light Theme** modes
- 🔖 **Bookmark & Last Read** tracking
- 📚 **Juz Navigation**
- 🔠 **Adjustable Font Sizes**
- 📀 **Offline Support (in progress)**

---

## 🚀 Installation Guide

> Make sure [Flutter](https://flutter.dev/docs/get-started/install) is installed.

### ✅ Requirements

- Flutter SDK (version 3.29.0 or above recommended)
- Dart SDK
- Android Studio / VS Code (with Flutter and Dart plugins installed)
- An emulator or real device connected
- Internet connection for fetching Quran data

### 🛠️ Setup Instructions

```bash
# Clone the repo
git clone https://github.com/BgApii/quran_app.git

# Move into project directory
cd quran-app

# Install packages
flutter pub get

# Run on your device/emulator
flutter run
```

---

## 📦 Dependencies Used

| Package            | Description                           |
|--------------------|---------------------------------------|
| [`get`](https://pub.dev/packages/get) | State management & routing |
| [`lottie`](https://pub.dev/packages/lottie) | Beautiful animations |
| [`just_audio`](https://pub.dev/packages/just_audio) | Recitation audio player |
| [`sqflite`](https://pub.dev/packages/sqflite) | Local database for bookmarks |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | Save user settings |
| [`scroll_to_index`](https://pub.dev/packages/scroll_to_index) | Smooth scroll experience |
| [`google_fonts`](https://pub.dev/packages/google_fonts) | Enhanced typography |
| [`http`](https://pub.dev/packages/http) | API requests for Quran data |

---

## 🗂️ Folder Structure

```
lib/
🔹 app/
🔹🔹 constant/          # Colors, sizes, themes
🔹🔹 data/
🔹🔹 modules/
🔹🔹🔹 home/          # Home UI and logic
🔹🔹🔹 detail_surah/  # Surah detail logic
🔹🔹🔹 detail_juz/    # Juz detail logic
🔹🔹🔹 settings/      # App settings
🔹🔹 routes/            # Named route management
assets/
🔹 fonts/
🔹 images/
🔹 lotties/
```

---

## 🌐 Data Sources

- [Al-Quran Cloud API](https://alquran.cloud/api)

---

## 🙏 Acknowledgments

- Flutter & Dart Team
- Quran API providers: [alquran.cloud](https://alquran.cloud/)
- Amazing open-source packages by the Flutter community

---

> **Note**: This app is for educational and religious enrichment. Always cross-check Quranic texts with authenticated sources.

