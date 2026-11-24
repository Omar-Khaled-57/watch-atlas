# Changelog

The project's release notes are maintained in [`../CHANGELOG.md`](../CHANGELOG.md),
which follows Keep a Changelog. This page points to it and summarises the
recorded releases; it is not a second changelog.

| Version | Date recorded in `CHANGELOG.md` | Summary |
| --- | --- | --- |
| `0.12.0` | 2026-07-28 | Removed Firebase push, social and moderation features; spacing overhaul; OAuth flow changes; local-only notifications; Windows icon rebuild |
| `0.11.0` | 2026-07-27 | Fixed uninitialized singleton providers, replaced silent catches, added retry backoff, input sanitization, offline banner, SQLite-backed cache, privacy settings, list collaboration, desktop shortcuts and Windows installer |
| `0.10.0` | 2026-07-22 | Removed secrets from bundled assets, replaced `flutter_dotenv` with compile-time defines, enabled Android R8/ProGuard, hardened `.gitignore`, added this changelog |
| `0.9.0` | 2026-07-01 | Initial recorded feature set: tracking, hybrid recommendations, reviews, lists, social/moderation (later removed), analytics, discover, notifications, offline sync, adaptive UI, localisation and auth |

Current package version is `0.12.0+1` in
[`../pubspec.yaml`](../pubspec.yaml), matching `AppConstants.appVersion` in
`lib/core/constants/app_constants.dart`.

Related non-release documents:

- [`../dev/v1.0.0-plan.md`](../dev/v1.0.0-plan.md) — planning notes toward
  `1.0.0`, not release notes.
- [`../AUDIT.md`](../AUDIT.md) — quality audit dated `2026-07-23` for
  `0.10.0+1`; it predates the `0.12.0` removals.
- [`../dev/release/`](../dev/release/) — built artifacts for recorded versions.

## Sources

- `../CHANGELOG.md`, `../pubspec.yaml`, `../lib/core/constants/app_constants.dart`,
  `../dev/v1.0.0-plan.md`, `../AUDIT.md`
