# Development

## Prerequisites

- Flutter tooling and a Dart SDK satisfying `sdk: ^3.11.3` from
  [`../pubspec.yaml`](../pubspec.yaml). The repo does not pin a Flutter version.
- A Supabase project with the SQL in [`../supabase/`](../supabase/) applied,
  plus TMDB credentials; AniList client ID/secret are optional for anime
  features. See [configuration.md](./configuration.md).
- `lcov`/`genhtml` only if you want the HTML coverage report described in
  [`../scripts/test.sh`](../scripts/test.sh).

## Install and run

```bash
cp secrets.json.example secrets.json
# fill in secrets.json with local credentials
flutter pub get
flutter run --dart-define-from-file=secrets.json
```

Individual compile-time defines are also supported (verbatim from
[`../README.md`](../README.md)):

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key \
  --dart-define=TMDB_API_KEY=your-api-key
```

Supabase SQL files are applied in the order given in the README: `schema.sql`,
`migration.sql`, `grants_core.sql`, `grants.sql`, `recommendation_tables.sql`.
The `delete_my_account()` RPC in `migration.sql` is required by the Delete
Account action.

## Command reference

Commands below are taken from the README, [`../dev/commands.md`](../dev/commands.md),
[`../scripts/`](../scripts/), and [`../.github/workflows/ci.yml`](../.github/workflows/ci.yml).

| Command | Purpose |
| --- | --- |
| `flutter pub get` | Fetch dependencies |
| `dart run build_runner build --delete-conflicting-outputs` | Regenerate Freezed / JSON / Riverpod code |
| `flutter analyze` | Static analysis (also CI `analyze` job) |
| `dart format --set-exit-if-changed .` | Format check (CI `analyze` job) |
| `flutter test` | Unit and widget tests |
| `flutter test --coverage` | Tests with coverage (CI `test` job) |
| `genhtml coverage/lcov.info -o coverage/html` | HTML coverage report |
| `flutter run --dart-define-from-file=secrets.json` | Run with local secrets |
| `flutter build apk --release --dart-define-from-file=secrets.json` | Android APK |
| `flutter build web --release --dart-define-from-file=secrets.json` | Web build |
| `flutter build windows --release --dart-define-from-file=secrets.json` | Windows build |
| `iscc windows/installer/watch_atlas.iss` | Windows installer from Inno Setup definition |
| `.\windows\installer\build_installer.ps1` | Build and package Windows release (PowerShell script header) |
| `flutter build windows --debug` | Prerequisite for `scripts/register_windows_scheme.ps1` |

`scripts/analyze.sh` and `scripts/test.sh` wrap the analysis/format and
test/coverage commands above. CI adds three placeholder-defined release builds
using `--dart-define=SUPABASE_URL=...`, `SUPABASE_ANON_KEY=...` and
`TMDB_API_KEY=...`; see [deployment.md](./deployment.md).

## Repository structure

See [architecture.md](./architecture.md) for the full `lib/` map. In short:
`lib/core/` holds config, constants, services, providers, repositories and
shared widgets; `lib/features/` holds screens with co-located `providers/` and
`widgets/`; `lib/models/` holds Freezed models; `lib/l10n/` holds ARB sources;
`test/` and `integration_test/` hold tests; `supabase/` holds SQL; `dev/` and
`windows/installer/` hold build notes and packaging scripts.

## Conventions grounded in the repo

- New screens live under `lib/features/<area>/` and are registered in
  `lib/router/app_router.dart`; the shell uses `StatefulShellRoute` branches
  for the five main tabs.
- State is exposed through Riverpod providers; feature providers sit beside
  the feature they serve, app-wide providers under `lib/core/providers/`.
- Models use `freezed_annotation` and `json_annotation`; generated
  `*.freezed.dart` and `*.g.dart` files are checked in, so regenerate with
  `build_runner` after model edits.
- Localisation uses ARB files with `app_en.arb` as template and `en`/`ar`
  locales (`l10n.yaml`, `flutter: generate: true` in `pubspec.yaml`).
- Analyzer settings come from `package:flutter_lints/flutter.yaml`
  (`analysis_options.yaml`).

## How to add a feature

1. Add the screen/widget under the matching `lib/features/<area>/` folder and
   any shared widget under `lib/core/shared/`.
2. Add or update providers next to the feature; inject services via
   `lib/core/providers/service_providers.dart` rather than constructing remote
   clients inline.
3. Register the route in `lib/router/app_router.dart` and decide whether it
   belongs in a shell branch or as a standalone `GoRoute`.
4. Add ARB keys to both `lib/l10n/app_en.arb` and `app_ar.arb`, then run
   build_runner if models changed.
5. Add a test under `test/unit/` or `test/widget/`, then run `flutter analyze`,
   `dart format --set-exit-if-changed .` and `flutter test`.

## Troubleshooting evidenced in the repo

- **`[WatchAtlas] WARNING: Secrets not configured`** — emitted by `lib/main.dart`
  when `Secrets.isConfigured` (Supabase URL, anon key, TMDB key) is not set;
  supply `--dart-define-from-file=secrets.json` or individual defines.
- **"Unable to Connect" screen** — shown when `SupabaseService.init()` throws;
  check the Supabase URL/key and network access.
- **Desktop Google/Apple sign-in** — desktop OAuth uses port `5555`; add
  `http://localhost:5555` to Supabase redirect URLs. On Windows,
  `scripts/register_windows_scheme.ps1` registers `io.supabase.flutter://` and
  reminds you to add `io.supabase.flutter://callback` to Supabase redirects.
- **Ignored local files** — `dev/`, `watch_atlas--dev/`, `secrets.json`, `.env*`,
  signing keys and Firebase config files are excluded by `.gitignore`; they may
  exist locally without being tracked.

## Sources

- `../pubspec.yaml`, `../README.md`, `../dev/commands.md`, `../l10n.yaml`,
  `../analysis_options.yaml`, `../.gitignore`
- `../lib/main.dart`, `../lib/core/config/secrets.dart`,
  `../lib/core/providers/service_providers.dart`,
  `../scripts/analyze.sh`, `../scripts/test.sh`,
  `../scripts/register_windows_scheme.ps1`, `../.github/workflows/ci.yml`
