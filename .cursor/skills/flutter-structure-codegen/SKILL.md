---
name: flutter-structure-codegen
description: >-
  build_runner, MobX, Retrofit, json_serializable, auto_route, Hive CE generators,
  flutter_gen, intl for flutter_demo_structure. Use when touching *.g.dart files,
  annotations, or adding generated APIs.
---

# Codegen

## Command

```bash
dart run build_runner build --delete-conflicting-outputs
```

Run after changing annotated classes: MobX stores, Retrofit APIs, json models, Hive types, auto_route pages.

## Generators in this project

| Output | Package / trigger |
|--------|-------------------|
| `*.g.dart` (MobX) | `mobx_codegen`, `part 'store.g.dart'` |
| `auth_api.g.dart` | `retrofit_generator`, `@RestApi()` |
| `login_request_model.g.dart`, `base_response.g.dart` | `json_serializable` |
| `app_router.gr.dart` | `auto_route_generator`, `@RoutePage`, `@AutoRouterConfig` |
| `hive_registrar.g.dart`, `UserData` adapter | `hive_ce_generator`, `@HiveType` |
| `lib/generated/` assets | `flutter_gen_runner` (see `pubspec.yaml` flutter_gen) |
| `lib/generated/l10n.dart` | `intl_utils` / `flutter_intl` from `lib/l10n/*.arb` |

## Rules

- **Never hand-edit** `*.g.dart` or `*.gr.dart` files.
- Keep `part` paths aligned with file names.
- If CI fails on stale generated code, regenerate and commit outputs (this repo tracks generated Dart per `.gitignore` rules—follow existing practice).

## Update this skill when

New generator packages are added or generation commands change.
