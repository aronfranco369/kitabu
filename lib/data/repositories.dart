import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models.dart';

SupabaseClient get _db => Supabase.instance.client;

// ── Category metadata ─────────────────────────────────────────────────────────

const _categoryMeta = <String, (String icon, int color)>{
  'fiction':     ('📖', 0xFFC0532B),
  'historical':  ('🏛️', 0xFF1A3A5C),
  'thriller':    ('🔍', 0xFF6B4C8A),
  'non-fiction': ('📚', 0xFF2E7D4E),
  'nonfiction':  ('📚', 0xFF2E7D4E),
  'education':   ('🎓', 0xFFB8723A),
  'biography':   ('👤', 0xFF8A3A4A),
  'memoir':      ('✍️', 0xFF5C7A2E),
  'poetry':      ('🎵', 0xFF2A6B8A),
  'science':     ('🔬', 0xFF1A5C34),
  'politics':    ('🏛️', 0xFF4A2E6A),
};

String _categoryName(String slug) {
  if (slug.isEmpty) return '';
  return slug[0].toUpperCase() + slug.substring(1).replaceAll('-', ' ');
}

// ── BookRepository ────────────────────────────────────────────────────────────

class BookRepository {
  Future<List<Book>> fetchAll() async {
    final rows = await _db.from('books').select().order('title');
    return rows.map((r) => Book.fromMap(r)).toList();
  }

  Future<Book?> fetchById(String id) async {
    final rows = await _db.from('books').select().eq('id', id).limit(1);
    if (rows.isEmpty) return null;
    return Book.fromMap(rows.first);
  }

  Future<List<Book>> fetchByCategory(String category) async {
    final rows = await _db
        .from('books')
        .select()
        .eq('category', category)
        .order('download_count', ascending: false);
    return rows.map((r) => Book.fromMap(r)).toList();
  }

  Future<List<Book>> search(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    final rows = await _db
        .from('books')
        .select()
        .or('title.ilike.%$q%,author.ilike.%$q%')
        .order('download_count', ascending: false);
    return rows.map((r) => Book.fromMap(r)).toList();
  }
}

// ── CategoryRepository ────────────────────────────────────────────────────────

class CategoryRepository {
  Future<List<Category>> fetchAll() async {
    final rows = await _db.from('books').select('category');
    final counts = <String, int>{};
    for (final row in rows) {
      final cat = (row['category'] as String?)?.trim().toLowerCase() ?? '';
      if (cat.isNotEmpty) counts[cat] = (counts[cat] ?? 0) + 1;
    }
    final categories = <Category>[];
    int i = 0;
    for (final entry in counts.entries) {
      final (icon, color) = _categoryMeta[entry.key] ?? ('📚', 0xFF1A3A5C);
      categories.add(Category(
        id: i++,
        slug: entry.key,
        name: _categoryName(entry.key),
        icon: icon,
        color: color,
        bookCount: entry.value,
      ));
    }
    categories.sort((a, b) => a.name.compareTo(b.name));
    return categories;
  }
}

// ── LibraryRepository ─────────────────────────────────────────────────────────

class LibraryRepository {
  Future<List<LibraryEntry>> fetchLibrary() async {
    final rows = await _db
        .from('library')
        .select('*, books(*)')
        .order('last_read_at', ascending: false);
    return rows.map((r) {
      final b = Book.fromMap(r['books'] as Map<String, dynamic>);
      return LibraryEntry.fromMap(r, b);
    }).toList();
  }
}

// ── RequestRepository ─────────────────────────────────────────────────────────

class RequestRepository {
  Future<List<BookRequest>> fetchAll() async {
    final rows = await _db
        .from('requests')
        .select('*, request_events(*)')
        .order('created_at', ascending: false);
    return rows.map((r) => BookRequest.fromMap(r)).toList();
  }

  Future<BookRequest?> fetchById(String id) async {
    final rows = await _db
        .from('requests')
        .select('*, request_events(*)')
        .eq('id', id)
        .limit(1);
    if (rows.isEmpty) return null;
    return BookRequest.fromMap(rows.first);
  }

  Future<void> create({
    required String title,
    required String author,
    required String note,
  }) async {
    await _db.from('requests').insert({
      'title': title,
      'author': author,
      'note': note,
      'status': 'pending',
    });
  }
}

// ── OrderRepository ───────────────────────────────────────────────────────────

class OrderRepository {
  Future<List<PhysicalOrder>> fetchAll() async {
    final rows = await _db
        .from('orders')
        .select('*, books(*), order_steps(*)')
        .order('created_at', ascending: false);
    return rows.map((r) {
      final b = Book.fromMap(r['books'] as Map<String, dynamic>);
      return PhysicalOrder.fromMap(r, b);
    }).toList();
  }

  Future<PhysicalOrder?> fetchById(String id) async {
    final rows = await _db
        .from('orders')
        .select('*, books(*), order_steps(*)')
        .eq('id', id)
        .limit(1);
    if (rows.isEmpty) return null;
    final b = Book.fromMap(rows.first['books'] as Map<String, dynamic>);
    return PhysicalOrder.fromMap(rows.first, b);
  }
}

// ── Providers ─────────────────────────────────────────────────────────────────

final bookRepoProvider = Provider((_) => BookRepository());
final categoryRepoProvider = Provider((_) => CategoryRepository());
final libraryRepoProvider = Provider((_) => LibraryRepository());
final requestRepoProvider = Provider((_) => RequestRepository());
final orderRepoProvider = Provider((_) => OrderRepository());

final allBooksProvider = FutureProvider((ref) =>
    ref.watch(bookRepoProvider).fetchAll());

final allCategoriesProvider = FutureProvider((ref) =>
    ref.watch(categoryRepoProvider).fetchAll());

final booksByCategoryProvider =
    FutureProvider.family<List<Book>, String>((ref, category) =>
        ref.watch(bookRepoProvider).fetchByCategory(category));

final bookByIdProvider =
    FutureProvider.family<Book?, String>((ref, id) =>
        ref.watch(bookRepoProvider).fetchById(id));

final searchBooksProvider =
    FutureProvider.family<List<Book>, String>((ref, query) =>
        ref.watch(bookRepoProvider).search(query));

final libraryProvider = FutureProvider((ref) =>
    ref.watch(libraryRepoProvider).fetchLibrary());

final allRequestsProvider = FutureProvider((ref) =>
    ref.watch(requestRepoProvider).fetchAll());

final requestByIdProvider =
    FutureProvider.family<BookRequest?, String>((ref, id) =>
        ref.watch(requestRepoProvider).fetchById(id));

final allOrdersProvider = FutureProvider((ref) =>
    ref.watch(orderRepoProvider).fetchAll());

final orderByIdProvider =
    FutureProvider.family<PhysicalOrder?, String>((ref, id) =>
        ref.watch(orderRepoProvider).fetchById(id));
