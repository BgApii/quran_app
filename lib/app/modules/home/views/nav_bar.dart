import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/app/constant/color.dart';
import 'package:quran/app/modules/home/controllers/home_controller.dart';
import 'package:quran/app/routes/app_pages.dart';

class NavBar extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Get.isDarkMode ? appGreenLight : appGreenDark,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: GoogleFonts.nunito(),
            ),
          );
        } else if (snapshot.hasData) {
          return Drawer(
            child: Padding(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      user?.displayName ?? 'No User',
                      style: GoogleFonts.nunito(color: appWhite),
                    ),
                    accountEmail: Text(
                      user?.email ?? 'No Email',
                      style: GoogleFonts.nunito(color: appWhite),
                    ),
                    currentAccountPicture: CircleAvatar(
                      // backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.network(
                          user?.photoURL ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.asset("assets/images/bg_nav.jpg").image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Settings", style: GoogleFonts.nunito()),
                    onTap: () {
                      Get.toNamed(Routes.SETTINGS);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout", style: GoogleFonts.nunito()),
                    onTap: () {
                      controller.logout();
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              "Please log in to continue.",
              style: GoogleFonts.nunito(),
            ),
          );
        }
      },
    );
  }
}
