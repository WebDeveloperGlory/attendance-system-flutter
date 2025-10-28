import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Base color
  static const Color _primaryBlue = Color(0xFF2563EB);

  // ---------- LIGHT THEME ----------
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: _primaryBlue,
      onPrimary: Colors.white,
      secondary: Color(0xFFE0E7FF),
      onSecondary: Colors.black,
      error: Colors.redAccent,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
      outline: Color(0xFFE5E7EB),
      outlineVariant: Color(0xFFF3F4F6),
      surfaceContainerHighest: Color(0xFFF9FAFB),
      shadow: Colors.black12,
      tertiary: Color(0xFF60A5FA),
    ),
    textTheme: GoogleFonts.interTightTextTheme(),
    useMaterial3: true,
  );

  // ---------- DARK THEME ----------
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: _primaryBlue,
      onPrimary: Colors.white,
      secondary: Color(0xFF1E3A8A),
      onSecondary: Colors.white,
      error: Colors.redAccent,
      onError: Colors.white,
      surface: Color(0xFF111827),
      onSurface: Colors.white,
      outline: Color(0xFF374151),
      outlineVariant: Color(0xFF1F2937),
      surfaceContainerHighest: Color(0xFF1E293B),
      shadow: Colors.black38,
      tertiary: Color(0xFF60A5FA),
    ),
    textTheme: GoogleFonts.interTightTextTheme(
      ThemeData.dark().textTheme,
    ),
    useMaterial3: true,
  );
}