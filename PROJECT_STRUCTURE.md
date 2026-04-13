# Flutter Demo Structure — Project Documentation

This document describes the **flutter_demo_structure** app: folder layout, **pubspec** libraries, and how the main pieces are wired together.

---

## Overview

| Item | Value |
|------|--------|
| Package name | `flutter_demo_structure` |
| Dart SDK | `>=3.8.0 <4.0.0` |
| UI toolkit | Flutter (Material 3) |
| State (example screen) | MobX |
| Navigation | auto_route |
| HTTP client | Dio + Retrofit |
| Local storage | Hive CE |
| DI | get_it |

The sample flow is a **login screen** that calls a **Retrofit-defined** sign-in API through a **repository**, with **MobX** driving loading and error state.

---

## Directory structure (`lib/`)

```
lib/
├── main.dart                    # Entry: zone guard, locator, ScreenUtil, MaterialApp.router
├── hive_registrar.g.dart        # Generated Hive type registration (build_runner)
│
├── core/                        # App-wide infrastructure
│   ├── api/
│   │   ├── api_end_points.dart      # baseUrl + path constants
│   │   ├── api_module.dart          # Dio setup, interceptors, GetIt registration
│   │   ├── base_response/           # Generic API envelope + FB user helper model
│   │   └── interceptor/             # Encryption headers + connectivity check
│   ├── db/
│   │   └── app_db.dart              # Hive box wrapper (token, user, flags)
│   ├── exceptions/
│   │   ├── app_exceptions.dart
│   │   └── dio_exception_util.dart  # Maps Dio errors to localized strings
│   └── locator/
│       └── locator.dart             # get_it: Hive, AppDB, AppRouter, Dio, APIs, repos, EncService
│
├── data/                        # Data layer
│   ├── model/
│   │   ├── request/                 # e.g. LoginRequestModel (+ json_serializable)
│   │   └── response/                # e.g. UserData (+ Hive adapter + json_serializable)
│   ├── remote/
│   │   ├── auth_api.dart            # Retrofit REST client (+ generated .g.dart)
│   │   └── upload_file.dart         # Simple http.put upload helper
│   ├── repository/
│   │   └── auth_repo.dart           # AuthRepository abstract class
│   └── repository_impl/
│       └── auth_repo_impl.dart      # Delegates to AuthApi; exports `authRepo` from locator
│
├── router/
│   ├── app_router.dart              # @AutoRouterConfig; defines routes
│   └── app_router.gr.dart           # Generated route classes (e.g. LoginRoute)
│
├── service/
│   └── enc_service.dart             # AES (encrypt package + crypto SHA-256 key derivation)
│
├── ui/                          # Feature-oriented UI
│   └── login/
│       ├── login_page.dart          # @RoutePage; Observer + button triggers login
│       ├── login_store.dart         # MobX store: login action → authRepo
│       └── login_store.g.dart       # Generated MobX code
│
├── util/                        # Helpers (not all wired into main flow)
│   ├── social_login.dart            # Twitter, Apple, Facebook, Firebase patterns (placeholders)
│   ├── media_picker.dart
│   ├── permission_utils.dart
│   ├── date_time_helper.dart
│   ├── utils.dart
│   ├── validtor_custom.dart
│   └── credit_card_validators/
│
├── widget/                      # Shared widgets
│   ├── loading_widget.dart
│   ├── custom_error_widget.dart
│   ├── debouncer.dart
│   └── show_message.dart
│
├── l10n/
│   └── intl_en.arb              # English strings (flutter_intl / intl_utils)
│
└── generated/                   # Code generation output (do not hand-edit)
    ├── l10n.dart
    └── intl/
```

### Assets (`pubspec.yaml`)

- `assets/`, `assets/fonts/`, `assets/image/`, `assets/image/icons/`
- Custom font: **Rotunda** (Bold, weight 700) from `assets/fonts/Rotunda-Bold.otf`
- Repo also contains `assets/style_tokens.json` (referenced as a generic asset root)

---

## Dependencies (runtime)

Grouped by role as declared in `pubspec.yaml`.

### Flutter SDK

| Package | Role |
|---------|------|
| `flutter` | UI framework |
| `flutter_localizations` | Material/Cupertino delegates with app `S` delegate |

### Localization & formatting

| Package | Version (constraint) | Role |
|---------|----------------------|------|
| `intl` | ^0.20.2 | ICU message formatting |
| `intl_utils` | ^2.8.14 | ARB → Dart (`flutter_intl` in pubspec) |

### Core / layout / DI

| Package | Role |
|---------|------|
| `flutter_screenutil` | Responsive sizing (`ScreenUtilInit` in `main.dart`) |
| `get_it` | Service locator (`lib/core/locator/locator.dart`) |

### Navigation

| Package | Role |
|---------|------|
| `auto_route` | Declarative routing; `MaterialApp.router` + `AppRouter.config()` |

### Storage

| Package | Role |
|---------|------|
| `hive_ce` | Fast local key-value; `UserData` adapter; `AppDB` box |
| `hive_ce_flutter` | Flutter integration for Hive |
| `path_provider` | Documents/library path for Hive init (platform-specific) |

### Network

| Package | Role |
|---------|------|
| `http` | Used in `UploadFile` for PUT uploads |
| `dio` | HTTP client; interceptors, base options |
| `retrofit` | Type-safe REST on top of Dio (`AuthApi`) |
| `json_annotation` | Annotations for `json_serializable` models |
| `connectivity_plus` | Offline check in `InternetInterceptors` |
| `pretty_dio_logger` | Debug request/response logging |

### Encryption / crypto

| Package | Role |
|---------|------|
| `encrypt` | AES encryption for request/response bodies in interceptors |
| `crypto` | SHA-256 used in `EncService` to derive key material |

### State management

| Package | Role |
|---------|------|
| `mobx` | Observable state and actions |
| `flutter_mobx` | `Observer` widget in `LoginPage` |

### UI / input / media

| Package | Role |
|---------|------|
| `cached_network_image` | Git dependency (Carapacik fork); image loading |
| `form_field_validator` | Form validation helpers |
| `country_pickers` | Country code UI |
| `webview_flutter` | In-app WebView |
| `google_fonts` | Remote/local font loading |
| `flutter_svg` | SVG assets (flutter_gen integration) |

### Device & security

| Package | Role |
|---------|------|
| `device_info_plus` | Device metadata |
| `flutter_secure_storage` | Secure key/value storage (available for tokens/secrets) |

### Pickers & sharing

| Package | Role |
|---------|------|
| `image_picker` | Gallery/camera |
| `file_picker` | Documents |
| `url_launcher` | Open URLs |
| `share_plus` | System share sheet |

### Permissions & feedback

| Package | Role |
|---------|------|
| `permission_handler` | Runtime permissions |
| `fluttertoast` | Toast messages |

### Networking utility

| Package | Role |
|---------|------|
| `dart_ipify` | Public IP (usable with login/device payloads) |

### Social & identity (stubs / integration-ready)

| Package | Role |
|---------|------|
| `twitter_login` | Twitter OAuth flow (see `util/social_login.dart`) |
| `firebase_auth` | Firebase authentication |
| `google_sign_in` | Google Sign-In |
| `sign_in_with_apple` | Sign in with Apple |
| `flutter_web_auth_2` | OAuth browser flow |
| `flutter_facebook_auth` | Facebook login |
| `uuid` | Nonces/state for OAuth |

---

## Dev dependencies

| Package | Role |
|---------|------|
| `build_runner` | Runs code generators |
| `hive_ce_generator` | Hive type adapters |
| `mobx_codegen` | `login_store.g.dart` |
| `auto_route_generator` | `app_router.gr.dart` |
| `retrofit_generator` | `auth_api.g.dart` |
| `json_serializable` | `*.g.dart` for models and `BaseResponse` |
| `flutter_gen_runner` | Asset class `AppAssets` under `lib/generated/` |
| `flutter_test` | Tests |

---

## Code generation

Regenerate when you change annotated models, Retrofit APIs, MobX stores, routes, or Hive types:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Other tooling (from `pubspec.yaml`):

- **flutter_intl** (`intl_utils`): sync localized strings from ARB.
- **flutter_gen**: `lib/generated/` assets class `AppAssets` (SVG integration enabled).

---

## Implementation — how the app boots

1. **`main.dart`**  
   - `WidgetsFlutterBinding.ensureInitialized()`  
   - `setupLocator()` then `await locator.isReady<AppDB>()`  
   - Portrait-only orientation  
   - `runApp(MyApp(appRouter: locator<AppRouter>()))`  
   - `ScreenUtilInit` wraps `MaterialApp.router` with `routerConfig`, theme, and localization delegates (`S.delegate` + Flutter globals).

2. **`setupLocator()`** (`lib/core/locator/locator.dart`)  
   - Initializes **Hive** on disk (`path_provider`; Android vs iOS directory).  
   - Registers **`UserDataAdapter`** for Hive.  
   - Registers **`AppDB`** as async singleton.  
   - Registers **`AppRouter`** singleton.  
   - **`ApiModule().provides()`** — builds **Dio**, registers Dio + **`AuthApi`**.  
   - Registers **`EncService`** (lazy) with an AES key string (rotate/move to secure config for production).  
   - Registers **`AuthRepoImpl`** factory with `AuthApi`.

3. **Networking** (`lib/core/api/api_module.dart`)  
   - **Base URL**: `APIEndPoints.baseUrl` (currently placeholder `https://www.dummy.com/`).  
   - **Dio**: `ResponseType.plain`, custom `validateStatus` (401/5xx treated as errors).  
   - **Interceptors**: PrettyDioLogger (debug), **CustomInterceptors**, more logging, **InternetInterceptors**.  

4. **Custom interceptors** (`custom_interceptors.dart`)  
   - Forces plain text content type and encrypts JSON body with **`EncService`**; adds `api-key` and encrypted `token` header when present.  
   - On response, decrypts payload and `jsonDecode`s it.  
   - Assumes API contract matches this encryption scheme.

5. **Connectivity** (`internet_interceptor.dart`)  
   - Uses **connectivity_plus**; rejects with a localized “no internet” message from **`S`**.

6. **Auth flow**  
   - **`AuthApi`** (Retrofit): `POST /user_authentication/signin`, `POST /user_authentication/logout`.  
   - **`AuthRepoImpl`** calls **`AuthApi`**.  
   - **`LoginStore`** builds **`LoginRequestModel`**, calls **`authRepo`** (global from `auth_repo_impl.dart`), updates **`UserData`** / error / loading.  
   - **`LoginPage`** uses **`Observer`** to show loading, success name, or error.

7. **Persistence** (`app_db.dart`)  
   - Single Hive box for flags and **`UserData`** (`user` key), token, FCM, cart count, etc.  
   - **`logout()`** clears token and login flags.

---

## Supporting modules (reference)

| Area | Files | Notes |
|------|--------|--------|
| API envelope | `core/api/base_response/base_response.dart` | Generic `BaseResponse<T>` with `code` / `message` / `data`; `isOk` checks codes `1` or `2`. |
| Errors | `core/exceptions/dio_exception_util.dart` | Localized Dio mapping; on **401** calls `appRouter.replaceAll([const StarterRoute()])`. **`StarterRoute` is not defined** in the current `app_router.gr.dart` (only **`LoginRoute`** exists). Fix this before using this helper, or it will not compile when imported. |
| Uploads | `data/remote/upload_file.dart` | **`http`** PUT binary body. |
| Social | `util/social_login.dart` | Example Twitter/Apple/Facebook/Firebase flows; keys and URLs are placeholders. |
| Widgets | `lib/widget/*` | Reusable loading/error/debounce/toast helpers. |
| Validators / media | `util/*` | Credit card helpers, custom validators, `media_picker`, `permission_utils`. |

---

## Configuration checklist for a real backend

- Set **`APIEndPoints.baseUrl`** (and paths if needed) to your environment URLs.  
- Align **encryption** (AES key, IV, header names) with server expectations or disable/adjust interceptors if the API is plain JSON.  
- Move **secrets** (AES key, OAuth client IDs) out of source control; use **flutter_secure_storage** or build flavors / `--dart-define`.  
- Run **codegen** after schema or route changes.  
- Configure **Firebase**, **Google**, **Facebook**, **Apple**, and **Twitter** consoles to match `social_login.dart` when you enable those flows.

---

## Version

Document generated from project **1.0.0+1** (`pubspec.yaml`). Dependency versions follow the caret constraints in that file unless you pin them in `pubspec.lock`.
