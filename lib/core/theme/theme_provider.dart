import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Provider للوضع الليلي مع حفظه في Hive
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(_loadThemeMode());

  static ThemeMode _loadThemeMode() {
    final box = Hive.box('settings');
    final isDark = box.get('isDarkMode', defaultValue: false);
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme(bool isDark) {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
    final box = Hive.box('settings');
    box.put('isDarkMode', isDark);
  }
}
