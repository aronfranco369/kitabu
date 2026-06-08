# SINEMAX — Project Context for Claude Code

> Read this before touching any file. This is the single source of truth for the project state.

## STANDING INSTRUCTION — End-of-Session Wrap-up

When the user explicitly passes an update prompt (e.g. "update the md"), **directly edit this file** — update `## Current State` and append a row to `## Session Log`. Do not print a paste block.

---

## What This App Is

**Sinemax** — a streaming app for translated (dubbed) movies & series by Tanzanian/Kenyan DJs.
Flutter app, dark theme, Supabase backend, Hive for local persistence.
Flutter package name is `kitabu`; display name is `SINEMAX`.

---

## Stack

| Concern | Choice |
|---|---|
| State management | `flutter_riverpod ^3.3.1` + `riverpod_annotation` — `@riverpod` code generation via `build_runner` |
| Navigation | `go_router` — `StatefulShellRoute.indexedStack` for 5 tabs |
| Backend | `supabase_flutter` — tables: `media`, `files` |
| Local persistence | `hive_ce` + `hive_ce_flutter` — boxes: `saved` (bool), `recent` (WatchedItem), `downloads` (DownloadItem) |
| Models | `freezed_annotation` + `json_annotation` — `@freezed` on `Media`, `MediaFile`, `DiscoverFilter` |
| Fonts | Barlow Condensed (display/headings) + DM Sans (body) via `google_fonts` |
| Icons | Custom SVG via `flutter_svg` — see `lib/widgets/sinemax_icon.dart` |
| Images | `cached_network_image_ce` — `CachedNetworkImage` throughout |
| Video player | `chewie` + `video_player`, loads URL from `files` table; fallback = BigBuckBunny MP4 |
| Animations | `flutter_animate` |
| Config | `flutter_dotenv` — `.env` file with `SUPABASE_URL` + `SUPABASE_ANON_KEY` |

**Code generation is active.** After model/provider changes run:
```
dart run build_runner build --delete-conflicting-outputs
```

Generated files (do not edit manually):
- `lib/data/providers.g.dart`
- `lib/models/media.freezed.dart` + `media.g.dart`
- `lib/models/discover_filter.freezed.dart`
- `lib/models/library_item.g.dart`
- `lib/hive_registrar.g.dart`

---

## Folder Structure

```
lib/
├── main.dart               # Entry: dotenv + Supabase.initialize + Hive init + ProviderScope
├── app.dart                # GoRouter + SinemaxApp + _AppShell (PopScope + back-nav logic)
├── theme/
│   └── app_theme.dart      # SinemaxColors, SinemaxTextStyles, buildSinemaxTheme()
├── models/
│   ├── media.dart          # Media (@freezed + @JsonKey), MediaFile (@freezed), HomeRow (plain class)
│   ├── discover_filter.dart # DiscoverFilter (@freezed) + DiscoverFilterX extension
│   ├── library_item.dart   # WatchedItem (@HiveType typeId:0), DownloadItem (@HiveType typeId:1)
│   └── request.dart        # ContentRequest (plain), RequestStatus enum + extension (label/color/note)
├── data/
│   └── providers.dart      # All @riverpod providers (all catalog providers are async/Future-based)
└── widgets/
    ├── sinemax_icon.dart    # SinemaxIcon widget (SVG string icons)
    ├── bottom_nav_bar.dart  # SinemaxBottomNav — UNDERLINE variant
    ├── poster_card.dart     # PosterCard — notch-clipped image, DJ badge top-right, type badge top-left, title+meta below
    ├── movie_card.dart      # MovieCard — horizontal list row with mini poster + progress bar
    ├── section_header.dart  # SectionHeader — title + "See All >" link
    └── sinemax_search_bar.dart # SinemaxSearchBar — tappable bar that pushes /search
screens/
    ├── splash_screen.dart   # Pulse + shimmer animation (flutter_animate), auto-nav to /home after 2.8s
    ├── home_screen.dart     # SX badge + search bar app bar; category rows grouped by country from homeRowsProvider
    ├── discover_screen.dart # Filter chips (year/type/country/DJ) via bottom-sheet picker + 3-col grid
    ├── search_screen.dart   # Auto-focus search, async results grid
    ├── detail_screen.dart   # Fixed zone: player (real URL from files table) + Download/Save/Share; scrollable: info chips + sticky episodes header + expand/collapse (horizontal cards ↔ vertical list) + RELATED
    ├── requests_screen.dart # Request form (title + notes) + in-memory history list
    ├── library_screen.dart  # Pill tab bar: Recent / Saved / Downloads (all Hive-backed)
    └── profile_screen.dart  # Avatar card + live stats + subscription card + settings tiles + logout
```

---

## Routes

| Path | Screen | Notes |
|---|---|---|
| `/splash` | SplashScreen | Initial route, redirects to `/home` |
| `/home` | HomeScreen | Tab 0 |
| `/discover` | DiscoverScreen | Tab 1 |
| `/requests` | RequestsScreen | Tab 2 |
| `/library` | LibraryScreen | Tab 3 |
| `/profile` | ProfileScreen | Tab 4 |
| `/detail/:id` | DetailScreen | Full route push (NOT modal) |
| `/search` | SearchScreen | Full route push |

---

## Key Providers (lib/data/providers.dart)

All catalog/content providers are `AsyncNotifierProvider` / `FutureProvider` hitting Supabase.
Library providers are synchronous `NotifierProvider` backed by Hive boxes.

```dart
// Catalog (Supabase → async)
catalogProvider               // FutureProvider<List<Media>>  — SELECT * FROM media ORDER BY title
mediaByIdProvider(id)         // FutureProvider<Media?>
homeRowsProvider              // FutureProvider<List<HomeRow>> — groups catalog by country
mediaFilesProvider(mediaId)   // FutureProvider<List<MediaFile>> — SELECT FROM files WHERE media_id = ?
relatedMediaProvider(mediaId) // FutureProvider<List<Media>> — same country or genre, max 6

// Filter options (derived from catalog, async)
filterYearsProvider           // FutureProvider<List<String>>
filterDjsProvider             // FutureProvider<List<String>>
filterCountriesProvider       // FutureProvider<List<String>>

// Discover (sync filter state + async results)
discoverFiltersProvider       // NotifierProvider<DiscoverFilters, DiscoverFilter>
discoverResultsProvider       // FutureProvider<List<Media>> — filtered catalog

// Search (sync query state + async results)
searchQueryProvider           // NotifierProvider<SearchQuery, String>
searchResultsProvider         // FutureProvider<List<Media>>

// Library — Hive-backed (sync)
savedProvider                 // NotifierProvider<Saved, Set<String>>    — box: 'saved'
savedContentProvider          // FutureProvider<List<Media>>
recentProvider                // NotifierProvider<Recent, List<WatchedItem>> — box: 'recent'
recentContentProvider         // FutureProvider<List<(WatchedItem, Media)>>
downloadsProvider             // NotifierProvider<Downloads, List<DownloadItem>> — box: 'downloads'
downloadsContentProvider      // FutureProvider<List<(DownloadItem, Media)>>

// Requests (in-memory, not persisted)
requestsProvider              // NotifierProvider<Requests, List<ContentRequest>>
```

---

## Supabase Schema

| Table | Key columns |
|---|---|
| `media` | `id`, `title`, `poster_url`, `description`, `country`, `year`, `type` ('movie'/'series'), `genres` (array), `tags` (array), `dj`, `view_count`, `download_count` |
| `files` | `id`, `media_id`, `season`, `label`, `download_url`, `created_at` |

---

## Design Source Files (READ-ONLY reference)

```
sinemax app ui/
├── data.js              # Full mock data (reference only — real data now in Supabase)
├── sinemax-parts.jsx    # Component designs — bottom nav variants (underline selected)
├── sinemax-icons.jsx    # SVG icon paths (already ported to sinemax_icon.dart)
└── tweaks-panel.jsx     # Design tweaks — inline nav, pulse splash
```

---

## Theme Quick Reference

```dart
SinemaxColors.bg         // #050D1A  — main background
SinemaxColors.bg2        // #0A1628  — nav bar background
SinemaxColors.panel      // #0E1D33  — cards
SinemaxColors.panel2     // #11233D  — chip backgrounds
SinemaxColors.line       // rgba(120,160,220, 0.14) — subtle borders
SinemaxColors.line2      // rgba(120,160,220, 0.26) — stronger borders
SinemaxColors.blue       // #2D8EFF  — primary accent
SinemaxColors.blueBright // #19C3FB  — gradient highlight
SinemaxColors.blueDeep   // #1A6FE8  — pressed state
SinemaxColors.ink        // #EAF2FF  — primary text (default color)
SinemaxColors.muted      // #8FA6C8  — secondary text
SinemaxColors.muted2     // #5E7298  — tertiary text
SinemaxColors.gold       // #F4C13B  — star ratings / premium crown
SinemaxColors.teal       // #22D3A6  — success / added status
SinemaxColors.red        // #FF5D7A  — danger / logout
SinemaxColors.orange     // #FF8A3D  — warning
SinemaxColors.purple     // #7C5CFF  — secondary accent

SinemaxTextStyles.display(size, weight, color)  // Barlow Condensed
SinemaxTextStyles.body(size, weight, color)     // DM Sans
```

---

## Current State

**Last updated: 2026-06-08**

### Completed
- [x] `pubspec.yaml` — full dependency set: riverpod + codegen, supabase_flutter, hive_ce, freezed, cached_network_image_ce, flutter_dotenv, chewie/video_player, flutter_animate, go_router, google_fonts
- [x] All model files (`media.dart`, `discover_filter.dart`, `library_item.dart`, `request.dart`)
- [x] `lib/data/providers.dart` — all @riverpod providers, async/Supabase-backed catalog, Hive-backed library
- [x] All 5 widgets (`sinemax_icon`, `bottom_nav_bar`, `poster_card`, `movie_card`, `section_header`)
- [x] All 8 screens (splash, home, discover, search, detail, requests, library, profile)
- [x] `lib/main.dart` — Supabase.initialize + Hive init + adapter registration
- [x] `lib/app.dart` — GoRouter + _AppShell with PopScope back-nav + exit dialog
- [x] **Backend migration** — replaced `local_data.dart` + `content/dj/episode` models with Supabase queries + `Media`/`MediaFile` freezed models
- [x] **Code generation wired up** — `@riverpod`, `@freezed`, `@HiveType` all active; generated files committed
- [x] **UI redesign pass** — poster cards (notch clipper + DJ badge), home screen (SX badge + category rows by country), detail screen (fixed player zone + sticky episodes + expand/collapse)
- [x] Theme expanded — added `blueBright`, `blueDeep`, `ink`, `orange`, `line`, `line2`, DJ accent palette

### Pending / Requested Modifications
- [ ] *(add user-requested changes here after each session)*

---

## Session Log

| Date | Summary |
|---|---|
| 2026-06-05 | Initial build — full app scaffolded: models, data, providers, 5 widgets, 8 screens, router, theme |
| 2026-06-06 | Set up CLAUDE.md auto-update system |
| 2026-06-06 | UI redesign: poster cards, home screen app bar + hero, detail screen fixed/scroll layout, sticky episodes header, expand/collapse episode list |
| 2026-06-08 | Major backend migration: replaced local mock data with Supabase; new Media/MediaFile freezed models; @riverpod code generation; Hive persistence for library; updated all providers to async; expanded theme colors |
