# SINEMAX — LLM Developer Guide

A concise reference for any AI assistant working on this codebase. Read CLAUDE.md first for full context; this guide focuses on patterns, gotchas, and how the pieces connect.

---

## 1. Code Generation — Always Required

This project uses code generation. **Never** write manual `fromJson`, `copyWith`, or provider boilerplate. Always use the annotations and run:

```sh
dart run build_runner build --delete-conflicting-outputs
```

| Annotation | Package | Output |
|---|---|---|
| `@riverpod` | `riverpod_annotation` | `*.g.dart` (provider variables + `_$ClassName` base) |
| `@freezed` | `freezed_annotation` | `*.freezed.dart` + `*.g.dart` (fromJson via json_serializable) |
| `@HiveType` / `@HiveField` | `hive_ce` | `*.g.dart` adapters, also `hive_registrar.g.dart` |

Every `.dart` file that uses these annotations must have the corresponding `part` directive at the top:
```dart
part 'my_file.g.dart';
part 'my_file.freezed.dart';  // only for @freezed
```

Generated files are committed to source control. After adding or changing annotations, always regenerate and commit the `.g.dart` / `.freezed.dart` files too.

---

## 2. Data Flow

```
Supabase (remote) ──fetch──▶ Hive (local cache) ──watch()──▶ AsyncNotifier state ──▶ UI
                  ◀─realtime─┘
```

- `MediaNotifier` (`lib/data/media_notifier.dart`) — owns all `Media`. Hive box: `media_cache`. Full fetch on first launch, 24-hour background refresh, Supabase Realtime keeps it live.
- `FilesNotifier` (`lib/data/files_notifier.dart`) — owns all `MediaFile`. Hive box: `files_cache`. Files are fetched **lazily** per media: call `ref.read(filesProvider.notifier).ensureLoaded(mediaId)` to trigger a fetch for a specific media ID. A `files_fetched` box (Box<bool>) prevents double-fetching.
- Everything else in `lib/data/providers.dart` derives from these two via `ref.watch(mediaProvider.future)` / `ref.watch(filesProvider.future)`.

---

## 3. Riverpod Patterns Used

### Async notifier (class-based)
```dart
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  Future<List<Foo>> build() async { ... }

  void doSomething() { ... }
}
// Access: ref.watch(myNotifierProvider)
// Notifier: ref.read(myNotifierProvider.notifier).doSomething()
```

### Sync notifier (class-based)
```dart
@riverpod
class MySync extends _$MySync {
  @override
  MyState build() => MyState();
  void update(...) => state = ...;
}
```

### Family provider (parameterized)
```dart
@riverpod
Future<Foo> myFamily(Ref ref, String id) async { ... }
// Access: ref.watch(myFamilyProvider(id))
```

**Do not use `StateProvider` or `ChangeNotifierProvider`** — they do not exist in Riverpod 3.x. Use `@riverpod class` with `Notifier<T>` or `AsyncNotifier<T>`.

---

## 4. Models

### Media (lib/models/media.dart)
```dart
@freezed @HiveType(typeId: 2)
class Media {
  id, title, posterUrl, description, country, year,
  type ('movie'|'series'), genres, tags, dj, viewCount, downloadCount
  // computed getters: isSeries, djDisplay, genreDisplay, countryDisplay
}
```

### MediaFile (lib/models/media.dart)
```dart
@freezed @HiveType(typeId: 3)
class MediaFile {
  id, mediaId, season, label, downloadUrl, createdAt, episodeNumber
}
```

### HomeRow (lib/models/media.dart)
Plain class — not freezed, not Hive-stored:
```dart
class HomeRow { String id; String title; List<Media> items; }
```

### Library items (lib/models/library_item.dart)
- `WatchedItem` — `@HiveType(typeId: 0)` — `contentId, watchedAt, progress, context`
- `DownloadItem` — `@HiveType(typeId: 1)` — `contentId, quality, size, at`

**HiveType IDs in use: 0, 1, 2, 3.** Next available: 4.

---

## 5. Hive Setup Rules

Adapters are registered manually in `main.dart` (not via `hive_registrar.g.dart`):
```dart
Hive.registerAdapter(WatchedItemAdapter());
Hive.registerAdapter(DownloadItemAdapter());
Hive.registerAdapter(MediaHiveAdapter());
Hive.registerAdapter(MediaFileHiveAdapter());
```

All boxes are opened before `runApp`. If you add a new Hive type, add `Hive.registerAdapter(...)` to `main.dart` and open the new box there.

---

## 6. Supabase

Connection is initialized in `main.dart` from `.env`:
```dart
await Supabase.initialize(
  url: dotenv.env['SUPABASE_URL']!,
  anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
);
```

Access the client anywhere: `Supabase.instance.client`

Realtime subscriptions use `.channel(name).onPostgresChanges(...)`. Both `MediaNotifier` and `FilesNotifier` maintain a `RealtimeChannel?` that is unsubscribed in `ref.onDispose`.

---

## 7. Navigation

`go_router` with a `StatefulShellRoute.indexedStack` for the 5 main tabs. Named routes are not used — always use path literals. Push detail with `context.push('/detail/$id')`. The back button and PopScope logic live in `lib/app.dart`.

---

## 8. Widgets — What to Use

| Widget | File | Use for |
|---|---|---|
| `PosterCard` | `widgets/poster_card.dart` | Grid/row media card — notch clip + badges |
| `MovieCard` | `widgets/movie_card.dart` | Horizontal list row with progress bar |
| `SectionHeader` | `widgets/section_header.dart` | Row title + "See All" |
| `SinemaxIcon` | `widgets/sinemax_icon.dart` | All icons — pass string name |
| `ActionBtn` | `widgets/action_btn.dart` | Icon+label button (Download/Save/Share) |
| `InfoChip` | `widgets/info_chip.dart` | Small metadata pill |
| `PlayerLoadingView` | `widgets/player_loading_view.dart` | Video zone while player initializes |
| `DetailSkeleton` | `widgets/detail_skeleton.dart` | Full-page skeleton for detail screen |
| `EpisodesSkeleton` | `widgets/detail_skeleton.dart` | Inline skeleton for episodes section |
| `RelatedSkeleton` | `widgets/detail_skeleton.dart` | Inline skeleton for related grid |
| `HomeTrendingSkeleton` | `widgets/home_skeleton.dart` | Skeleton for trending carousel |
| `HomeRowsSkeleton` | `widgets/home_skeleton.dart` | Skeleton for category row section |

---

## 9. Theme — How to Use

Never hardcode colors or font sizes. Always use:
```dart
SinemaxColors.bg          // backgrounds
SinemaxColors.panel       // card surfaces
SinemaxColors.blue        // primary accent
SinemaxColors.ink         // primary text
SinemaxColors.muted       // secondary text

SinemaxTextStyles.display(size, weight: FontWeight.w700)   // Barlow Condensed
SinemaxTextStyles.body(size, color: SinemaxColors.muted)   // DM Sans
```

---

## 10. Home Screen Row Labels

Swahili display names are in `lib/utils/row_labels.dart` (`kRowLabels` map). Key format: `"country type"` all lowercase, e.g. `"tanzania movies"`. If a key is missing, the auto-generated uppercase label is used as fallback.

---

## 11. Detail Screen — Reserved TODOs

Two `// TODO: [DO NOT TOUCH]` comments exist in `detail_screen.dart` (`_loadAndInitPlayer`). Do not implement or remove them unless explicitly asked:

1. Increment `view_count` on Supabase.
2. Restore saved playback position from Hive box `watch_progress`.

---

## 12. Adding a New Feature — Checklist

1. **Model change?** Update `@freezed` class → regenerate → update Hive fields if persisted.
2. **New provider?** Add `@riverpod` function or class to `providers.dart` (or a new file if it needs its own notifier) → regenerate.
3. **New Hive type?** Assign next available `typeId` → register adapter in `main.dart` → open box in `main.dart`.
4. **New screen?** Add route to `lib/app.dart`, add tab entry if needed.
5. **After any codegen change:** `dart run build_runner build --delete-conflicting-outputs`
