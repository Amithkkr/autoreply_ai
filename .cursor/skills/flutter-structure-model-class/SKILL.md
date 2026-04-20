---
name: flutter-structure-model-class
description: >-
  Request and response model conventions for autoreply_ai using
  json_serializable, BaseResponse<T>, and optional Hive CE adapters. Use when
  creating or editing API models under lib/data/model or core/base_response.
---

# Model classes

## Where models live

- **Requests** — `lib/data/model/request/` — payloads sent to APIs.
- **Responses** — `lib/data/model/response/` — decoded server objects.
- **Shared envelopes** — `lib/core/api/base_response/` — generic wrappers like `BaseResponse<T>`.

## Current patterns in this repo

- Use `@JsonSerializable(...)` and generate `*.g.dart` files with `build_runner`.
- Add `part '<file>.g.dart';` in the source file and keep the filename aligned.
- Use `@JsonKey(name: 'snake_case')` to match backend payload names.
- Make fields nullable when the API is inconsistent or partial.
- If a response must be cached locally, combine `json_serializable` with `@HiveType` and `@HiveField`, as in `UserData`.

## BaseResponse usage

- API methods usually return `BaseResponse<T>`.
- Preserve the generic factory pattern:

```dart
factory BaseResponse.fromJson(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _$BaseResponseFromJson(json, fromJsonT);
```

- When adding a new response type, wire the parser through Retrofit or repository code instead of bypassing the envelope.

## Adding a new model (checklist)

- [ ] Place the file in `request/` or `response/`.
- [ ] Add `@JsonSerializable(...)` and `part`.
- [ ] Add `@JsonKey` names for backend field mapping.
- [ ] Add `@HiveType` / `@HiveField` only if the object is persisted.
- [ ] Regenerate code with `dart run build_runner build --delete-conflicting-outputs`.
- [ ] If a new Hive type is introduced, ensure registration is handled during app startup.

## Conventions

- Prefer plain data classes only; keep business logic in repos, stores, or services.
- Keep constructor parameters named, matching the field list.
- Follow existing backend names like `login_type`, `country_code`, `social_id` instead of inventing client-only keys.
- Avoid hand-written `fromJson` / `toJson` unless codegen cannot express the mapping.

## Update this skill when

Model folders move, envelope parsing changes, Hive usage changes, or the project adopts a different serialization pattern.
