---
name: flutter-structure-design
description: >-
  Design tokens from assets/style_tokens.json, lib/theme ThemeData, google_fonts trustpilot-like sans,
  ScreenUtil, and assets. Use when changing colors, typography, spacing, app theme,
  or branding.
---

# Design & theme

## Sources of truth

1. **`assets/style_tokens.json`** — Semantic colors, spacing scale, radii, typography keys (`displayLg`, `bodyMd`, etc.). **Edit here first** for brand changes.
2. **`lib/theme/design_tokens.dart`** — Loads JSON at startup via `DesignTokens.load()` (called from `main.dart` before `setupLocator`).
3. **`lib/theme/app_theme.dart`** — `buildAppTheme(DesignTokens)` + `buildDarkAppTheme(DesignTokens)` for Material 3 themes (buttons, inputs, cards, text mapped with a **Trustpilot-style sans** via `google_fonts`).
4. **`lib/theme/theme_context.dart`** — `context.designTokens` for spacing/colors in widgets.

## Runtime fonts

- Tokens reference **Trustpilot Sans** semantics in JSON; theme currently maps to a close sans from `google_fonts` for practical implementation.
- **Rotunda** is declared in `pubspec.yaml` for weight 700—use explicitly where needed (e.g. `TextStyle(fontFamily: 'Rotunda', fontWeight: FontWeight.w700)`).

## Layout

- **flutter_screenutil** — `ScreenUtilInit` wraps `MaterialApp` in `main.dart`. Prefer `.w`, `.h`, `.sp` for responsive layouts in new UI.

## Purposes (when to use what)

| Need | Use |
|------|-----|
| Brand colors / semantic UI | `Theme.of(context).colorScheme` or `DesignTokens.instance.colors` |
| Padding/margin scale | `DesignTokens.instance.spacing['m']` (keys: xs, s, m, l, xl, xxl) |
| Corner radius | `DesignTokens.instance.radius['md']`, etc. |
| Type scale | `Theme.of(context).textTheme.*` or `tokens.typography['titleMd']` |
| Images/icons | `assets/image/`, generated `AppAssets` (flutter_gen) |

## Hex colors in JSON

- `#RRGGBB` and `#RRGGBBAA` supported (last two hex digits = alpha).

## Update this skill when

`style_tokens.json` schema changes, new theme files are added, or `main.dart` theme/bootstrap flow changes.
