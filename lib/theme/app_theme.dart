import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'design_tokens.dart';

/// Material 3 [ThemeData] built from [DesignTokens] (style_tokens.json).
ThemeData buildAppTheme(DesignTokens tokens) {
  final scheme = tokens.colors.toColorScheme();
  final inter = GoogleFonts.interTextTheme();

  TextStyle? byKey(String key) {
    final t = tokens.typography[key];
    if (t == null) return null;
    return GoogleFonts.inter(
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
    scaffoldBackgroundColor: tokens.colors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spacing['l'] ?? 24,
          vertical: tokens.spacing['m'] ?? 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radius['md'] ?? 8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(tokens.radius['md'] ?? 8),
      ),
      filled: true,
      fillColor: scheme.surfaceContainerHighest,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radius['lg'] ?? 10),
        side: BorderSide(color: scheme.outline.withValues(alpha: 0.4)),
      ),
    ),
    textTheme: inter.copyWith(
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
