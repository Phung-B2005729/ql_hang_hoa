// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color.dart';

class AppTheme {
  // 1
  static TextTheme lightTextTheme = TextTheme(
    // titleLarge
    titleLarge: GoogleFonts.openSans(
      fontSize: 22, //30
      fontWeight: FontWeight.w600,
      color: ColorClass.color_title_large,
    ),
    titleMedium: GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: ColorClass.color_title_medium,
    ),
    //
    titleSmall: GoogleFonts.openSans(
        fontSize: 14, color: ColorClass.color_title_medium),

    // context  body
    bodyLarge: GoogleFonts.openSans(
      fontSize: 16, //30
      color: ColorClass.color_back,
    ),
    bodyMedium: GoogleFonts.openSans(
      fontSize: 15,
      color: ColorClass.color_back,
    ),

    //
    bodySmall: GoogleFonts.openSans(
      fontSize: 14,
      color: ColorClass.color_back,
    ),

    //
    displayLarge: GoogleFonts.openSans(
      fontSize: 24, //28
      color: ColorClass.color_xanh_content,
    ),
    displaySmall: GoogleFonts.openSans(
      fontSize: 14, //28
      color: ColorClass.color_xanh_content,
    ),
    displayMedium: GoogleFonts.openSans(
      fontSize: 19, //28
      fontWeight: FontWeight.w600,
      color: ColorClass.color_back,
    ),
  );
  // 2
  static TextTheme darkTextTheme = TextTheme(
    // titleLarge
    titleLarge: GoogleFonts.openSans(
      fontSize: 22, //30
      color: Colors.white,
    ),
    titleMedium: GoogleFonts.openSans(
      fontSize: 16,
      color: Colors.white,
    ),
    //
    titleSmall: GoogleFonts.openSans(
      fontSize: 14,
      color: Colors.white,
    ),

    // context  body
    bodyLarge: GoogleFonts.openSans(
      fontSize: 16, //30
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.openSans(
      fontSize: 15,
      color: Colors.white,
    ),

    //
    bodySmall: GoogleFonts.openSans(
      fontSize: 14,
      color: Colors.white,
    ),

    //
    displayLarge: GoogleFonts.openSans(
      fontSize: 24, //28
      color: Colors.white,
    ),
    displaySmall: GoogleFonts.openSans(
      fontSize: 14, //28
      color: Colors.white,
    ),
    displayMedium: GoogleFonts.openSans(
      fontSize: 14, //28
      color: Colors.white,
    ),
  );
  // 3
  static ThemeData light() {
    return ThemeData(
        // useMaterial3: true,
        colorScheme: const ColorScheme.light(),
        brightness: Brightness.light,
        dialogBackgroundColor: ColorClass.color_thanh_ke,
        primaryColor: ColorClass.color_button,
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateColor.resolveWith(
            (states) {
              return Colors.black;
            },
          ),
        ),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shadowColor: ColorClass.xanh1Color,
          // centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: ColorClass.color_button_add,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: ColorClass.color_tap_active,
        ),
        textTheme: lightTextTheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    ColorClass.color_button_elevated))));
  }
}
