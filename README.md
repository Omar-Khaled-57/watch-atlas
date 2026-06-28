<p>
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/images/logo/logo.png">
    <img src="assets/images/logo/logo.png" width="120" alt="WatchAtlas">
  </picture>
</p>

<h1>WatchAtlas</h1>

<p>
  <strong>Modern cross-platform media tracking with hybrid AI recommendations</strong>
</p>

<p>
  <img src="https://img.shields.io/badge/Flutter-3.11+-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Supabase-181818?logo=supabase" alt="Supabase">
  <img src="https://img.shields.io/badge/Riverpod-2.6+-blueviolet" alt="Riverpod">
  <img src="https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web%20%7C%20desktop-lightgrey" alt="Platforms">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License">
</p>

---

## Overview

**WatchAtlas** is a full-featured media companion that lets you track movies, TV shows, and anime; discover new content through a hybrid recommendation engine; build and share lists; write reviews; and follow friends — all with a polished Material 3 UI that adapts to mobile, tablet, and desktop layouts.

The app uses **Supabase** for auth (magic-link, Google, Apple), data persistence, and real-time sync, with **TMDB** and **AniList** as media data sources. An offline-first architecture powered by **ISAR** ensures the app works without connectivity, with a background sync service to reconcile changes when the network returns.

---

## Features

| Category | Capabilities |
|---|---|
| **Media Tracking** | Track status (watching, completed, plan-to-watch, etc.), episode/season progress, rewatch count, start & completion dates |
| **Recommendations** | Hybrid engine combining behaviour, content, collaborative, and demographic signals into 15+ curated categories |
| **Rating & Reviews** | 1–10 scale with per-media reviews, likes, spoiler tags, threaded comments |
| **Lists** | Public, private, and collaborative lists with drag-to-reorder items |
| **Social** | Follow other users, activity feeds, friend-based recommendations |
| **Analytics** | Watch statistics, genre/country distribution, weekly/monthly/yearly activity charts |
| **Discover** | Search movies/TV/anime, filter by genre/country/year/rating, infinite scroll |
| **Notifications** | Firebase push + in-app for new seasons, episodes, follows, list updates |
| **Moderation** | Report system with pending/reviewed/resolved workflow, role-based access |
| **Offline-First** | ISAR local cache, background sync queue with retry, optimistic UI updates |
| **Adaptive UI** | Mobile bottom nav, desktop navigation rail, responsive layouts throughout |
| **Themes** | Dark & light modes with dynamic colour support, custom cyan–purple accent palette |

---

## Screens

| Route | Screen | Description |
|---|---|---|
| `/` | **Home** | Recommended carousel, continue watching, personalised feed |
| `/discover` | **Discover** | Search & filter media across movies, TV, and anime |
| `/lists` | **Lists** | User-created media lists with drag-reorder items |
| `/lists/:id` | **List Detail** | View / edit a single list |
| `/profile` | **Profile** | Avatar, stats, tracking, settings (theme, language, recommendations toggle, delete account) |
| `/profile/edit` | **Edit Profile** | Update display name, bio, avatar, banner, gender, DOB |
| `/profile/:id` | **User Profile** | Public profile of another user |
| `/tracking` | **Tracking** | Tabbed view of all tracked media by status |
| `/media/:type/:id` | **Media Detail** | Full details, cast, trailers, reviews, recommendations |
| `/recommendations` | **Recommendations** | All 15+ category feeds in portrait & landscape layouts |
| `/analytics` | **Analytics** | Fl-chart statistics dashboard |
| `/notifications` | **Notifications** | In-app notification centre |
| `/moderation` | **Moderation** | Report queue (moderator/admin only) |
| `/social` | **Social** | Friend activity feed |
| `/auth` | **Auth** | Magic-link, Google, Apple sign-in |
| `/onboarding` | **Onboarding** | New-user flow |
| `/splash`, `/privacy`, `/terms`, `/licenses`, `/attribution` | Legal & splash | Splash, privacy policy, terms, OSS licences, data attribution |

---

## Recommendation Engine

The core differentiator. A **hybrid scoring system** combines four signal types into one score per media item:

```
final_score = behaviour_weight × behaviour_score
            + content_weight   × content_score
            + collaborative_weight × collaborative_score
            + demographic_weight × demographic_score
```

Default weights (tunable in `RecommendationConfig`): **45% behaviour**, **30% content**, **20% collaborative**, **5% demographic**.

### Feed Categories

| Personalised | Curated (always shown) |
|---|---|
| Because You Saved… | Trending Near You |
| Because You Viewed… | Popular This Week |
| Similar to Your Favorites | New Releases (≤90 days) |
| Because You Like… (top genre) | Top Rated (≥7.0) |
| Users Like You Enjoyed (collaborative) | Hidden Gems (≥7.0, ≤20 popularity) |
| Continue Exploring | Critically Acclaimed (≥8.0, ≥500 votes) |
| Friends Also Saved | Award Winners / Underrated Classics / Upcoming Releases |

### Diversity Re-ranking

Each feed is re-ranked to interleave top / mid / low scoring tiers, preventing genre or actor fatigue within a single category.

### Cache

Results are cached in `recommendations_cache` with a **24-hour TTL**. `clearAllEvents()` wipes both `user_events` and the cache, forcing a full regenerate on the next load.

### Architecture

```
BehaviourService (events) → RecommendationEngine (hybrid scoring)
    ↕                           ↕
Supabase user_events db    RecommendationRepository (cache + profiles + similarity)
    ↕                           ↕
recsEnabledProvider ✔/✘     recommendationsProvider → UI providers
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter 3.11+ / Dart 3.11+ |
| **State Management** | Riverpod 2.6 (`StateNotifierProvider`, `FutureProvider`, `Provider`) |
| **Routing** | go_router 14.8 (shell routes, nested routes, `refreshListenable` for auth guards) |
| **Backend** | Supabase (auth, PostgreSQL, real-time, storage) |
| **Media Data** | TMDB API (movies/TV) + AniList GraphQL (anime) |
| **Local DB** | ISAR 3.1 (offline cache for profiles, lists, tracked media) |
| **Analytics** | Firebase Analytics + fl_chart (in-app dashboards) |
| **Notifications** | Firebase Messaging + flutter_local_notifications |
| **CI/CD** | GitHub Actions (analysis, tests, builds) |
| **Platform** | Android, iOS, Web, macOS, Linux, Windows |

### Key Packages

`flutter_riverpod` · `go_router` · `supabase_flutter` · `dio` · `isar` · `cached_network_image` · `freezed` · `json_serializable` · `fl_chart` · `flutter_animate` · `lottie` · `shimmer` · `flutter_markdown` · `infinite_scroll_pagination` · `firebase_core/messaging/analytics` · `google_sign_in` · `sign_in_with_apple` · `flutter_dotenv` · `share_plus` · `image_picker`

---

## Quick Start

### Prerequisites

- Flutter **3.11+** with Dart 3.11+
- A Supabase project (free tier works)
- TMDB API key (free)
- AniList client ID & secret (optional, for anime features)

### Setup

```bash
git clone https://github.com/your-org/watch_atlas.git
cd watch_atlas
```

### Environment

Copy the template to `.env` and fill in your credentials:

```env
# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key

# TMDB
TMDB_API_KEY=your-api-key
TMDB_ACCESS_TOKEN=your-access-token

# AniList
ANILIST_CLIENT_ID=your-client-id
ANILIST_CLIENT_SECRET=your-client-secret
```

### Database

Open your Supabase SQL editor and run **all files in `supabase/` in this order**:

1. `schema.sql` — full schema, RLS policies, triggers, indexes
2. `migration.sql` — migrations, storage buckets, account deletion RPC
3. `grants_core.sql` — core table grants
4. `grants.sql` — additional grants
5. `recommendation_tables.sql` — engine-specific tables (if not already in schema)

> The `delete_my_account()` RPC in `migration.sql` is required for the **Delete Account** button to work.

### Run

```bash
flutter pub get
flutter run
```

To generate code for `freezed` / `json_serializable` / `riverpod_generator`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Project Structure

```
lib/
├── main.dart                     # App entry, ProviderScope, MaterialApp.router
├── router/
│   └── app_router.dart           # GoRouter config, auth redirects, shell scaffold
├── core/
│   ├── config/
│   │   └── recommendation_config.dart   # All recommendation weights & limits
│   ├── constants/
│   │   ├── api_constants.dart
│   │   ├── api_endpoints.dart
│   │   ├── app_constants.dart
│   │   ├── dimensions.dart
│   │   └── isar_constants.dart
│   ├── extensions/               # BuildContext extensions (l10n, theme, media query)
│   ├── models/                   # Recommendation engine models (ScoredMedia, RecCategory, UserRecProfile)
│   ├── providers/                # App-wide providers (theme, locale, auth state)
│   ├── repositories/             # RecommendationRepository (DB access layer)
│   ├── services/
│   │   ├── supabase_service.dart # Singleton Supabase client
│   │   ├── auth_service.dart     # Sign-in, sign-out, reset password, delete account
│   │   ├── tmdb_service.dart     # TMDB movie/TV API
│   │   ├── anilist_service.dart  # AniList GraphQL anime API
│   │   ├── recommendation_engine.dart  # Hybrid scoring engine
│   │   ├── behavior_service.dart # User event sourcing + cache clearing
│   │   ├── isar_service.dart     # Local ISAR database operations
│   │   ├── sync_service.dart     # Offline → online sync reconciliation
│   │   ├── notification_service.dart
│   │   └── connectivity_service.dart
│   ├── shared/                   # Reusable widgets
│   │   ├── media_card.dart
│   │   ├── horizontal_carousel.dart
│   │   ├── featured_carousel.dart
│   │   ├── media_row.dart
│   │   ├── rating_display.dart
│   │   ├── user_avatar.dart
│   │   ├── empty_state.dart
│   │   ├── loading_widget.dart
│   │   ├── section_header.dart
│   │   ├── expandable_text.dart
│   │   └── app_modal.dart
│   └── theme/
│       └── app_theme.dart        # Dark & light Material 3 themes
├── features/
│   ├── auth/                     # Auth screen, providers, onboarding
│   ├── analytics/                # Statistics dashboard with fl_chart
│   ├── discover/                 # Search & filter with infinite scroll
│   ├── home/                     # Home screen, recommended carousel
│   ├── legal/                    # Privacy, terms, licences, attribution
│   ├── lists/                    # User lists, list detail, drag reorder
│   ├── media/                    # Media detail, cast, trailers, reviews
│   ├── moderation/               # Report queue (moderator/admin)
│   ├── notifications/            # In-app notification centre
│   ├── profile/                  # Profile, edit profile, settings
│   ├── recommendations/          # All recommendation feeds
│   ├── reviews/                  # Review creation & listing
│   ├── social/                   # Friend activity, user feeds
│   ├── splash/                   # Splash screen
│   └── tracking/                 # Media tracking tabbed view
├── l10n/                         # ARB-based localisation (generated)
├── models/                       # Data models (user, media, review, list, etc.)
│   ├── user_model.dart            # Freezed + JsonSerializable
│   ├── media_model.dart
│   ├── review_model.dart
│   ├── user_media_model.dart
│   ├── user_list_model.dart
│   ├── notification_model.dart
│   └── sync_queue_model.dart
└── supabase/                     # SQL migrations & schema
    ├── schema.sql
    ├── migration.sql
    ├── grants_core.sql
    ├── grants.sql
    └── recommendation_tables.sql
```

---

## Architecture & Data Flow

### State Management (Riverpod)

```
                        ┌──────────────────┐
                        │   ProviderScope   │
                        │  (main.dart)      │
                        └────────┬─────────┘
                                 │
                  ┌──────────────┼──────────────┐
                  │              │              │
          ┌───────▼──────┐ ┌────▼─────┐ ┌──────▼──────┐
          │  Auth State   │ │ App      │ │  Router     │
          │  (Notifier)   │ │ (theme,  │ │  (Provider) │
          │               │ │  locale) │ │             │
          └───────┬───────┘ └──────────┘ └──────┬──────┘
                  │                             │
          ┌───────▼───────┐                     │
          │  Supabase Auth │            ┌───────▼────────┐
          │  + Services    │            │  GoRouter      │
          │  (behaviour,   │            │  redirect      │
          │   engine,       │            │  (auth guard)  │
          │   sync)         │            └────────────────┘
          └───────┬───────┘
                  │
         ┌────────▼────────┐
         │  Riverpod        │
         │  Providers       │
         │  (ref.watch)     │
         └────────┬────────┘
                  │
         ┌────────▼────────┐
         │  Widgets / UI   │
         │  (auto-rebuild  │
         │   on state      │
         │   changes)      │
         └─────────────────┘
```

### Offline-First

```
User Action → Optimistic UI Update → ISAR (local) + Sync Queue
                                         ↕
                              Supabase (remote) ← Background Sync (15min)
```

The `sync_service.dart` processes queued operations with retry logic and exponential backoff. On connectivity restore, all pending mutations are replayed against Supabase.

---

## Testing

```bash
# Unit & widget tests
flutter test

# With coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/my-feature`
3. Commit changes following conventional commits
4. `flutter analyze` must pass with no errors
5. Open a pull request

---

## Licence

MIT © 2026 WatchAtlas

---

<p align="center">
  <sub>Built with Flutter · Data from TMDB & AniList · Backed by Supabase</sub>
</p>
