import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const bgColor = Color(0xFF111111);
  static const textColor = Color(0xFFE5E5E5);
  static const mutedColor = Color(0xFF8A8A8A);
  static const accentColor = Color(0xFF1F3D2B);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgColor,
    textTheme: GoogleFonts.interTextTheme().apply(
      bodyColor: textColor,
      displayColor: textColor,
    ),
    colorScheme: ColorScheme.dark(
      primary: accentColor,
      secondary: mutedColor,
      background: bgColor,
      surface: const Color(0xFF141414),
    ),
  );
}
