import 'package:flutter/material.dart';

ColorFilter kSvgColorBlack = ColorFilter.mode(Colors.black, BlendMode.srcIn);
ColorFilter kSvgColorWhite = ColorFilter.mode(Colors.white, BlendMode.srcIn);

ColorFilter kSvgColor(Color color) => ColorFilter.mode(color, BlendMode.srcIn);

final Color kPrimaryColor = Color(0xFF0114AD);
final Color kPrimaryColorAccent = Color.fromARGB(255, 148, 158, 244);
final Color kScaffoldColor = Colors.white;
final Color kPillButtonColor = Color.fromARGB(255, 6, 113, 159);
const Color kPillColor = Color(0xFFDEE1FB);
final Color kCircleAvatarColor =
    ColorScheme.fromSeed(seedColor: kPrimaryColor).primaryContainer;

// ----------------------------->

ThemeData kThemeData() => ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      colorSchemeSeed: kPrimaryColor,
      scaffoldBackgroundColor: kScaffoldColor,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: kPrimaryColor,
      ),
      cardTheme: CardTheme(
        color: kPrimaryColorAccent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: kScaffoldColor,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 17),
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
