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
                  child: Text('Kitabu',
                      style: KitabuText.serif(24,
                          weight: FontWeight.w700, color: k.ink)),
                ),
                CircleButton(
                  icon: KSvg(KIcons.search, size: 18, color: k.ink),
                  onTap: () => context.push('/home/search'),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(kGutter, 8, kGutter, 16),
              child: GestureDetector(
                onTap: () => context.push('/home/search'),
                child: AbsorbPointer(
                  child: SearchField(hint: 'Search books, authors…'),
                ),
              ),
            ),
          ),
          // Featured / Free section
          SliverToBoxAdapter(
            child: booksAsync.when(
              loading: () => _FeaturedShimmer(),
              error: (_, __) => const SizedBox.shrink(),
              data: (books) {
                final free = books.where((b) => b.isFree).take(4).toList();
                if (free.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kGutter, vertical: 4),
                      child: RowHead(
                        'Free to Read',
                        action: 'See all',
                        onAction: () => context.push(
                            '/home/search/results?q=free'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _FeaturedCarousel(books: free),
                    const SizedBox(height: 24),
                  ],
                );
              },
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: kGutter),
                    child: RowHead('Browse by Category'),
                  ),
                  const SizedBox(height: 12),
                  HRow(
                    children: cats
                        .map((c) => _CategoryChip(cat: c))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // New Arrivals
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kGutter),
              child: RowHead(
                'New Arrivals',
                action: 'See all',
                onAction: () =>
                    context.push('/home/search/results?q='),
              ),
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
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => _BookGridItem(book: items[i]),
                    childCount: items.length,
                  ),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.58,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                  ),
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
        delegate: SliverChildBuilderDelegate(
          (_, __) => Skeletonizer(
            child: Container(
              color: Colors.grey,
              height: 200,
            ),
          ),
          childCount: 6,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.58,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
        ),
      ),
    );
  }
}

class _FeaturedCarousel extends StatelessWidget {
  const _FeaturedCarousel({required this.books});
  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: kGutter),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: books.length,
        itemBuilder: (ctx, i) {
          final b = books[i];
          return GestureDetector(
            onTap: () => ctx.push('/home/book/${b.slug}'),
            child: SizedBox(
              width: 300,
              child: KCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    BookCover(b, width: 88, height: 124),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: k.freeSoft,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('FREE',
                                style: KitabuText.ui(10,
                                    weight: FontWeight.w700,
                                    color: k.free)),
                          ),
                          const SizedBox(height: 8),
                          Text(b.title,
                              style: KitabuText.ui(14,
                                  weight: FontWeight.w700, color: k.ink),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text(b.author,
                              style: KitabuText.ui(12, color: k.muted),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              KSvg(KIcons.starFilled,
                                  size: 12, color: k.gold),
                              const SizedBox(width: 4),
                              Text(b.rating.toStringAsFixed(1),
                                  style: KitabuText.ui(12,
                                      weight: FontWeight.w600,
                                      color: k.ink)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
      onTap: () =>
          context.push('/home/search/results?q=${cat.slug}&cat=${cat.slug}'),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
            Text(cat.name,
                style: KitabuText.ui(13,
                    weight: FontWeight.w600, color: k.ink)),
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
      onTap: () => context.push('/home/book/${book.slug}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookCover(book, width: double.infinity, height: 140),
          const SizedBox(height: 6),
          Text(book.title,
              style:
                  KitabuText.ui(11, weight: FontWeight.w600, color: k.ink),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(book.author,
              style: KitabuText.ui(10, color: k.muted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _FeaturedShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Skeletonizer(
        child: SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: kGutter),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: 3,
            itemBuilder: (_, __) => Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      );
}
