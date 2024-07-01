// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

import 'color.dart';

class AppTheme {
  // 1
  static TextTheme lightTextTheme = const TextTheme(
    // titleLarge
    titleLarge: TextStyle(
      fontSize: 22, //30
      fontWeight: FontWeight.w600,
      color: ColorClass.color_title_large,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: ColorClass.color_title_medium,
    ),
    //
    titleSmall: TextStyle(fontSize: 14, color: ColorClass.color_title_medium),

    // context  body
    bodyLarge: TextStyle(
      fontSize: 16, //30
      color: ColorClass.color_back,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      color: ColorClass.color_back,
    ),

    //
    bodySmall: TextStyle(
      fontSize: 14,
      color: ColorClass.color_back,
    ),

    //
    displayLarge: TextStyle(
      fontSize: 24, //28
      color: ColorClass.color_xanh_content,
    ),
    displaySmall: TextStyle(
      fontSize: 14, //28
      color: ColorClass.color_xanh_content,
    ),
    displayMedium: TextStyle(
      fontSize: 19, //28
      fontWeight: FontWeight.w600,
      color: ColorClass.color_back,
    ),
  );
  // 2
  static TextTheme darkTextTheme = const TextTheme(
    // titleLarge
    titleLarge: TextStyle(
      fontSize: 22, //30
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
    //
    titleSmall: TextStyle(
      fontSize: 14,
      color: Colors.white,
    ),

    // context  body
    bodyLarge: TextStyle(
      fontSize: 16, //30
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      color: Colors.white,
    ),

    //
    bodySmall: TextStyle(
      fontSize: 14,
      color: Colors.white,
    ),

    //
    displayLarge: TextStyle(
      fontSize: 24, //28
      color: Colors.white,
    ),
    displaySmall: TextStyle(
      fontSize: 14, //28
      color: Colors.white,
    ),
    displayMedium: TextStyle(
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
