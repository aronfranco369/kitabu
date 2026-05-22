import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/kitabu_colors.dart';
import '../../core/theme/kitabu_text.dart';
import '../../core/icons/kitabu_icons.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/book_cover.dart';
import '../../data/models.dart';
import '../../data/repositories.dart';

class SearchResultsScreen extends ConsumerWidget {
  const SearchResultsScreen({super.key, required this.query, this.category});
  final String query;
  final String? category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final k = context.kit;
    final String title = category != null && category!.isNotEmpty
        ? category![0].toUpperCase() + category!.substring(1).replaceAll('-', ' ')
        : '"$query"';
    final resultsAsync = category != null && category!.isNotEmpty
        ? ref.watch(booksByCategoryProvider(category!))
        : ref.watch(searchBooksProvider(query));

    return Scaffold(
      backgroundColor: k.bg,
      appBar: BackTopBar(
        title: title,
        onBack: () => context.pop(),
      ),
      body: resultsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (books) {
          if (books.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  KSvg(KIcons.search, size: 48, color: k.muted2),
                  const SizedBox(height: 16),
                  Text('No results for "$query"',
                      style: KitabuText.ui(16,
                          weight: FontWeight.w600, color: k.ink)),
                  const SizedBox(height: 8),
                  Text('Try a different search term',
                      style: KitabuText.ui(14, color: k.muted)),
                  const SizedBox(height: 24),
                  Cta(
                    'Request this book',
                    variant: CtaVariant.secondary,
                    onTap: () => context.push(
                        '/requests/new?title=${Uri.encodeComponent(query)}'),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(kGutter),
            itemCount: books.length,
            separatorBuilder: (_, _) =>
                Divider(height: 1, color: k.hairline),
            itemBuilder: (ctx, i) => _BookRow(book: books[i]),
          );
        },
      ),
    );
  }
}

class _BookRow extends StatelessWidget {
  const _BookRow({required this.book});
  final Book book;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    return GestureDetector(
      onTap: () => context.push('/home/book/${book.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            BookCover(book, width: 56, height: 80, badge: false),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (book.isFree)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: StatusPill('FREE',
                          color: k.free, bgColor: k.freeSoft),
                    ),
                  Text(book.title,
                      style: KitabuText.ui(14,
                          weight: FontWeight.w700, color: k.ink),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(book.author,
                      style: KitabuText.ui(12, color: k.muted)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text('${book.pageCount} pp',
                          style: KitabuText.ui(11, color: k.muted)),
                      if (book.year != null) ...[
                        const SizedBox(width: 6),
                        Dot(color: k.muted2),
                        const SizedBox(width: 6),
                        Text('${book.year}',
                            style: KitabuText.ui(11, color: k.muted)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            KSvg(KIcons.chevronRight, size: 16, color: k.muted2),
          ],
        ),
      ),
    );
  }
}
