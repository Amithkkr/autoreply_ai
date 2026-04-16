---
name: flutter-design-system-tokens
description: Build or update a Flutter design system from a Figma export, design-token JSON, or similar source. Use when the user wants to create or refresh color scales, spacing, radius, typography, semantic tokens, theme manager classes, or token-backed preview/setup code for this app.
---

# Flutter design system tokens

Use this skill when the user wants to turn design tokens from Figma, a JSON export, or another design source into a Flutter design system that this repo can actually consume.

## Scope

Handle these token groups when they exist in the source:
- color palettes and semantic color roles
- spacing, radius, dimension, and typography scales
- theme manager and token manager classes
- token-backed `ThemeData` and `ThemeExtension` wiring
- design-system preview pages and documentation widgets

## Required inputs

Before changing code, inspect the source of truth the user provides:
- Figma export JSON
- token JSON
- style guide screenshot or attachment
- existing design-system file from another tool

If the source is incomplete, keep the missing token groups explicit rather than inventing values.

## This repo’s token architecture

Prefer the host project’s existing structure when it already has one:
- token JSON or token source file used at runtime
- a manager that loads and exposes token values
- strongly typed models for colors, spacing, radius, typography, and dimensions
- theme wiring for `ThemeData` or a project-specific theme wrapper
- a widget helper that makes token access easy inside components
- preview or documentation pages that show the active tokens

If the project already has this structure, update it carefully rather than replacing it.

## Workflow

### 1. Read the source shape

Look for these categories in the source:
- base palette colors
- semantic colors
- spacing scale
- radius scale
- typography styles
- dimension constants

### 2. Normalize the names

Convert source naming into Flutter-friendly names that match the repo’s conventions:
- `primary-500` -> `primary500`
- `grey/600` -> `grey600`
- `spacing-md` -> `m`
- `radius-lg` -> `l`
- `body/medium` -> `bodyMedium`

### 3. Update the JSON source of truth

If the repo uses a JSON token file, update that file first or alongside the models:
- keep the JSON human-readable
- keep token groups separated by category
- preserve exact numeric values from the source
- preserve hex values exactly, including alpha when present

Treat the JSON file as the canonical bridge between design source and Flutter code.

### 4. Update token models

Adjust the token models so each field is strongly typed:
- colors become `Color`
- spacing and dimensions become `double`
- radius becomes `BorderRadius`
- typography becomes `TextStyle`

Keep the models compatible with the existing `StyleManager` and `ThemeManager` flow.

### 5. Wire the theme

Make sure the loaded tokens drive:
- `StyleManager.theme`
- `ThemeManager.getColorStyles()`
- `ThemeManager.getSpacings()`
- `ThemeManager.getRadius()`
- `ThemeManager.getTextStyles()`
- `AppTheme.buildMaterialTheme()`
- the project’s existing theme extension or wrapper, if it has one

If the app already has a theme extension or wrapper, update it instead of creating a second system.

### 6. Update widget access patterns

When generating or refactoring widgets:
- use `BazaarThemeTokens.of(context)` inside widgets
- use token-backed values from `AppColor`, `StyleManager`, or `ThemeManager`
- avoid hardcoded colors and spacing unless the user explicitly wants a one-off override
- keep token resolution close to where the widget builds

### 7. Update preview pages

If the repo has preview/demo pages, update them so the user can visually verify:
- color palette
- semantic colors
- spacing bars
- radius scales
- typography samples
- icon/color combinations if relevant

### 8. Regenerate code if needed

If the model changes affect generated files, run the project’s generation flow after updating source files.

Do not claim the design system is complete until:
- the source data is wired in
- the token models compile
- the preview pages render
- the app theme uses the updated tokens

## Output expectations

When the user asks to use this skill, prefer delivering:
- updated token JSON or a transformed token file
- updated Flutter model classes
- updated theme manager / theme extension code
- updated design-system preview widgets
- a short summary of what token groups were added or changed

## Good prompts

- "Convert this Figma token export into our Flutter theme system."
- "Update the color palette and spacing scale from this JSON."
- "Make the design system match this style guide and wire it into ThemeManager."
- "Add semantic colors and typography tokens to the current Flutter theme setup."

## Guardrails

- Do not invent token values if the source does not provide them.
- Do not break the current repo’s token naming unless the user asks for a rename.
- Do not replace the whole theme architecture if a targeted token update is enough.
- Do not forget the preview layer; this skill should leave the design system inspectable.
