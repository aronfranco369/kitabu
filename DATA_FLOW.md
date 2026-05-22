# Kitabu — App Data Flow Reference

This document explains how every screen in the app receives, processes, and renders data.
The stack is: **Supabase** (backend) → **Repositories** (query layer) → **Riverpod FutureProviders** (state layer) → **ConsumerWidget screens** (UI).

---

## Architecture Overview

```
.env file
  └─ Env (static getters: SUPABASE_URL, SUPABASE_ANON_KEY)
       └─ Supabase.initialize() in main()
            └─ SupabaseClient (singleton)
                 └─ Repository classes (BookRepository, LibraryRepository, …)
                      └─ Riverpod Providers (allBooksProvider, bookByIdProvider(id), …)
                           └─ ConsumerWidget screens
                                └─ ref.watch(provider).when(loading, error, data)
                                     └─ UI widgets
```

### Startup sequence (`main.dart`)

1. `WidgetsFlutterBinding.ensureInitialized()`
2. `dotenv.load()` — reads `.env` into memory
3. `Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.anonKey)` — opens the Supabase connection
4. `runApp(ProviderScope(child: KitabuApp()))` — ProviderScope makes all Riverpod providers available to the widget tree
5. `MaterialApp.router(routerConfig: appRouter)` — GoRouter drives navigation

---

## Data Models

| Model | Source Table | Key Fields |
|---|---|---|
| `Book` | `books` | id, title, author, description, category, isFree, price, discountPrice, coverUrl, fileUrl, fileFormat, pageCount, viewCount, downloadCount, year, tags |
| `Category` | derived from `books` | id, slug, name, icon, color, bookCount |
| `LibraryEntry` | `library` + join `books` | book, addedAt, readProgress (0.0–1.0), lastReadAt |
| `BookRequest` | `requests` + join `request_events` | id, title, author, note, status, createdAt, events |
| `PhysicalOrder` | `orders` + join `books` + `order_steps` | id, book, quantity, totalPrice, status, steps, trackingNumber, shippingAddress |

All models are deserialized from Supabase response maps via `Model.fromMap(Map<String, dynamic>)`.

---

## Repositories & Providers

### Repositories (query abstraction)

| Repository | Method | SQL / Logic |
|---|---|---|
| `BookRepository` | `fetchAll()` | `SELECT * FROM books ORDER BY title` |
| | `fetchById(id)` | `SELECT * FROM books WHERE id = ?` |
| | `fetchByCategory(slug)` | `SELECT * FROM books WHERE category = ? ORDER BY download_count DESC` |
| | `search(query)` | `SELECT * FROM books WHERE title ILIKE %q% OR author ILIKE %q%` |
| `CategoryRepository` | `fetchAll()` | Fetches distinct categories from books, counts books per category, merges icon/color metadata |
| `LibraryRepository` | `fetchLibrary()` | `SELECT *, books(*) FROM library ORDER BY last_read_at DESC` |
| `RequestRepository` | `fetchAll()` | `SELECT *, request_events(*) FROM requests ORDER BY created_at DESC` |
| | `create(title, author, note)` | `INSERT INTO requests (status='pending', …)` |
| `OrderRepository` | `fetchAll()` | `SELECT *, books(*), order_steps(*) FROM orders ORDER BY created_at DESC` |

### Riverpod Providers

| Provider | Type | Calls |
|---|---|---|
| `allBooksProvider` | `FutureProvider<List<Book>>` | `BookRepository.fetchAll()` |
| `allCategoriesProvider` | `FutureProvider<List<Category>>` | `CategoryRepository.fetchAll()` |
| `booksByCategoryProvider` | `FutureProvider.family<List<Book>, String>` | `BookRepository.fetchByCategory(slug)` |
| `bookByIdProvider` | `FutureProvider.family<Book?, String>` | `BookRepository.fetchById(id)` |
| `searchBooksProvider` | `FutureProvider.family<List<Book>, String>` | `BookRepository.search(query)` |
| `libraryProvider` | `FutureProvider<List<LibraryEntry>>` | `LibraryRepository.fetchLibrary()` |
| `allRequestsProvider` | `FutureProvider<List<BookRequest>>` | `RequestRepository.fetchAll()` |
| `allOrdersProvider` | `FutureProvider<List<PhysicalOrder>>` | `OrderRepository.fetchAll()` |

Family providers are parameterized — `bookByIdProvider("abc123")` creates a separate provider instance per unique argument and caches independently.

---

## Screen-by-Screen Data Flow

---

### HomeScreen

**Route:** `/home`
**Widget type:** `ConsumerWidget`

#### Before data arrives
- Renders a Shimmer skeleton: placeholder blocks for category chips and the book grid.

#### Providers watched
```dart
final booksAsync  = ref.watch(allBooksProvider);       // FutureProvider<List<Book>>
final catsAsync   = ref.watch(allCategoriesProvider);  // FutureProvider<List<Category>>
```
Both fire their Supabase queries in parallel the first time the screen is built.

#### While loading
- `.when(loading: ...)` returns the shimmer skeleton widget.

#### After data arrives
The screen renders:
1. **Category chips row** — iterates `List<Category>`, displays each category's `icon` + `name`, applies `Color(cat.color)` as the chip background. Tapping navigates to `/home/search/results?q=<slug>&cat=<slug>`.
2. **Book grid (6 items)** — takes `books.take(6)`, renders `BookCover` (procedural or image cover) + title + author. Tapping navigates to `/home/book/<id>`.
3. **"See all" link** — navigates to `/home/search/results?q=`.

#### Local state
None — the screen is fully stateless; all data comes from providers.

#### On error
`.when(error: ...)` renders an error message with the exception text.

---

### BookDetailsScreen

**Route:** `/home/book/:id`
**Widget type:** `ConsumerWidget`
**Route parameter:** `id` (book ID string passed as path segment)

#### Before data arrives
- Shimmer placeholder for the expanded app bar cover and metadata rows.

#### Provider watched
```dart
final bookAsync = ref.watch(bookByIdProvider(id));  // FutureProvider<Book?>
```
Fires `SELECT * FROM books WHERE id = id` on first build. Cached per ID.

#### While loading
- Displays a shimmer skeleton inside the SliverAppBar and body.

#### After data arrives
Renders:
1. **Expanded SliverAppBar** — `BookCover` at 140×200 px using `book.coverUrl` or procedural art seeded by `book.id`. Back and share buttons overlay.
2. **Title & author** — serif 22 px / regular 15 px.
3. **Metadata strip** — page count, year (shown only if `book.year != null`), price or discount price, FREE badge if `book.isFree`.
4. **Description** — serif 15 px, line-height 1.7.
5. **Tags** — each tag in `book.tags` as a chip.
6. **Bottom CTA bar** (sticky):
   - "Order Physical" — shown only when `!book.isFree && book.price > 0`. Navigates to `/order/book/<id>`.
   - "Read Free" / "Add to Library" — always shown. Navigates to `/library/read/<id>`.

#### Local state
None.

---

### SearchResultsScreen

**Route:** `/home/search/results`
**Widget type:** `ConsumerWidget`
**Query parameters:** `q` (search string), `cat` (optional category slug)

#### Before data arrives
- Shimmer list-row skeletons.

#### Provider watched — conditional on query params
```dart
// if cat is non-null and non-empty:
final booksAsync = ref.watch(booksByCategoryProvider(cat));
// otherwise:
final booksAsync = ref.watch(searchBooksProvider(query));
```
- Category mode → `SELECT … WHERE category = cat ORDER BY download_count DESC`
- Search mode → `SELECT … WHERE title ILIKE %q% OR author ILIKE %q%`

The title in the app bar reflects the mode: category name or `"<query>"` in quotes.

#### After data arrives
- **Non-empty list** — `ListView` of book rows. Each row: cover 56×80 px, title (max 2 lines), author, page count · year separator dots, FREE badge if applicable. Tapping navigates to `/home/book/<id>`.
- **Empty list** — search icon, "No results for X", "Try a different search term", and a "Request this book" CTA that navigates to `/requests/new?title=<encoded_query>`.

#### Local state
None.

---

### LibraryScreen

**Route:** `/library`
**Widget type:** `ConsumerWidget`

#### Before data arrives
- Shimmer card skeletons.

#### Provider watched
```dart
final entriesAsync = ref.watch(libraryProvider);  // FutureProvider<List<LibraryEntry>>
```
Fires `SELECT *, books(*) FROM library ORDER BY last_read_at DESC`. The nested join means each library row includes the full `Book` object.

#### After data arrives
The screen groups entries into three sections locally (no extra query):

| Section | Condition on `entry.readProgress` |
|---|---|
| Continue Reading | `progress > 0 && progress < 1` |
| Not Started | `progress == 0` |
| Finished | `progress >= 1` |

Each section only renders if it has at least one entry.

**Library card** displays:
- `BookCover` at 72×104 px
- Title (14 px), author (12 px)
- Progress bar: green when finished, accent color when in progress
- Status text: "Finished" / "Start reading" / "{currentPage} of {totalPages} pages" computed from `readProgress * book.pageCount`

Tapping a card navigates to `/library/read/<id>`.

**Empty state** (no entries at all): bookmark icon, "Your library is empty", "Browse Books" button that calls `context.go('/home')`.

#### Local state
None — grouping is a pure local computation on the provider data.

---

### ReaderScreen

**Route:** `/library/read/:id`
**Widget type:** `ConsumerStatefulWidget`
**Route parameter:** `id`

#### Before data arrives
- Loading indicator centered on dark background.

#### Provider watched
```dart
final bookAsync = ref.watch(bookByIdProvider(id));  // FutureProvider<Book?>
```
Reuses the same cached Supabase result if `BookDetailsScreen` for the same `id` was already visited.

#### After data arrives
Renders a full-screen dark-themed reader:
- Book title (22 px serif) and author (13 px) as a header.
- Body: Lorem Ipsum sample text rendered at the user-selected `_fontSize` in a serif font, line-height 1.85.
- Progress footer: "Page 73 of {book.pageCount}" and "35%" (currently hardcoded).

#### Local state (managed with `setState`)
| Field | Initial value | Changed by |
|---|---|---|
| `_showControls` | `true` | Tap anywhere on the content area — toggles controls in/out |
| `_fontSize` | `16.0` | Settings panel slider (range 12–24) or −/+ buttons |
| `_showSettings` | `false` | Settings icon in top bar |

When `_showControls` is `false`, the system UI enters immersive sticky mode (status bar and nav bar hidden).

All controls (top bar + bottom progress bar) animate in/out together via `AnimatedOpacity`.

#### Note on reader content
The actual book file (`book.fileUrl`) is fetched from the provider but the reader currently displays placeholder text. File streaming from Supabase Storage is a future integration point.

---

### OrderScreen

**Route:** `/order`
**Widget type:** `ConsumerWidget`
**Theme:** Clay (warm off-white palette)

#### Before data arrives
- Shimmer card skeletons.

#### Provider watched
```dart
final booksAsync = ref.watch(allBooksProvider);  // FutureProvider<List<Book>>
```
Same provider as HomeScreen — result is cached by Riverpod; no second network call if already fetched.

#### After data arrives
Filters the full book list locally:
```dart
final orderable = books.where((b) => !b.isFree && b.price > 0).toList();
```

Renders:
1. **Delivery banner** — "Free delivery on orders over KES 3,000 / Nairobi & major towns"
2. **Orderable book cards** — cover (72×104 px), title, author, `book.price` (bold, accent), struck `book.discountPrice` if present, "Add to Cart" button.

Tapping a card navigates to `/order/book/<id>`.
Cart icon in app bar navigates to `/order/cart`.

#### Local state
None — the filter is a pure local computation.

---

### PhysicalBookDetailsScreen

**Route:** `/order/book/:id`
**Widget type:** `ConsumerWidget` (outer) + `_QuantityPicker` StatefulWidget (inner)
**Route parameter:** `id`
**Theme:** Clay

#### Before data arrives
- Shimmer placeholder for the book card section.

#### Provider watched
```dart
final bookAsync = ref.watch(bookByIdProvider(id));  // FutureProvider<Book?>
```

#### After data arrives
Renders:
1. **Book card** — cover (100×144 px), title (16 px), author (13 px), year, price (20 px bold, accent), struck original price.
2. **Quantity picker** (`_QuantityPicker` child widget):
   - Maintains `qty: int` starting at 1 with `setState`.
   - − button decrements (floor 1), + button increments.
   - Displays: quantity value + computed total `(book.displayPrice * qty).toStringAsFixed(2)`.
3. **About this edition** — `book.description` in serif 14 px.
4. **Shipping info card** — list of delivery areas with estimated times; "Free delivery on orders over KES 3,000" note.
5. **"Add to Cart" sticky CTA** — navigates to `/order/cart`.

#### Local state
`_QuantityPicker` owns `qty` — isolated in its own `StatefulWidget` so rebuilds don't touch the parent.

---

### CartCheckoutScreen

**Route:** `/order/cart`
**Widget type:** `ConsumerWidget`
**Theme:** Clay

#### Before data arrives
- Shimmer skeleton for cart item rows.

#### Provider watched
```dart
final booksAsync = ref.watch(allBooksProvider);  // FutureProvider<List<Book>>
```

#### After data arrives
Filters locally:
```dart
final cartItems = books.where((b) => !b.isFree && b.price > 0).take(2).toList();
```
> **Note:** Cart items are currently derived from the first 2 orderable books as a placeholder. A dedicated cart state provider (e.g., a `StateNotifierProvider` holding a `List<CartItem>`) is the expected next integration.

Renders:
1. **Cart item rows** — cover (60×88 px), title (13 px), author (11 px), price (14 px bold, accent). A minus button is present (placeholder action).
2. **Order summary** — Subtotal (sum of item prices), Delivery fee KES 200, Total (bold).
3. **Shipping address card** — hardcoded "14 Kimathi Street, Nairobi, 00100" with a "Change" link (placeholder).
4. **Payment card** (`_PaymentCard` widget) — gradient accent card, "VISA", masked number "•••• •••• •••• 4242" (placeholder).
5. **"Place Order · KES {total}" sticky CTA** — calls `context.pushReplacement('/order/confirmation/ord-new')`.

#### Local state
None — totals are computed inline from the filtered book list.

---

## CoverArt — Procedural Cover Generation

`CoverArt` widget (`lib/core/widgets/cover_art.dart`) generates deterministic book covers from a seed string (usually `book.id`):

1. `seed.hashCode` selects one of **8 color palettes** (primary, deep, light colors).
2. `seed.hashCode` also selects one of **16 motif patterns** (stripes, circles, waves, diamonds, grid, triangles, dots, hexagons, zigzag, cross-hatch, arcs, leaves, spiral, bands, stars, checkers).
3. A `CustomPaint` with `_MotifPainter` renders the selected motif at any requested size.

Default size: 116×164 px, 8 px corner radius. Used as fallback when `book.coverUrl` is null or fails to load.

---

## Navigation Map

```
/home
  ├─ /home/search                      SearchCategoriesScreen
  ├─ /home/search/results?q=&cat=      SearchResultsScreen
  └─ /home/book/:id                    BookDetailsScreen

/order
  ├─ /order/book/:id                   PhysicalBookDetailsScreen
  ├─ /order/cart                       CartCheckoutScreen
  └─ /order/confirmation/:id           OrderConfirmationScreen

/library
  └─ /library/read/:id                 ReaderScreen

/requests
  └─ /requests/new?title=              (new request form)

/profile
  └─ (profile sub-routes)
```

All transitions use a custom slide animation (300 ms, `Curves.easeOutCubic`).

---

## Data Lifecycle Summary

| Stage | Mechanism | Notes |
|---|---|---|
| **Config** | `.env` + `flutter_dotenv` | Loaded once at startup |
| **Transport** | Supabase PostgREST over HTTPS | All queries via `supabase-flutter` client |
| **Query** | Repository method | Plain Dart class; one method per query shape |
| **Caching** | Riverpod `FutureProvider` | Result cached for widget tree lifetime; re-fetched on provider invalidation |
| **Async state** | `.when(loading, error, data)` | Screens handle all three states explicitly |
| **Local state** | `setState` in `StatefulWidget` | Used only for UI-only state (font size, quantity, control visibility) |
| **Navigation** | GoRouter path/query params | IDs and search terms passed as path segments or query strings |
