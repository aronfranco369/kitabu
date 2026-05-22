import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../core/theme/kitabu_colors.dart';
import '../../core/theme/kitabu_text.dart';
import '../../core/icons/kitabu_icons.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/book_cover.dart';
import '../../data/models.dart';
import '../../data/repositories.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final k = context.kit;
    final booksAsync = ref.watch(allBooksProvider);
    final catsAsync = ref.watch(allCategoriesProvider);

    return Scaffold(
      backgroundColor: k.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: k.bg,
            scrolledUnderElevation: 0,
            titleSpacing: kGutter,
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    'Kitabu',
                    style: KitabuText.serif(24, weight: FontWeight.w700, color: k.ink),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(kGutter, 8, kGutter, 16),
              child: GestureDetector(
                onTap: () => context.push('/home/search'),
                child: AbsorbPointer(child: SearchField(hint: 'Search books, authors…')),
              ),
            ),
          ),
          // Categories
          SliverToBoxAdapter(
            child: catsAsync.when(
              loading: () => const SizedBox(height: 80),
              error: (_, __) => const SizedBox.shrink(),
              data: (cats) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kGutter),
                    child: RowHead('Browse by Category'),
                  ),
                  const SizedBox(height: 12),
                  HRow(children: cats.map((c) => _CategoryChip(cat: c)).toList()),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // New Arrivals
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kGutter),
              child: RowHead('New Arrivals', action: 'See all', onAction: () => context.push('/home/search/results?q=')),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          booksAsync.when(
            loading: () => _buildBookGridShimmer(),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox()),
            data: (books) {
              final items = books.take(6).toList();
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: kGutter),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((ctx, i) => _BookGridItem(book: items[i]), childCount: items.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.58, crossAxisSpacing: 12, mainAxisSpacing: 16),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildBookGridShimmer() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: kGutter),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((_, __) => Skeletonizer(child: Container(color: Colors.grey, height: 200)), childCount: 6),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.58, crossAxisSpacing: 12, mainAxisSpacing: 16),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.cat});
  final Category cat;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    final color = Color(cat.color);
    return GestureDetector(
      onTap: () => context.push('/home/search/results?q=${cat.slug}&cat=${cat.slug}'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(cat.icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              cat.name,
              style: KitabuText.ui(13, weight: FontWeight.w600, color: k.ink),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookGridItem extends StatelessWidget {
  const _BookGridItem({required this.book});
  final Book book;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    return GestureDetector(
      onTap: () => context.push('/home/book/${book.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => BookCover(
                book,
                width: double.infinity,
                height: constraints.maxHeight,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            book.title,
            style: KitabuText.ui(11, weight: FontWeight.w600, color: k.ink),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            book.author,
            style: KitabuText.ui(10, color: k.muted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
