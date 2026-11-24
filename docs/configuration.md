# Configuration

## Compile-time secrets

`lib/core/config/secrets.dart` reads six values with `String.fromEnvironment`
and an empty-string default. `Secrets.isConfigured` requires only
`SUPABASE_URL`, `SUPABASE_ANON_KEY` and `TMDB_API_KEY`. Templates exist at
[`../secrets.json.example`](../secrets.json.example) and
[`../.env.example`](../.env.example); local `.env` and `secrets.json` files are
present in this working tree but are gitignored — their contents are not
documented here.

| Define / key | Read by | Default | Purpose |
| --- | --- | --- | --- |
| `SUPABASE_URL` | `Secrets.supabaseUrl`, `SupabaseService.init()` | `''` | Supabase project URL |
| `SUPABASE_ANON_KEY` | `Secrets.supabaseAnonKey`, `SupabaseService.init()` (passed as `publishableKey`) | `''` | Supabase publishable/anon key |
| `TMDB_API_KEY` | `Secrets.tmdbApiKey` | `''` | TMDB API requests |
| `TMDB_ACCESS_TOKEN` | `Secrets.tmdbAccessToken` | `''` | TMDB access token |
| `ANILIST_CLIENT_ID` | `Secrets.anilistClientId` | `''` | AniList GraphQL client |
| `ANILIST_CLIENT_SECRET` | `Secrets.anilistClientSecret` | `''` | AniList GraphQL secret |

Supply them with `--dart-define-from-file=secrets.json` or individual
`--dart-define` flags as shown in [development.md](./development.md). CI
builds use the placeholder values declared in
[`../.github/workflows/ci.yml`](../.github/workflows/ci.yml) for
`SUPABASE_URL`, `SUPABASE_ANON_KEY` and `TMDB_API_KEY`.

## Config files

| File | What it controls |
| --- | --- |
| `pubspec.yaml` | Package name `watch_atlas`, version `0.12.0+1`, Dart SDK `^3.11.3`, dependencies, assets and `flutter_launcher_icons` colours (`#0F111A`, `#E11D48`) |
| `l10n.yaml` | ARB directory `lib/l10n`, template `app_en.arb`, output `app_localizations.dart`, locales `en` and `ar` |
| `analysis_options.yaml` | Includes `package:flutter_lints/flutter.yaml` |
| `web/manifest.json` | Web app name, standalone display, `#0F111A` background, `#E11D48` theme, portrait orientation, icons |
| `android/key.properties`, `android/app/*.keystore` | Local release signing inputs, read by `android/app/build.gradle.kts`; present locally but gitignored |
| `android/app/google-services.json` | Legacy Firebase config left in the tree; `pubspec.yaml` no longer has Firebase dependencies and the v1.0.0 plan documents their removal |
| `windows/installer/watch_atlas.iss`, `windows/installer/build_installer.ps1` | Inno Setup packaging definition and build script |
| `supabase/*.sql` | Remote schema, migrations, grants and recommendation tables — applied externally, not at app startup |

## Fixed constants

`lib/core/constants/api_constants.dart` and `api_endpoints.dart` define TMDB
base `https://api.themoviedb.org/3`, TMDB images `https://image.tmdb.org/t/p`,
and AniList `https://graphql.anilist.co` plus TMDB endpoint paths.

`lib/core/constants/app_constants.dart` defines: app name `WatchAtlas`, app
version `0.12.0`, search debounce `400ms`, cache duration `24h`, sync interval
`15min`, page size `20`, max retries `3`, and UI dimensions.

`lib/core/config/recommendation_config.dart` holds recommendation weights
(0.45 / 0.30 / 0.20 / 0.05), per-category limits, curated thresholds, diversity
ratios and a `24h` recommendation cache TTL.

## Local storage keys and settings

| Store | Key / table | Written by | Default / notes |
| --- | --- | --- | --- |
| SharedPreferences | `theme_mode` | `lib/core/providers/settings_providers.dart` | `light`, `dark` or `system` (initial `system`) |
| SharedPreferences | `locale` | same | `en` or `ar` (initial `en`) |
| SharedPreferences | `sync_queue` | `lib/core/services/sync_service.dart` | JSON-encoded queued mutations |
| SharedPreferences | `privacy_public_profile` | `lib/features/profile/providers/privacy_provider.dart` | `true` |
| SharedPreferences | `privacy_show_activity` | same | `true` |
| SQLite `watch_atlas_cache.db` | `user_media`, `media`, `user_lists` | `lib/core/services/cache_service.dart` | Schema version 1; survives restarts |
| Supabase `profiles.notification_preferences` | `new_followers`, `activity_updates`, `recommendations`, `listUpdates` mapped to `list_updates`, `weekly_digest`, `marketing_emails` | `lib/features/notifications/providers/notification_preferences_provider.dart` | All `true` except `marketingEmails` (`false`); remote, not local |

`showForYouSectionProvider` in `settings_providers.dart` is an in-memory flag
defaulting to `true`; no persisted key was found for it.

## Security notes

- Never commit `secrets.json`, `.env`, `android/key.properties`, keystores or
  Firebase config files; `.gitignore` excludes them and ships the `.example`
  templates instead.
- `AUDIT.md` (v0.10.0) records that `--dart-define` values are embedded in
  release binaries and can be extracted; treat the API keys as client-side
  values, not server secrets.
- Supabase RLS and grants are defined in `supabase/*.sql`; client-side route
  redirects in `app_router.dart` are not a substitute for server-side policy.
- The Windows OAuth helper registers a per-user URL protocol under
  `HKEY_CURRENT_USER\Software\Classes\io.supabase.flutter`; see
  `scripts/register_windows_scheme.ps1`.

## Sources

- `../lib/core/config/secrets.dart`, `../lib/core/config/recommendation_config.dart`,
  `../lib/core/constants/api_constants.dart`, `../lib/core/constants/app_constants.dart`
- `../lib/core/providers/settings_providers.dart`,
  `../lib/features/profile/providers/privacy_provider.dart`,
  `../lib/features/notifications/providers/notification_preferences_provider.dart`
- `../lib/core/services/cache_service.dart`, `../lib/core/services/sync_service.dart`
- `../pubspec.yaml`, `../l10n.yaml`, `../web/manifest.json`, `../.env.example`,
  `../secrets.json.example`, `../.gitignore`, `../AUDIT.md`, `../.github/workflows/ci.yml`
