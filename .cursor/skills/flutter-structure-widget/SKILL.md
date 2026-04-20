---
name: flutter-structure-widget
description: >-
  Shared widget and utility conventions for autoreply_ai including
  LoadingWidget, CustomErrorWidget, toast messaging, validators, and common
  helpers. Use when adding reusable UI primitives under lib/widget or lib/util.
---

# Shared widgets & utilities

## Where shared UI lives

- **Reusable widgets** — `lib/widget/`
- **General helpers** — `lib/util/`
- Keep feature-specific UI inside `lib/ui/<feature>/`; only move code here when it is reused or clearly app-wide.

## Existing shared building blocks

- `lib/widget/loading_widget.dart` — wraps child content with a blocking loading overlay.
- `lib/widget/custom_error_widget.dart` — boot-time style error card for surfaced Flutter errors.
- `lib/widget/show_message.dart` — toast helper via `fluttertoast`.
- `lib/widget/debouncer.dart` — shared debounce behavior.
- `lib/util/validtor_custom.dart` — mixed phone/email validator.
- `lib/util/utils.dart` — URL launch, share sheet, and color swatch helpers.

## When to create a shared widget

- The same UI behavior is used across multiple features.
- The widget encodes project-wide styling or interaction patterns.
- The feature page becomes easier to read if extracted.

## Conventions

- Prefer stateless widgets unless local mutable state is required.
- Accept configuration through constructor params; avoid hidden globals except established app services.
- Use theme and design tokens where possible instead of hardcoding colors, padding, and text styles.
- Keep shared widgets composable; avoid embedding feature-specific API calls or business logic.
- If a utility grows UI state or rendering logic, move it from `lib/util/` to `lib/widget/`.

## Responsive/layout guidance

- New reusable UI should be compatible with `flutter_screenutil`.
- Prefer `Theme.of(context)` and project tokens over raw values when introducing new shared components.

## Update this skill when

New shared widgets are added, utilities move between `lib/widget` and `lib/util`, or the project standard for reusable UI changes.
