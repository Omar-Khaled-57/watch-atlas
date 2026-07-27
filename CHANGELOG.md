# Changelog

All notable changes to WatchAtlas are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [0.11.0] - 2026-07-27

### Fixed

- **DI providers returned uninitialized singletons.** `supabaseServiceProvider`, `tmdbServiceProvider`, and `anilistServiceProvider` now return their respective `.instance` singletons instead of creating new instances. This fixes lists not persisting and media not being added to tracking.
- **13 silent `catch (_)` blocks** replaced with `debugPrint` containing context-specific error messages across `BehaviorService`, `SyncService`, `AuthService`, `RecommendationRepository`, `HomeProviders`, `DiscoverProviders`, `ListsProviders`.
- **Exponential backoff** added to `SyncService` for failed sync retries.

### Added

- **Input sanitization.** `sanitizeUserInput()` extension strips HTML tags and collapses whitespace. Applied to profile display name, bio, and list title/description.
- **Offline banner.** `TrackingScreen` shows a `MaterialBanner` when the device is offline, with retry button.
- **Persistent cache.** `CacheService` backed by SQLite via `sqflite_common_ffi` for offline-first data. `UserMediaNotifier` serves cached data immediately, then refreshes from network.
- **Notification bell** icon with unread badge on the home screen header.
- **Privacy settings** (public/private profile) on the profile screen.
- **List collaboration** — invite collaborators via dialog in list detail screen.
- **Analytics promotion** — analytics button added to the tracking screen app bar.
- **Desktop keyboard shortcuts** — Ctrl+1 through Ctrl+5 switch nav tabs.
- **Inno Setup installer** for Windows (`windows/installer/`).
- **Firebase config files** added (`google-services.json`, `GoogleService-Info.plist`).
- **Tests:** 185 passing — unit tests for sanitization, cache, WCAG contrast, router redirects, recommendation models, auth validation, number extensions, app constants, media enums; widget tests for MediaCard, RecommendationCard, FeedbackButton; integration test for app launch and nav.

### Changed

- `behaviorServiceProvider` centralized in `service_providers.dart` with proper DI (Supabase + Auth injected).
- All feature code using `BehaviorService.instance` migrated to `ref.read(behaviorServiceProvider)`.
- `reviews_screen.dart` migrated from `Supabase.instance.client` to `ref.read(supabaseServiceProvider).client`.
- `auth_providers.dart` migrated from `NotificationService.instance.clearToken()` to `ref.read(notificationServiceProvider).clearToken()`.
- Unused imports cleaned across `recommendation_card.dart`, `recommendation_row.dart`, `reviews_screen.dart`, `auth_providers.dart`.
- `.gitignore` expanded: Firebase configs, platform generated files, dev build outputs, `ephemeral/` dirs.
- Version bumped to `0.11.0+1`.

---

## [0.10.0] - 2026-07-22

### Security

- **Removed secrets from release binaries.** `.env` is no longer bundled as a Flutter asset. Secrets are now injected at compile time via `--dart-define` or `--dart-define-from-file`.
- **Removed `flutter_dotenv` dependency.** Replaced with a `Secrets` class using `String.fromEnvironment()` — no runtime file loading, no binary extraction risk.
- **Enabled Android R8/ProGuard minification.** Release builds now ship minified, obfuscated, and resource-shrunk.
- **Added `proguard-rules.pro`** with keep rules for Flutter, Supabase, Freezed, and Firebase.
- **Hardened `.gitignore`.** Added rules for `android/key.properties`, `*.jks`, `*.keystore`, `*.p12`, `*.mobileprovision`, and `secrets.json`.
- **Removed tracked signing artifacts.** Old `upload-keystore.jks.old` removed from git history.

### Added

- `secrets.json.example` — template for local development with `--dart-define-from-file`.
- `.env.example` — reference for environment variable names.
- `CHANGELOG.md` — this file.

### Changed

- Replaced `.env`-based configuration with compile-time `--dart-define` injection across `SupabaseService`, `TmdbService`, and `main.dart`.
- Updated README with new build/run instructions using `--dart-define-from-file=secrets.json`.
- Startup now warns if secrets are not configured instead of silently failing.

### Developer Migration

```bash
# Before
flutter run

# After
cp secrets.json.example secrets.json
# Fill in secrets.json with your credentials
flutter run --dart-define-from-file=secrets.json

# Release builds
flutter build apk --release --dart-define-from-file=secrets.json
```

---

## [0.9.0] - 2026-07-01

### Added

- Media tracking (watching, completed, plan-to-watch, on-hold, dropped)
- Hybrid recommendation engine (behaviour, content, collaborative, demographic)
- Rating & reviews (1-10 scale, spoiler tags, threaded comments)
- Public, private, and collaborative lists with drag-to-reorder
- Social features (follow users, activity feeds, friend recommendations)
- Analytics dashboard (genre distribution, weekly/monthly/yearly charts)
- Discover page with search, filters, and infinite scroll
- Firebase push notifications + in-app notification centre
- Moderation system with report queue and role-based access
- Offline-first architecture with background sync
- Adaptive UI (mobile bottom nav, desktop navigation rail)
- Dark & light themes with dynamic colour support
- Arabic and English localisation
- Magic-link, Google, and Apple sign-in via Supabase
- Privacy policy, terms of service, and OSS licence screens
