import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/app/modules/settings/controllers/settings_controller.dart';
import 'package:quran/app/routes/app_pages.dart';
import 'package:quran/app/constant/color.dart';

void main() async {
  // Ensure widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: light,
      darkTheme: dark,
      themeMode: ThemeMode.system,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(SettingsController());
      }),
    ),
  );
}
