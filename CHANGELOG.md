# Changelog

All notable changes to WatchAtlas are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

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
