import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'design_tokens.dart';

/// Material 3 [ThemeData] for light mode based on [DesignTokens].
ThemeData buildAppTheme(DesignTokens tokens) {
  final scheme = _lightColorScheme;
  final trustpilotSans = GoogleFonts.nunitoSansTextTheme();

  TextStyle? byKey(String key) {
    final t = tokens.typography[key];
    if (t == null) return null;
    return GoogleFonts.nunitoSans(
      fontSize: t.fontSize,
      fontWeight: t.fontWeight,
      height: t.height,
      letterSpacing: t.letterSpacing,
      color: scheme.onSurface,
    );
  }

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFFFFFffe),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF2D2F29),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        minimumSize: const Size.fromHeight(56),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(color: scheme.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.primary, width: 1.4),
      ),
      filled: true,
      fillColor: const Color(0xFFF3F0EC),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outline.withValues(alpha: 0.4)),
      ),
      shadowColor: const Color(0x1A6A6A68),
    ),
    chipTheme: ChipThemeData(
      side: BorderSide(color: scheme.outline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      labelStyle: GoogleFonts.nunitoSans(
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      backgroundColor: Colors.white,
      selectedColor: scheme.primaryContainer,
      checkmarkColor: scheme.primary,
    ),
    textTheme: trustpilotSans.copyWith(
      displayLarge: byKey('displayLg'),
      displayMedium: byKey('displayMd'),
      headlineSmall: byKey('headlineSm'),
      titleLarge: byKey('titleLg'),
      titleMedium: byKey('titleMd'),
      bodyLarge: byKey('bodyLg'),
      bodyMedium: byKey('bodyMd'),
      labelMedium: byKey('labelMd'),
    ),
  );
}

/// Material 3 [ThemeData] for dark mode.
ThemeData buildDarkAppTheme(DesignTokens tokens) {
  final scheme = _darkColorScheme;
  final trustpilotSans = GoogleFonts.nunitoSansTextTheme();

  TextStyle? byKey(String key) {
    final t = tokens.typography[key];
    if (t == null) return null;
    return GoogleFonts.nunitoSans(
      fontSize: t.fontSize,
      fontWeight: t.fontWeight,
      height: t.height,
      letterSpacing: t.letterSpacing,
      color: scheme.onSurface,
    );
  }

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFF091E42),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF091E42),
      foregroundColor: scheme.onSurface,
      elevation: 0,
      centerTitle: false,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        minimumSize: const Size.fromHeight(56),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        side: BorderSide(color: scheme.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary, width: 1.4),
      ),
      filled: true,
      fillColor: const Color(0xFF172B4D),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: const Color(0xFF172B4D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outline.withValues(alpha: 0.6)),
      ),
    ),
    chipTheme: ChipThemeData(
      side: BorderSide(color: scheme.outline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      labelStyle: GoogleFonts.nunitoSans(
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      backgroundColor: const Color(0xFF172B4D),
      selectedColor: scheme.primaryContainer,
      checkmarkColor: scheme.primary,
    ),
    textTheme: trustpilotSans.copyWith(
      displayLarge: byKey('displayLg'),
      displayMedium: byKey('displayMd'),
      headlineSmall: byKey('headlineSm'),
      titleLarge: byKey('titleLg'),
      titleMedium: byKey('titleMd'),
      bodyLarge: byKey('bodyLg'),
      bodyMedium: byKey('bodyMd'),
      labelMedium: byKey('labelMd'),
    ),
  );
}

const ColorScheme _lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF3C57BC),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF799DFA),
  onSecondary: Color(0xFFFFFFFF),
  error: Color(0xFFB3261E),
  onError: Color(0xFFFFFFFF),
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF2D2F29),
  primaryContainer: Color(0xFFE8ECFB),
  onPrimaryContainer: Color(0xFF1F2E66),
  secondaryContainer: Color(0xFFEFF3FF),
  onSecondaryContainer: Color(0xFF3D4E79),
  tertiary: Color(0xFF00BA72),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFE6F9F1),
  onTertiaryContainer: Color(0xFF0B5B3C),
  outline: Color(0xFFDCD6D1),
  outlineVariant: Color(0xFFE7E1DC),
  shadow: Color(0x1A000000),
  scrim: Color(0x33000000),
  inverseSurface: Color(0xFF2D2F29),
  onInverseSurface: Color(0xFFFFFffe),
  inversePrimary: Color(0xFF79A8FF),
  surfaceTint: Color(0xFF3C57BC),
);

const ColorScheme _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF79A8FF),
  onPrimary: Color(0xFF002A6E),
  secondary: Color(0xFF62E5FF),
  onSecondary: Color(0xFF003742),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  surface: Color(0xFF172B4D),
  onSurface: Color(0xFFF4F5F7),
  primaryContainer: Color(0xFF0F397F),
  onPrimaryContainer: Color(0xFFDCE8FF),
  secondaryContainer: Color(0xFF0D5564),
  onSecondaryContainer: Color(0xFFD0F6FF),
  tertiary: Color(0xFF62E5FF),
  onTertiary: Color(0xFF003742),
  tertiaryContainer: Color(0xFF0D5564),
  onTertiaryContainer: Color(0xFFD0F6FF),
  outline: Color(0xFF5E7193),
  outlineVariant: Color(0xFF3A4E72),
  shadow: Color(0x66000000),
  scrim: Color(0x99000000),
  inverseSurface: Color(0xFFF4F5F7),
  onInverseSurface: Color(0xFF091E42),
  inversePrimary: Color(0xFF0052CC),
  surfaceTint: Color(0xFF79A8FF),
);
