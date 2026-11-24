# Product

WatchAtlas is a cross-platform media companion for tracking movies, TV shows
and anime, finding recommendations, maintaining lists and writing reviews. The
Flutter app is the full product implementation; the separate Expo app in
`../../watch-atlas-rn/` is a UI prototype and is documented on its own.

The product-facing overview and badges live in [`../README.md`](../README.md).
This page inventories what the code actually provides and calls out what it
does not.

## Problem and audience

The app targets viewers who want one place for: keeping a watch history and
progress, discovering titles across TMDB and AniList catalogues, curating
lists, and reviewing what they have seen. It supports English and Arabic
(`lib/l10n/app_en.arb`, `lib/l10n/app_ar.arb`) and adapts its shell between a
bottom navigation bar and a desktop navigation rail
(`lib/router/app_router.dart`, `ShellScaffold`).

## What it does today

All routes below are declared in [`../lib/router/app_router.dart`](../lib/router/app_router.dart).

| Area | Routes | Implementation |
| --- | --- | --- |
| Onboarding and auth | `/splash`, `/auth`, `/onboarding` | `lib/features/splash/`, `lib/features/auth/`, `lib/core/services/auth_service.dart` |
| Home | `/` | `lib/features/home/home_screen.dart` and `lib/features/home/providers/` |
| Discover | `/discover` | `lib/features/discover/` plus TMDB/AniList services in `lib/core/services/` |
| Tracking | `/tracking` | `lib/features/tracking/`, `lib/features/tracking/widgets/quick_status_dialog.dart` |
| Lists | `/lists`, `/lists/:id` | `lib/features/lists/` (list detail, all items, collage covers, create dialog) |
| Media detail | `/media/:type/:id` | `lib/features/media/media_details_screen.dart` and `lib/features/media/widgets/` |
| Recommendations | `/recommendations` | `lib/features/recommendations/`, `lib/core/services/recommendation_engine.dart` |
| Reviews | `lib/features/reviews/reviews_screen.dart` is wired into media detail widgets | `lib/features/reviews/`, `lib/features/media/widgets/reviews_section.dart` |
| Profile | `/profile`, `/profile/edit`, `/profile/:id` | `lib/features/profile/` |
| Analytics | `/analytics`, `/analytics/filtered` | `lib/features/analytics/` |
| Notifications | `/notifications`, `/notifications/settings` | `lib/features/notifications/` |
| Legal and attribution | `/privacy`, `/terms`, `/licenses`, `/attribution` | `lib/features/legal/` |

### Recommendation engine

`lib/core/config/recommendation_config.dart` defines 16 `RecCategory` values in
`lib/core/models/recommendation_models.dart` and the hybrid weights (0.45
behaviour, 0.30 content, 0.20 collaborative, 0.05 demographic), query limits,
curated-feed thresholds, diversity constraints and a 24-hour cache TTL.
`lib/core/services/recommendation_engine.dart` generates personalised and
curated feeds and writes them through `lib/core/repositories/recommendation_repository.dart`.
`lib/features/recommendations/providers/recommendation_providers.dart` exposes
them to the UI.

### Offline behaviour

`lib/core/services/cache_service.dart` keeps a local SQLite cache
(`watch_atlas_cache.db`) via `sqflite_common_ffi` for user media, media metadata
and lists. `lib/core/services/sync_service.dart` persists queued mutations in
`SharedPreferences` under `sync_queue`, retries them with backoff, and drains
the queue on reconnect or on the 15-minute interval from
`lib/core/constants/app_constants.dart`.

## Explicit non-goals and known gaps

- Social features (followers, activity feeds, friend recommendations, `/social`)
  and moderation (report queue, roles, `/moderation`) were **removed** in
  `0.12.0` according to [`../CHANGELOG.md`](../CHANGELOG.md), even though some
  older notes in [`../AUDIT.md`](../AUDIT.md) still describe them.
- Push notifications were removed in `0.12.0`; the current notification
  service is local-only via `flutter_local_notifications`, while the in-app
  centre reads the Supabase `notifications` table.
- The `RecCategory` enum lists 16 categories, but
  `lib/core/services/recommendation_engine.dart` does not build a feed for
  every enum value (for example `friendsAlsoSaved`, `awardWinners`,
  `underratedClassics` and `upcomingReleases` are not generated there).
- No server-side component lives in this directory. Supabase schema, migrations
  and grants are SQL files under [`../supabase/`](../supabase/) and must be
  applied to an external Supabase project.
- The root `test/widget_test.dart` is a placeholder smoke test; see
  [testing.md](./testing.md) for the real suite inventory.

## Sources

- `../README.md`, `../CHANGELOG.md`, `../pubspec.yaml`
- `../lib/router/app_router.dart`, `../lib/core/config/recommendation_config.dart`
- `../lib/core/models/recommendation_models.dart`, `../lib/core/services/cache_service.dart`,
  `../lib/core/services/sync_service.dart`
