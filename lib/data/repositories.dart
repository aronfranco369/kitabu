import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/config/env.dart';
import 'models.dart';
import 'fixtures.dart';

SupabaseClient? get _db => Env.hasSupabase ? Supabase.instance.client : null;

// ── BookRepository ────────────────────────────────────────────────────────────

class BookRepository {
  Future<List<Book>> fetchAll() async {
    if (_db == null) return kBooks;
    final rows = await _db!.from('books').select().order('title');
    return rows.map((r) => Book.fromMap(r)).toList();
  }

  Future<Book?> fetchBySlug(String slug) async {
    if (_db == null) return kBooksBySlug[slug];
    final rows =
        await _db!.from('books').select().eq('slug', slug).limit(1);
    if (rows.isEmpty) return null;
    return Book.fromMap(rows.first);
  }

  Future<List<Book>> fetchByCategory(String category) async {
    if (_db == null) {
      return kBooks.where((b) => b.category == category).toList();
    }
    final rows = await _db!
        .from('books')
        .select()
        .eq('category', category)
        .order('rating', ascending: false);
    return rows.map((r) => Book.fromMap(r)).toList();
  }

  Future<List<Book>> search(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    if (_db == null) {
      return kBooks
          .where((b) =>
              b.title.toLowerCase().contains(q) ||
              b.author.toLowerCase().contains(q) ||
              b.tags.any((t) => t.toLowerCase().contains(q)))
          .toList();
    }
    final rows = await _db!
        .from('books')
        .select()
        .or('title.ilike.%$q%,author.ilike.%$q%')
        .order('rating', ascending: false);
    return rows.map((r) => Book.fromMap(r)).toList();
  }
}

// ── CategoryRepository ────────────────────────────────────────────────────────

class CategoryRepository {
  Future<List<Category>> fetchAll() async {
    if (_db == null) return kCategories;
    final rows =
        await _db!.from('categories').select().order('name');
    return rows.map((r) => Category.fromMap(r)).toList();
  }
}

// ── LibraryRepository ─────────────────────────────────────────────────────────

class LibraryRepository {
  Future<List<LibraryEntry>> fetchLibrary() async {
    if (_db == null) return kLibrary;
    final rows = await _db!
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
    if (_db == null) return kRequests;
    final rows = await _db!
        .from('requests')
        .select('*, request_events(*)')
        .order('created_at', ascending: false);
    return rows.map((r) => BookRequest.fromMap(r)).toList();
  }

  Future<BookRequest?> fetchById(String id) async {
    if (_db == null) {
      try {
        return kRequests.firstWhere((r) => r.id == id);
      } catch (_) {
        return null;
      }
    }
    final rows = await _db!
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
    if (_db == null) return;
    await _db!.from('requests').insert({
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
    if (_db == null) return kOrders;
    final rows = await _db!
        .from('orders')
        .select('*, books(*), order_steps(*)')
        .order('created_at', ascending: false);
    return rows.map((r) {
      final b = Book.fromMap(r['books'] as Map<String, dynamic>);
      return PhysicalOrder.fromMap(r, b);
    }).toList();
  }

  Future<PhysicalOrder?> fetchById(String id) async {
    if (_db == null) {
      try {
        return kOrders.firstWhere((o) => o.id == id);
      } catch (_) {
        return null;
      }
    }
    final rows = await _db!
        .from('orders')
        .select('*, books(*), order_steps(*)')
        .eq('id', id)
        .limit(1);
    if (rows.isEmpty) return null;
    final b =
        Book.fromMap(rows.first['books'] as Map<String, dynamic>);
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

final bookBySlugProvider =
    FutureProvider.family<Book?, String>((ref, slug) =>
        ref.watch(bookRepoProvider).fetchBySlug(slug));

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
