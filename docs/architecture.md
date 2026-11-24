# Architecture

## Stack and versions

Declared in [`../pubspec.yaml`](../pubspec.yaml):

| Layer | Package / constraint |
| --- | --- |
| Framework | Flutter (SDK dependency), Dart SDK `^3.11.3` |
| State | `flutter_riverpod ^3.3.1`, `riverpod_annotation ^4.0.2` |
| Routing | `go_router ^17.3.0` |
| Networking | `dio ^5.7.0`, `connectivity_plus ^7.2.0` |
| Models and codegen | `freezed_annotation ^3.0.0`, `json_annotation ^4.9.0`, `build_runner ^2.4.14`, `freezed ^3.0.0`, `json_serializable ^6.9.5`, `riverpod_generator ^4.0.3` |
| Local storage | `sqflite_common_ffi ^2.3.0`, `path_provider ^2.1.5`, `shared_preferences ^2.3.5` |
| Backend | `supabase_flutter ^2.16.0`, `postgrest ^2.8.0` |
| Media, charts, UI | `cached_network_image`, `flutter_animate`, `lottie`, `shimmer`, `dynamic_color`, `fl_chart ^1.2.0`, `infinite_scroll_pagination` |
| Notifications | `flutter_local_notifications ^22.0.1` (local-only) |
| Utilities | `intl`, `url_launcher`, `share_plus`, `image_picker` |
| Tests | `flutter_test`, `integration_test`, `mocktail`, `flutter_lints ^6.0.0` |

There is no ISAR dependency in `pubspec.yaml` and no `isar` import in `lib/`;
the offline cache is SQLite via `sqflite_common_ffi`. The `isar_collections_test.dart`
filename is historical (it tests `lib/core/services/cache_models.dart`).

## Entry points and process model

- `lib/main.dart`: `WidgetsFlutterBinding.ensureInitialized()`,
  `sqfliteFfiInit()`, a startup warning when `Secrets.isConfigured` is false,
  `SupabaseService.instance.init()`, then `ProviderScope(child: WatchAtlasApp(...))`.
  A failed Supabase init renders an "Unable to Connect" screen instead of the
  routed app.
- `lib/router/app_router.dart`: one `GoRouter` with `refreshListenable` driven
  by auth/init providers, `initialLocation: '/splash'`, and redirects for
  splash, auth, onboarding and public legal routes.
- `ShellScaffold` uses `StatefulShellRoute.indexedStack`; at `maxWidth >= 1024`
  it renders a `NavigationRail` and Ctrl/Cmd+1…5 shortcuts, otherwise a
  `NavigationBar`.
- The app runs as one Flutter process per platform target. Sync is an in-app
  `Timer.periodic` plus a connectivity listener in `lib/core/services/sync_service.dart`,
  not an OS-level background worker.

## Directory map

```
lib/
  main.dart                 app bootstrap and error screen
  router/app_router.dart    routes, redirects, adaptive shell
  core/
    config/                 Secrets, RecommendationConfig
    constants/              API bases, endpoints, app constants, colours, dimensions
    extensions/             context, date, number and string helpers
    models/                 enums and recommendation-engine models
    providers/              app-wide Riverpod providers and DI wiring
    repositories/           RecommendationRepository (Supabase + cache rows)
    services/               Supabase, auth, TMDB, AniList, cache, sync,
                            connectivity, behaviour, recommendations, notifications
    shared/                 reusable widgets (cards, carousels, dialogs, etc.)
    theme/                  AppTheme (Material 3 light/dark)
  features/                 one folder per product area; each holds screens,
                            providers/ and often widgets/
  l10n/                     ARB sources and generated localizations
  models/                   Freezed/JsonSerializable domain models
test/                       unit/, widget/, root smoke test
integration_test/           app launch and navigation tests
supabase/                   schema.sql, migration.sql, grants*.sql,
                            recommendation_tables.sql
scripts/                    analyze.sh, test.sh, mock_data.dart,
                            register_windows_scheme.ps1
windows/installer/          Inno Setup script and .iss definition
```

## Module responsibilities and data flow

1. **UI** (`lib/features/*`, `lib/core/shared/`) reads providers with
   `ref.watch` and calls notifiers or services for actions.
2. **State** (`lib/core/providers/`, feature `providers/` folders) holds auth
   status, theme, locale, lists, tracking, recommendations and notification
   preferences. `lib/core/providers/service_providers.dart` returns `.instance`
   singletons for Supabase, TMDB, AniList, auth, connectivity, notifications and
   sync, while `cacheServiceProvider` and `behaviorServiceProvider` construct
   instances (the latter receives Supabase and auth via DI).
3. **Remote services** (`lib/core/services/`) talk to Supabase (auth, Postgres
   tables, storage buckets `avatars` and `banners`), TMDB REST
   (`https://api.themoviedb.org/3`, images at `https://image.tmdb.org/t/p`) and
   AniList GraphQL (`https://graphql.anilist.co`). Base URLs are in
   `lib/core/constants/api_constants.dart` and endpoints in `api_endpoints.dart`.
4. **Recommendation pipeline**: `BehaviorService` records `user_events`;
   `RecommendationRepository` reads saved/viewed IDs, profiles, similarity and
   the `recommendations_cache` table; `RecommendationEngine` blends and
   re-ranks results for UI providers.
5. **Local/offline path**: `CacheService` writes `user_media`, `media` and
   `user_lists` tables in `watch_atlas_cache.db`; `SyncService` stores queued
   mutations in `SharedPreferences` and replays them against Supabase.
   `ConnectivityService` drives the offline banner in `lib/features/tracking/tracking_screen.dart`.

## Integration and storage boundaries

| Boundary | Files | Notes |
| --- | --- | --- |
| Supabase | `lib/core/services/supabase_service.dart`, `supabase/*.sql` | External project; SQL files are not applied by the app at runtime |
| TMDB / AniList | `lib/core/services/tmdb_service.dart`, `anilist_service.dart` | Keys injected at compile time; see [configuration.md](./configuration.md) |
| Device storage | `lib/core/services/cache_service.dart`, `sync_service.dart`, `lib/core/providers/settings_providers.dart` | SQLite cache, SharedPreferences queue, theme/locale/notification settings |
| Native platforms | `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/` | Flutter platform runners; Windows scheme registration in `scripts/register_windows_scheme.ps1` |
| CI | `.github/workflows/ci.yml` | Analyze, test, web, Android and Windows jobs |

## Sources

- `../pubspec.yaml`, `../lib/main.dart`, `../lib/router/app_router.dart`
- `../lib/core/services/` (supabase, cache, sync, recommendation, tmdb, anilist),
  `../lib/core/providers/`
- `../.github/workflows/ci.yml`, `../supabase/`
