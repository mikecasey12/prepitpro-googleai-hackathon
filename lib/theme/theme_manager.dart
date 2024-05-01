import 'package:flutter/material.dart';

abstract class ThemeManager {
  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.brown,
      error: Colors.red,
      brightness: Brightness.dark,
      tertiary: Colors.brown.shade800,
    ),
    useMaterial3: true,
    fontFamily: "Monsterrat",
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: Color.fromARGB(255, 199, 159, 144),
      labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.amber,
      brightness: Brightness.light,
      error: Colors.red,
      secondary: Colors.amber.shade300,
      tertiary: Colors.amber,
    ),
    useMaterial3: true,
    fontFamily: "Monsterrat",
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
      bodyLarge: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: Colors.white,
      labelStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
    ),
  );
}
