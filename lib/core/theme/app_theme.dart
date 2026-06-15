import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _seedColor = Color(0xFF022B3A);
  static const _accent = Color(0xFF1F7A8C);

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      primary: _seedColor,
      secondary: _accent,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFE1E5F2),
    appBarTheme: const AppBarTheme(
      backgroundColor: _seedColor,
      foregroundColor: Colors.white,
    ),
    fontFamily: 'Inter',
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      primary: Colors.white,
      secondary: _accent,
      surface: const Color(0xFF0A3D50),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: _seedColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0A3D50),
      foregroundColor: Colors.white,
    ),
    fontFamily: 'Inter',
  );
}
