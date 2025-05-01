import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:quran/app/constant/color.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
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
              "Are you so busy that you haven't\nread the Quran?",
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
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Get.isDarkMode ? appGreenLight2 : appGreenDark,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              label: Text(
                "Sign Google",
                style: GoogleFonts.nunito(fontSize: 16, color: Colors.white),
              ),
              icon: FaIcon(
                FontAwesomeIcons.google,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () => controller.signInWithGoogle(),
            ),
          ],
        ),
      ),
    );
  }
}
