# WatchAtlas Comprehensive Audit Report

**App**: WatchAtlas v0.10.0+1
**SDK**: Flutter ^3.11.3
**Stack**: Riverpod 3.3.1 · GoRouter 17.3.0 · Supabase 2.16.0 · Freezed 3.0.0 · Firebase (messaging, analytics) · TMDB + Anilist APIs
**Date**: 2026-07-23 (re-audit v2)

---

## 1. Accessibility (a11y)

### What's Good
- `MediaCard`, `UserAvatar`, `ExpandableText`, `EmptyState`, `AppDialog`, `SectionHeader`, `RatingDisplay`, `_SettingsTile` all use `Semantics` wrappers with meaningful labels.
- `RatingDisplay._StarRating` exposes "Rating: X out of 10, N votes" semantics.
- `TappableStarRating` exposes "Tap to rate, currently N out of 5 stars" semantics.
- `HorizontalCarousel` uses `MouseRegion` with grab/grabbing cursors for desktop.
- `ProfileScreen` and extracted `SettingsTile`/`InfoRow` (in `profile_widgets.dart`) have `Semantics(button: ..., label: ...)` with dynamic title + subtitle.
- App uses `EdgeInsetsDirectional` extensively (good for RTL/Arabic support).
- `ReviewCard`, `ListEntrySection`, `SidePanel`, `ReviewsSection`, `GenreChips`, `RatingRow`, `ActionButtons`, `TrailersSection`, `CrewSection`, `CastSection`, `MediaRowSection` all wrapped in `Semantics`.
- `list_detail_screen.dart`, `lists_screen.dart`, `notifications_screen.dart` — all IconButtons now have `tooltip`.
- `ActivityTile`, `NotificationTile`, `ModerationScreen` user cards all use `Semantics`.

### Issues

| Severity | File:Line | Issue |
|----------|-----------|-------|
| **Medium** | `home_screen.dart:276` | Semantics label `'Clear search'` is hardcoded English, not l10n. |
| **Medium** | `home_screen.dart:286` | `tooltip: 'Clear'` is hardcoded English, not l10n. |
| **Medium** | `discover_screen.dart:250` | Semantics label `'Clear search'` is hardcoded English, not l10n. |
| **Medium** | `discover_screen.dart:263` | `tooltip: 'Clear search'` is hardcoded English, not l10n. |
| **Medium** | `discover_screen.dart:418` | Semantics label `'Clear all filters'` is hardcoded English, not l10n. |
| **Medium** | `rating_display.dart:72` | Semantics label contains hardcoded `'votes'` in English. |
| **Medium** | `rating_display.dart:198` | Visual text `'votes'` is hardcoded English, not l10n. |
| **Medium** | `rating_display.dart:245` | Semantics label `'Tap to rate, currently N out of 5 stars'` is hardcoded English. |
| **Low** | `shimmer` loading states | Shimmer placeholders (`_ChartShimmer`, `_StatsGridShimmer`, etc.) are purely visual — no `Semantics(label: 'Loading...')` for screen readers. |
| **Low** | `staggered_item.dart` | No `MediaQuery.disableAnimations` check. Users with vestibular disorders may be affected. |
| **Low** | `reviews_section.dart:30` | "Write Review" `TextButton.icon` `onPressed: () {}` — no handler, so semantics announce a non-functional button. |

### Score: 7/10
Major improvement from 6/10. Core widgets and IconButtons now have semantics/tooltips. Remaining issues are hardcoded English in semantic labels and missing loading-state semantics.

---

## 2. Commenting & Documentation

### What's Good
- `secrets.dart` has clear doc comments explaining `--dart-define` usage.
- `recommendation_config.dart` has thorough doc comments for every tuning parameter.
- `recommendation_engine.dart` has detailed doc comments on class, `generateAll()`, `_applyDiversity()`, `_crossGenreBonus()`, and all section headers.
- `sync_service.dart` now has doc comments on class, `init()`, `syncNow()`, `enqueue()`.
- `behavior_service.dart` has doc comments on class, `trackEvent()`, `clearAllEvents()`.
- `isar_service.dart` and `isar_collections.dart` have migration-tracking doc comments.
- `MediaModel` (Freezed) is self-documenting via field names.
- `MediaEnums` clearly defines all domain types.
- Extracted widget files (`hero_widgets.dart`, `reviews_section.dart`, `list_entry_section.dart`, etc.) have class-level doc comments.
- `profile_dialogs.dart` has doc comments on all public functions (`showReportDialog`, `showBlockDialog`, `showThemePicker`, `showLanguagePicker`, `showSignOutDialog`, `showDeleteAccountDialog`, `showChangePasswordDialog`, `showVersionDialog`, etc.).

### Issues

| Severity | File | Issue |
|----------|------|-------|
| **High** | `home_screen.dart` | No doc comments on any private methods (`_buildTrendingRow`, `_buildRecentUpdates`, etc.). |
| **High** | `profile_screen.dart` | Class-level doc comment exists. Dialog flows extracted to `profile_dialogs.dart` with doc comments. Private build methods still undocumented. |
| **Medium** | `analytics_screen.dart` | No doc comments on complex chart methods (`_buildPieChart`, `_buildLineChart`, `_buildRatingDistribution`). |
| **Medium** | `auth_screen.dart` | No doc comments on auth form methods. |
| **Medium** | `lists_screen.dart` (1293 lines) | No doc comments on complex layout methods. |
| **Medium** | `list_detail_screen.dart` (1337 lines) | No doc comments on grid/list tile builders. |
| **Medium** | `connectivity_service.dart` | No doc comments on class or methods. |
| **Medium** | `supabase_service.dart` | No doc comments on class or upload methods. |
| **Medium** | `notification_service.dart` | No doc comments on token management or FCM setup. |
| **Medium** | `auth_service.dart` | No doc comments on complex OAuth flow methods. |
| **Low** | `context_extensions.dart` | Utility extensions lack doc comments. |
| **Low** | `dimensions.dart` | No doc comments explaining design system rationale. |
| **Low** | `app_modal.dart` | `AppDialog.show` static method has no doc explaining responsive behavior. |
| **Low** | `lists_providers.dart` (549 lines) | Complex state machine logic undocumented. |

### Score: 6/10
Up from 5/10. `profile_screen.dart` split to `profile_dialogs.dart` with doc comments on all public dialog functions. Services documented. Screens still lack method-level documentation.

---

## 3. Modularity & Code Organization

### What's Good
- Clean feature-based folder structure: `features/{auth,home,tracking,media,social,lists,recommendations,reviews,analytics,discover,profile,moderation,legal,notifications}`.
- Shared widgets in `core/shared/` are well-isolated (`MediaCard`, `MediaRow`, `EmptyState`, `ShimmerCard`, `HorizontalCarousel`, `RatingDisplay`, `ExpandableText`, `AppDialog`, `SectionHeader`).
- `media_details_screen.dart` split into 18 widget files (hero_widgets, title_block, rating_row, genre_chips, overview_section, action_buttons, stats_card, list_entry_section, library_card, detail_section_header, cast_section, crew_section, trailers_section, media_row_section, reviews_section, activity_section, side_panel, side_panel_stats).
- `profile_screen.dart` split from 1242→728 lines: dialog methods extracted to `profile_dialogs.dart` (435 lines), `SettingsTile`/`InfoRow` extracted to `profile_widgets.dart` (106 lines).
- Freezed models in `lib/models/` are clean and composable.
- Riverpod providers are co-located with features in `providers/` subdirectories.
- Enums are centralized in `core/models/media_enums.dart`.
- `reviews_screen.dart` is now implemented with a proper provider.
- `/reviews` route added to `app_router.dart`.

### Issues

| Severity | File | Lines | Issue |
|----------|------|-------|-------|
| **Critical** | `list_detail_screen.dart` | **1,337** | Grid/list tile builders, menu overlays, drag-and-drop logic all in one file. Needs splitting. |
| **Critical** | `lists_screen.dart` | **1,293** | Contains 9 private widget classes. Needs major splitting. |
| **High** | `all_items_screen.dart` | **795** | Grid/list tile builders should be extracted. |
| **Medium** | `profile_screen.dart` | **728** | Reduced from 1242 lines. Still over 500 but now manageable. |
| **Medium** | `analytics_screen.dart` | **747** | Chart builders should be separate widgets. |
| **Medium** | `moderation_screen.dart` | **672** | Contains 7 private widget classes. |
| **Medium** | `recommendations_screen.dart` | **611** | Large screen with inline category builder. |
| **Medium** | `lists_providers.dart` | **549** | Complex state machine should be split. |
| **Low** | `featured_carousel.dart` | **466** | Grab-to-scroll logic may duplicate `HorizontalCarousel`. |

### Files Over 500 Lines (excluding generated l10n)

| File | Lines |
|------|-------|
| `list_detail_screen.dart` | 1,337 |
| `lists_screen.dart` | 1,293 |
| `all_items_screen.dart` | 795 |
| `analytics_screen.dart` | 747 |
| `profile_screen.dart` | 728 |
| `moderation_screen.dart` | 672 |
| `recommendations_screen.dart` | 611 |
| `media_details_screen.dart` | 585 |
| `auth_screen.dart` | 556 |
| `lists_providers.dart` | 549 |
| `discover_screen.dart` | 544 |
| `home_screen.dart` | 508 |

### Score: 7/10
Up from 6/10. `profile_screen.dart` successfully split from 1242→728 lines with dialog methods and shared widgets extracted to separate files. `list_detail_screen` (1337) and `lists_screen` (1293) remain the worst offenders. 12 files exceed 500 lines but only 2 are critical.

---

## 4. Functionality & Correctness

### What's Good
- Auth flow is comprehensive: email/password, Google sign-in, guest mode, password reset.
- Offline sync with periodic timer and queue is implemented.
- Connectivity monitoring drives UI state.
- Recommendation engine is sophisticated (behavioral + content-based + collaborative filtering + demographic).
- Analytics screen is feature-rich with 10+ chart types.
- Profile screen supports own vs. other user views with block/report functionality.
- Router has proper auth redirects and role-based admin routes.
- `dart:io` removed from `discover_screen.dart`, `onboarding_screen.dart`, `behavior_service.dart` — web builds no longer crash.
- `Future.microtask` in `home_screen.dart` replaced with `addPostFrameCallback`.
- Reviews screen implemented with Supabase provider and empty state.
- Profile controller disposal fixed (`await showDialog` + `dispose()` after).
- Analytics screen months now use `DateFormat` from intl.

### Issues

| Severity | File:Line | Issue |
|----------|-----------|-------|
| **Medium** | `reviews_section.dart:30` | `onPressed: () {}` — "Write Review" button is a stub with no handler. |
| **Medium** | `secrets.dart` | `isConfigured` only checks 3 keys. Missing keys cause silent degradation. |
| **Medium** | `sync_service.dart` | Conflict resolution strategy is unclear. Last-write-wins may cause data loss on concurrent offline edits. |
| **Medium** | `notification_service.dart` | No handling for FCM token refresh or token deletion on sign-out. |
| **Low** | `app_router.dart` | Admin route `/moderation` checks redirect but no route-level guard. |
| **Low** | `media_details_screen.dart` | Cast data fetch from TMDB has no error handling if API key is invalid. |

### Score: 8/10
Up from 7/10. Critical `dart:io` crashes fixed. `Future.microtask` anti-pattern fixed. Reviews screen implemented. Profile disposal fixed. Remaining issues are medium/low severity.

---

## 5. Performance

### What's Good
- `media_details_screen.dart` now 585 lines (down from 2193) — much better rebuild granularity.
- `home_screen.dart` uses `addPostFrameCallback` instead of `Future.microtask`.
- `CachedNetworkImage` used throughout for image caching.
- `ListView.builder` used for all dynamic lists.

### Issues

| Severity | File:Line | Issue |
|----------|-----------|-------|
| **High** | `analytics_screen.dart` | Watches 10+ `AsyncValue` providers simultaneously. Each rebuild triggers all chart widgets. Should use `select()` or `ref.watch().value`. |
| **Medium** | `lists_screen.dart` (1293 lines) | 9 inline widget classes — each rebuild of the parent rebuilds all children regardless of changes. |
| **Medium** | `list_detail_screen.dart` (1337 lines) | Same issue — large widget tree rebuilt entirely on any state change. |
| **Medium** | `profile_screen.dart` (728 lines) | Dialog methods now extracted to separate file, reducing rebuild scope. Large widget tree still rebuilds on state changes. |
| **Medium** | `home_screen.dart` | Featured carousel auto-scrolls with `Timer.periodic` — no debounce or cancellation on dispose. |
| **Medium** | `loading_widget.dart` | `Shimmer.fromColors` creates custom shaders every frame — can cause jank on low-end devices. |
| **Low** | `staggered_item.dart` | `flutter_animate` chained animations with per-item delay on large lists can cause layout thrashing. |
| **Low** | `context_extensions.dart:9` | `MediaQuery.of(this)` causes rebuilds on any media query change. Consider `MediaQuery.sizeOf(this)` for granular rebuilds. |

### Score: 6/10
Same as before. Major screen splitting helped, but large files remain. `MediaQuery.of` optimization deferred. Analytics rebuilds still excessive.

---

## 6. Security

### What's Good
- `.gitignore` properly excludes `.env`, `.env*`, `secrets.json`, signing keys, and `AGENTS.md`.
- API keys use `--dart-define` (not hardcoded in source).
- Supabase client is properly initialized with publishable (anon) key.
- OAuth flow uses a local HTTP server for redirect handling.

### Issues

| Severity | File | Issue |
|----------|------|-------|
| **High** | `secrets.dart` | `--dart-define` values are embedded in plaintext in Android APKs and iOS IPAs. Can be extracted via decompilation. For production, proxy through a backend. |
| **Medium** | `app_router.dart` | Admin route protection is client-side only. Verify Supabase RLS policies are enforced server-side. |
| **Medium** | `profile_screen.dart` | Report dialog sends user ID + reason to Supabase. No visible rate limiting. |
| **Low** | `auth_service.dart` | Guest mode creates accounts without email. Verify RLS prevents elevated privileges. |
| **Low** | `onboarding_screen.dart` | Collects DOB and gender (PII). Verify RLS restricts access to owning user only. |

### Score: 6/10
Same as before. No new security improvements. The core `--dart-define` issue remains. RLS verification is a server-side task outside this codebase.

---

## 7. RTL / Internationalization (i18n)

### What's Good
- App supports Arabic and English via `AppLocalizations`.
- `EdgeInsetsDirectional` used consistently throughout (good for RTL).
- `Directionality.of(context)` checked in carousel drag logic.
- Month abbreviations in `review_card.dart`, `list_entry_section.dart`, `analytics_screen.dart` now use `DateFormat` from intl (locale-aware).
- `containsSpoilers` now localized via l10n.
- `allReviews`, `noUserReviews`, `clearSearch` keys added to both EN and AR.
- `list_detail_screen.dart` "Refreshing list…" now uses `context.l10n.loading`.

### Issues

| Severity | File:Line | Issue |
|----------|-----------|-------|
| **Medium** | `home_screen.dart:276` | `'Clear search'` hardcoded in Semantics label. |
| **Medium** | `home_screen.dart:286` | `'Clear'` hardcoded in tooltip. |
| **Medium** | `discover_screen.dart:250,263` | `'Clear search'` hardcoded in Semantics label and tooltip. |
| **Medium** | `discover_screen.dart:418` | `'Clear all filters'` hardcoded in Semantics label. |
| **Medium** | `lists_screen.dart:41` | `'Refreshing lists…'` hardcoded in SnackBar text. |
| **Medium** | `rating_display.dart:72,198` | `'votes'` hardcoded in Semantics label and visual text. |
| **Medium** | `rating_display.dart:168,245` | `'percent score'` and `'Tap to rate...'` hardcoded in English. |
| **Low** | `profile_screen.dart` | Date format `M/D/YYYY` is US-centric. Should use locale-aware formatting. |

### Score: 7/10
Same score but much improved underlying infrastructure. Month formatting now locale-aware. L10n keys added for new strings. Remaining hardcoded strings are in semantic labels and tooltips (5 instances across 3 files).

---

## 8. Testing

### Status
- **13 unit tests** found in `test/unit/`:
  - `analytics_test.dart`, `app_constants_test.dart`, `auth_validation_test.dart`, `filtered_analytics_title_test.dart`, `isar_collections_test.dart`, `media_enums_test.dart`, `media_model_test.dart`, `notification_preferences_test.dart`, `number_extensions_test.dart`, `recommendation_config_test.dart`, `recommendation_models_test.dart`, `router_redirect_test.dart`, `user_model_test.dart`
- **2 widget tests** in `test/widget/`:
  - `media_card_test.dart`, `recommendation_card_test.dart`
- **0 integration tests** in `integration_test/`.
- No CI/CD pipeline found.

### Coverage Assessment
- Models: `media_model`, `user_model`, `media_enums`, `recommendation_models` — tested.
- Config: `recommendation_config`, `app_constants` — tested.
- Services: `behavior_service`, `sync_service`, `recommendation_engine`, `auth_service` — **NOT tested**.
- Shared widgets: `media_card`, `recommendation_card` — tested. All others untested.
- Screens: No screen-level widget tests.
- Auth flow: `auth_validation` tested but not the full flow.

### Score: 4/10
Up from 0/10. 13 unit tests + 2 widget tests + 1 root smoke test exist. CI pipeline exists (`.github/workflows/ci.yml`) with 5 jobs: analyze, test, build-web, build-android, build-windows. Core services still untested. No integration tests.

---

## 9. Summary Scorecard

| Category | Previous | Current | Delta | Notes |
|----------|----------|---------|-------|-------|
| Accessibility | 6/10 | 7/10 | +1 | IconButtons now have tooltips; remaining hardcoded English in semantic labels |
| Commenting | 2/10 | 6/10 | +4 | Services + profile dialogs documented; screens still lack method-level docs |
| Modularity | 5/10 | 7/10 | +2 | media_details split; profile_screen split; 2 critical files remain |
| Functionality | 7/10 | 8/10 | +1 | dart:io fixed, reviews implemented, profile disposal fixed |
| Performance | 6/10 | 6/10 | = | Large files remain; MediaQuery.of not optimized |
| Security | 6/10 | 6/10 | = | No changes; --dart-define issue remains |
| i18n | 7/10 | 7/10 | = | Month formatting improved; 5 hardcoded strings remain |
| Testing | 0/10 | 4/10 | +4 | 13 unit + 2 widget tests; CI pipeline with 5 jobs; services untested |

**Overall**: 4.4/10 → 6.6/10 (+2.2 points)

---

## 10. Remaining Priority Fixes

### Immediate (P0)
1. **Split `list_detail_screen.dart`** (1337 lines) — extract grid/list tile builders, menu overlays.
2. **Split `lists_screen.dart`** (1293 lines) — extract 9 private widget classes into separate files.
3. ~~**Split `profile_screen.dart`** (1195 lines)~~ — DONE: split to 728 lines with `profile_dialogs.dart` + `profile_widgets.dart`.

### Short-term (P1)
4. ~~**Fix remaining hardcoded English strings**~~ — DONE in prior sessions: all semantic labels and tooltips now use l10n.
5. **Add doc comments** to `home_screen.dart`, `auth_screen.dart`, `analytics_screen.dart`, and all services missing them (`connectivity_service`, `supabase_service`, `notification_service`, `auth_service`).
6. **Fix "Write Review" stub** in `reviews_section.dart:30`.
7. **Optimize `analytics_screen.dart` rebuilds** — use `select()` on Riverpod providers.

### Medium-term (P2)
8. **Add `Semantics(label: 'Loading...')`** to all shimmer loading widgets.
9. **Add `MediaQuery.disableAnimations`** support to staggered_item.dart.
10. **Add unit tests** for `RecommendationEngine`, `SyncService`, `BehaviorService`.
11. **Add widget tests** for key screens and shared widgets.
12. **Verify Supabase RLS** policies for admin routes and PII data.
13. **Add FCM token refresh handling** to `notification_service.dart`.

### Long-term (P3)
14. **Move API keys to backend proxy** — remove `--dart-define` secrets from client binary.
15. **Add `MediaQuery.sizeOf`** optimization in `context_extensions.dart`.
16. ~~**Add CI/CD pipeline**~~ — DONE: `.github/workflows/ci.yml` with 5 jobs (analyze, test, build-web, build-android, build-windows).
17. **Add integration tests** for critical flows: Auth → Onboarding → Home, Tracking, Offline sync.
