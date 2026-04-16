---
name: flutter-structure-architecture
description: >-
  Layered architecture for flutter_demo_structure: get_it locator, core API/Dio,
  repositories, MobX UI stores, auto_route. Use when adding features, APIs, repos,
  or changing lib/core or lib/data layout.
---

# Architecture (flutter_demo_structure)

## Layers

1. **UI** — `lib/ui/<feature>/` — Pages (`@RoutePage`), MobX stores (`*.dart` + `*.g.dart`), minimal logic.
2. **Data** — `lib/data/` — `remote/` (Retrofit), `model/`, `repository/` (abstract), `repository_impl/`.
3. **Core** — `lib/core/` — `locator`, `api` (Dio module, interceptors, `BaseResponse`), `db` (`AppDB` / Hive), `exceptions`.
4. **Router** — `lib/router/app_router.dart` + generated `app_router.gr.dart`.
5. **Services** — `lib/service/` — cross-cutting (e.g. `EncService`).
6. **Shared** — `lib/widget/`, `lib/util/`.

## Dependency injection

- **get_it** singleton: `lib/core/locator/locator.dart` — `setupLocator()` registers `AppDB`, `AppRouter`, `Dio`, `AuthApi`, `EncService`, `AuthRepoImpl` factory.
- Async singleton: `AppDB` — await `locator.isReady<AppDB>()` after `setupLocator()` in `main.dart`.
- Hive bootstraps in `locator.dart` using `getApplicationDocumentsDirectory()` on Android and `getLibraryDirectory()` on iOS, then registers `UserDataAdapter()`.
- Repos: `AuthRepoImpl` is registered in `GetIt`, and the repo currently also exposes a global `authRepo` shortcut from `auth_repo_impl.dart`. Keep future features consistent within the same feature flow.

## API flow

- `ApiModule` builds **Dio** (base URL in `api_end_points.dart`), adds interceptors (encryption, connectivity, logging).
- **Retrofit** clients in `lib/data/remote/*_api.dart` with `part '*.g.dart'`.
- Responses wrapped in **`BaseResponse<T>`** (`lib/core/api/base_response/`).
- **Repository impl** calls API only; mapping/error policy stays in one place.
- `EncService` is registered as a lazy singleton and is available to encryption-aware interceptors or services.

## Adding a feature (checklist)

- [ ] Route in `app_router.dart` + run `build_runner`.
- [ ] Models + `json_serializable` if needed.
- [ ] Retrofit API interface + generated part.
- [ ] Abstract repo + impl; register impl in `locator.dart`.
- [ ] MobX store + `Observer` UI under `lib/ui/<feature>/`.

## Update this skill when

Folder layout under `lib/core`, `lib/data`, or DI registration changes; or when the standard feature pipeline changes.
