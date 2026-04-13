import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Loads [assets/style_tokens.json]. Call [load] once after
/// [WidgetsFlutterBinding.ensureInitialized].
class DesignTokens {
  DesignTokens._({
    required this.colors,
    required this.spacing,
    required this.radius,
    required this.typography,
  });

  final TokenColors colors;
  final Map<String, double> spacing;
  final Map<String, double> radius;
  final Map<String, TextStyle> typography;

  static DesignTokens? _instance;

  static DesignTokens get instance {
    final i = _instance;
    if (i == null) {
      throw StateError('DesignTokens.load() must be called before runApp');
    }
    return i;
  }

  static Future<void> load() async {
    final raw = await rootBundle.loadString('assets/style_tokens.json');
    _instance = _parse(jsonDecode(raw) as Map<String, dynamic>);
  }

  static DesignTokens _parse(Map<String, dynamic> json) {
    final c = json['colors'] as Map<String, dynamic>? ?? {};
    final s = (json['spacing'] as Map<String, dynamic>? ?? {})
        .map((k, v) => MapEntry(k, (v as num).toDouble()));
    final r = (json['radius'] as Map<String, dynamic>? ?? {})
        .map((k, v) => MapEntry(k, (v as num).toDouble()));
    final t = json['typography'] as Map<String, dynamic>? ?? {};
    return DesignTokens._(
      colors: TokenColors.fromJson(c),
      spacing: s,
      radius: r,
      typography: t.map((key, v) => MapEntry(
            key,
            _textStyleFromJson(v as Map<String, dynamic>),
          )),
    );
  }

  static TextStyle _textStyleFromJson(Map<String, dynamic> m) {
    final size = (m['fontSize'] as num?)?.toDouble() ?? 14;
    final weight = _fontWeight(m['fontWeight'] as String?);
    final height = (m['height'] as num?)?.toDouble();
    final letter = (m['letterSpacing'] as num?)?.toDouble();
    final family = m['fontFamily'] as String?;
    return TextStyle(
      fontFamily: family,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letter,
    );
  }

  static FontWeight? _fontWeight(String? w) {
    switch (w) {
      case 'bold':
      case 'w700':
        return FontWeight.w700;
      case 'w600':
        return FontWeight.w600;
      case 'w500':
        return FontWeight.w500;
      case 'normal':
      case null:
        return FontWeight.w400;
      default:
        return FontWeight.w400;
    }
  }
}

class TokenColors {
  TokenColors({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.tertiary,
    required this.onTertiary,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.error,
    required this.onError,
  });

  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color tertiary;
  final Color onTertiary;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color error;
  final Color onError;

  static TokenColors fromJson(Map<String, dynamic> j) {
    return TokenColors(
      primary: _hex(j['primary'] as String),
      onPrimary: _hex(j['onPrimary'] as String),
      secondary: _hex(j['secondary'] as String),
      onSecondary: _hex(j['onSecondary'] as String),
      tertiary: _hex(j['tertiary'] as String),
      onTertiary: _hex(j['onTertiary'] as String),
      background: _hex(j['background'] as String),
      onBackground: _hex(j['onBackground'] as String),
      surface: _hex(j['surface'] as String),
      onSurface: _hex(j['onSurface'] as String),
      surfaceVariant: _hex(j['surfaceVariant'] as String),
      onSurfaceVariant: _hex(j['onSurfaceVariant'] as String),
      outline: _hex(j['outline'] as String),
      outlineVariant: _hex(j['outlineVariant'] as String? ?? '#00000000'),
      error: _hex(j['error'] as String),
      onError: _hex(j['onError'] as String),
    );
  }

  /// Supports `#RRGGBB` and `#RRGGBBAA` (last byte = alpha).
  static Color _hex(String hex) {
    var h = hex.replaceAll('#', '');
    if (h.length == 6) {
      return Color(int.parse('FF$h', radix: 16));
    }
    if (h.length == 8) {
      final v = int.parse(h, radix: 16);
      final r = (v >> 24) & 0xFF;
      final g = (v >> 16) & 0xFF;
      final b = (v >> 8) & 0xFF;
      final a = v & 0xFF;
      return Color.fromARGB(a, r, g, b);
    }
    return Colors.grey;
  }

  ColorScheme toColorScheme({Brightness brightness = Brightness.light}) {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      tertiary: tertiary,
      onTertiary: onTertiary,
      error: error,
      onError: onError,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceVariant,
      outline: outline,
    );
  }
}
