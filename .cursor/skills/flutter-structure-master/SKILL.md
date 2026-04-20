---
name: flutter-structure-master
description: >-
  Index for autoreply_ai layout, design tokens, codegen, and iOS/Android
  build conventions. Use when onboarding, refactoring folders, changing theme or
  assets, or when the user asks about project structure, skills, or keeping docs in sync.
---

# Flutter structure (master)

## When to load

Use this skill first for any question about **where code lives**, **how layers connect**, **design tokens**, **model patterns**, **shared widgets**, **build_runner**, or **iOS/Android quirks** in this repo. Then open the **sub-skill** that matches the task (paths below).

## Sub-skills (read the relevant one)

| Sub-skill | Path | Use when |
|-----------|------|----------|
| Architecture | [flutter-structure-architecture](../flutter-structure-architecture/SKILL.md) | `lib/core`, `lib/data`, `locator`, repositories, API flow |
| Design & theme | [flutter-structure-design](../flutter-structure-design/SKILL.md) | `assets/style_tokens.json`, `lib/theme`, `ThemeData`, typography |
| Model classes | [flutter-structure-model-class](../flutter-structure-model-class/SKILL.md) | request/response DTOs, `BaseResponse<T>`, Hive-backed models |
| Shared widgets | [flutter-structure-widget](../flutter-structure-widget/SKILL.md) | `lib/widget`, `lib/util`, reusable UI helpers |
| Codegen | [flutter-structure-codegen](../flutter-structure-codegen/SKILL.md) | MobX, Retrofit, auto_route, Hive, `build_runner`, generated files |
| Platform / build | [flutter-structure-platform](../flutter-structure-platform/SKILL.md) | iOS Pods, `Generated.xcconfig`, `Debug.xcconfig` overrides, Android SDK |

## Repo docs

- Human-readable overview: [PROJECT_STRUCTURE.md](../../../PROJECT_STRUCTURE.md) at repository root.

## Keeping skills and docs up to date (required)

When you change the project in ways below, **update the matching artifacts** in the same PR or follow-up commit:

| Change | Update |
|--------|--------|
| New `lib/` top-level folder or moved feature layer | `PROJECT_STRUCTURE.md`, **architecture** sub-skill |
| New/changed REST models, repos, or interceptors | **architecture** sub-skill |
| New model serialization or Hive adapter changes | **model-class** sub-skill |
| Edited `style_tokens.json`, theme classes, or `main.dart` theme wiring | **design** sub-skill |
| New reusable widgets, validators, or utilities | **widget** sub-skill |
| New code generators, scripts, or generated file types | **codegen** sub-skill |
| Podfile, xcconfig, Gradle, manifests, Firebase/social iOS setup | **platform** sub-skill |
| Major new dependency category (e.g. new state library) | `PROJECT_STRUCTURE.md`, **architecture** or **codegen** as fits |

**Rule of thumb:** If a future contributor would be misled by stale text, refresh the doc or skill.

## Package

- Name: `autoreply_ai`
- Entry: `lib/main.dart` → `DesignTokens.load()` → `setupLocator()` → `MaterialApp.router`
