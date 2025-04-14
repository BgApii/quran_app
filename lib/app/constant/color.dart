import 'package:flutter/material.dart';

const appGreenDark = Color(0xFF206B3A);
const appGreenLight = Color(0xFF1BE20D);
const appGreenLight2 = Color(0xFF22C55E);
const appGreen = Color(0xFF12870A);
const appWhite = Color(0xFFFAF9F6);
const appWhiteLight = Color(0xFFFFFFFF);
const appGrey = Color(0xFF787373);
const appGreyLight = Color(0xFFCCCCCC);
const appBlack = Color(0xFF1E1E1E);

ThemeData light = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: appWhite,
    elevation: 3,
    shadowColor: Colors.grey.withOpacity(0.3),
  ),
  primaryColor: appGreenDark,
  scaffoldBackgroundColor: appWhite,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: appGreenDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
  ),
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(backgroundColor: appBlack, elevation: 1),
  primaryColor: appGreenLight2,
  scaffoldBackgroundColor: appBlack,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: appGreenLight2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
  ),
);
