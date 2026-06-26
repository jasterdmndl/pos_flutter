import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors (Boutique Emerald & Ink)
  static const Color emerald = Color(0xFF006B2C);
  static const Color emeraldDeep = Color(0xFF004D1A);
  static const Color ink = Color(0xFF1A1C19);
  static const Color bone = Color(0xFFF9FBF7);
  static const Color mintSoft = Color(0xFFE8F5E9);
  static const Color error = Color(0xFFBA1A1A);
  
  // Radius
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;

  // Spacing
  static const double spacingBase = 4.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;

  static ThemeData get boutiqueTheme {
    final baseTextTheme = GoogleFonts.spaceGroteskTextTheme();
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: emerald,
        primary: emerald,
        onPrimary: Colors.white,
        secondary: emeraldDeep,
        surface: Colors.white,
        onSurface: ink,
        error: error,
      ),
      scaffoldBackgroundColor: bone,
      
      // Typography
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.fraunces(fontWeight: FontWeight.bold, color: ink),
        displayMedium: GoogleFonts.fraunces(fontWeight: FontWeight.bold, color: ink),
        headlineLarge: GoogleFonts.fraunces(fontWeight: FontWeight.bold, color: ink),
        headlineMedium: GoogleFonts.fraunces(fontWeight: FontWeight.bold, color: ink),
        titleLarge: GoogleFonts.fraunces(fontWeight: FontWeight.bold, color: ink),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          letterSpacing: 1.2,
          fontWeight: FontWeight.bold,
          color: emeraldDeep,
        ),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.fraunces(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: ink,
        ),
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: emerald,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          elevation: 0,
          textStyle: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: emerald, width: 2),
        ),
        labelStyle: GoogleFonts.spaceGrotesk(color: ink.withValues(alpha: 0.6)),
      ),
      
      dividerTheme: const DividerThemeData(
        thickness: 1.5,
        color: Color(0xFFE2E8F0),
      ),
    );
  }
}
