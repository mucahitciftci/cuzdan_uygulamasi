import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppTheme {
  AppTheme._();

  static final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);

  // --- TEMAYI HIVE'A KAYDEDEN YENİ METOT ---
  static void toggleTheme() {
    final settingsBox = Hive.box('settings_box');
    
    if (themeModeNotifier.value == ThemeMode.dark) {
      themeModeNotifier.value = ThemeMode.light;
      settingsBox.put('isDarkMode', false);
    } else {
      themeModeNotifier.value = ThemeMode.dark;
      settingsBox.put('isDarkMode', true);
    }
  }

  // --- AÇIK TEMA TASARIMI ---
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.teal,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: Colors.teal,
        secondary: Colors.tealAccent,
        error: Colors.redAccent.shade700,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // --- KOYU TEMA TASARIMI ---
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.teal.shade300,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: ColorScheme.dark(
        primary: Colors.teal.shade300,
        secondary: Colors.tealAccent.shade100,
        surface: Colors.blueGrey.shade900,
        error: Colors.redAccent.shade200,
        onError: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}