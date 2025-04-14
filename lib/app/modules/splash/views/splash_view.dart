import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quran/app/routes/app_pages.dart';
import 'package:quran/app/constant/color.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Al-Quran App",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? appGreenLight2 : appGreenDark,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Sesibuk itukah kamu sampai belum\nmembaca alquran?",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: Get.isDarkMode ? appGreyLight : appGrey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Lottie.asset(
              'assets/lotties/lottie_intro.json',
              width: 300,
              height: 200,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Get.offAllNamed(Routes.HOME),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(
                "GET STARTED",
                style: TextStyle(
                  color: Get.isDarkMode ? appWhiteLight : appWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
