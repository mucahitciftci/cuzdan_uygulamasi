import 'package:flutter/material.dart';

class AppTheme {
  static const Color darkBackground = Color(0xFF263238); // BlueGrey 900
  static const Color lightBackground = Color(0xFFF5F5F5); // Gri 100

  // --- TEMA MODUNU BURADAN TAKİP EDİYORUZ ---
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

  // --- TEK TUŞLA TEMA DEĞİŞTİRME FONKSİYONU ---
  static void toggleTheme() {
    if (themeNotifier.value == ThemeMode.dark) {
      themeNotifier.value = ThemeMode.light;
    } else {
      themeNotifier.value = ThemeMode.dark;
    }
  }

  // --- AÇIK TEMA TANIMI ---
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackground,
    primaryColor: Colors.teal,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );

  // --- KOYU TEMA TANIMI ---
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: Colors.tealAccent.shade400, // Login ekranıyla uyumlu hale getirdik
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}