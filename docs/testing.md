# Testing

## Runner and commands

The project uses `flutter_test` and `integration_test` from
[`../pubspec.yaml`](../pubspec.yaml). Commands below appear verbatim in the
README, [`../dev/commands.md`](../dev/commands.md),
[`../scripts/test.sh`](../scripts/test.sh) or
[`../.github/workflows/ci.yml`](../.github/workflows/ci.yml).

| Command | Source | What it runs |
| --- | --- | --- |
| `flutter test` | README, `dev/commands.md` | `test/` unit and widget tests |
| `flutter test --coverage` | `dev/commands.md`, CI `test` job | Same tests with `coverage/lcov.info` output |
| `genhtml coverage/lcov.info -o coverage/html` | README, `dev/commands.md`, `scripts/test.sh` | HTML coverage report (requires lcov installed) |
| `flutter analyze` | CI `analyze` job | Static analysis |
| `dart format --set-exit-if-changed .` | CI `analyze` job | Formatting check |

`scripts/test.sh` wraps the test and coverage-report commands and skips HTML
generation with a message when `genhtml` is unavailable. CI's `test` job uploads
`coverage/lcov.info` to Codecov with `fail_ci_if_error: false`.

## Suites present

| Location | Files | Genuine coverage |
| --- | --- | --- |
| `test/unit/` | 17 `*_test.dart` files | Models (`media_model`, `user_model`, recommendation models), enums, `recommendation_config`, `app_constants`, `auth_validation`, `router_redirect`, `cache_service`/`cache_models`, `notification_preferences`, `string_sanitization`, `number_extensions`, WCAG contrast helpers and accessibility colours |
| `test/widget/` | 2 files: `media_card_test.dart`, `recommendation_card_test.dart` | Those two shared widgets |
| `test/widget_test.dart` | 1 file | Placeholder smoke test that pumps a `MaterialApp` with a `Text('WatchAtlas')`; it does not launch the app |
| `integration_test/` | 1 file: `app_test.dart` | App launch (finds `Scaffold`) and bottom-nav taps when a `NavigationBar` is present |

Notable filenames do not always match their subject: `test/unit/isar_collections_test.dart`
imports `lib/core/services/cache_models.dart` and exercises the SQLite cache
models; there is no ISAR dependency in `pubspec.yaml`.

## What is not covered

- No unit tests were found for `RecommendationEngine`, `SyncService`,
  `BehaviorService`, `AuthService`, `TmdbService` or `AniListService`.
- No screen-level widget tests were found.
- No CI job runs `integration_test/app_test.dart`; CI runs
  `flutter test --coverage` only.
- No coverage report is committed: `coverage/` is absent from the tree and
  gitignored, and no percentage is recorded in a checked-in result file.
  [`../AUDIT.md`](../AUDIT.md) contains qualitative scores and a *historical*
  test inventory for `0.10.0+1` (13 unit + 2 widget tests, no integration
  tests), which no longer matches the current file counts above.
- [`../CHANGELOG.md`](../CHANGELOG.md) states "185 passing" for `0.11.0`; no
  committed test output substantiates that number, so it is not repeated as a
  current count here.

## Sources

- `../pubspec.yaml`, `../README.md`, `../dev/commands.md`, `../scripts/test.sh`,
  `../.github/workflows/ci.yml`, `../AUDIT.md`, `../CHANGELOG.md`
- `../test/`, `../integration_test/`, `../lib/core/services/cache_models.dart`
