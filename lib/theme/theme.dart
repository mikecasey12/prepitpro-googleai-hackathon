import 'package:flutter/material.dart';

abstract class ThemeController {
  static final ValueNotifier<ThemeMode> _themeMode =
      ValueNotifier(ThemeMode.light);

  static ValueNotifier<ThemeMode> get themeMode => _themeMode;

  static final ValueNotifier<bool> isDark = ValueNotifier(false);

  // static bool isDark = _isDark.value;

  static void switchDarkMode({bool? value = false}) {
    if (value!) {
      _themeMode.value = ThemeMode.dark;
      isDark.value = true;
    } else {
      _themeMode.value = ThemeMode.light;
      isDark.value = false;
    }
  }
}
