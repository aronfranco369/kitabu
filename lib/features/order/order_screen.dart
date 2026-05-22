import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/kitabu_colors.dart';
import '../../core/theme/kitabu_text.dart';
import '../../core/theme/kitabu_theme.dart';
import '../../core/icons/kitabu_icons.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/book_cover.dart';
import '../../data/models.dart';
import '../../data/repositories.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: KitabuTheme.clay(),
      child: Builder(builder: (ctx) {
        final k = ctx.kit;
        final booksAsync = ref.watch(allBooksProvider);

        return Scaffold(
          backgroundColor: k.bg,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: k.bg,
                scrolledUnderElevation: 0,
                titleSpacing: kGutter,
                title: Text('Physical Books',
                    style: KitabuText.ui(20,
                        weight: FontWeight.w800, color: k.ink)),
                actions: [
                  CircleButton(
                    icon: KSvg(KIcons.cart, size: 18, color: k.ink),
                    onTap: () => ctx.push('/order/cart'),
                    color: k.paper,
                  ),
                  const SizedBox(width: kGutter),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      kGutter, 8, kGutter, 20),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: k.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: k.accent.withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      children: [
                        KSvg(KIcons.truck, size: 22, color: k.accent),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Free delivery on orders over KES 3,000',
                                  style: KitabuText.ui(13,
                                      weight: FontWeight.w600,
                                      color: k.ink)),
                              Text('Nairobi & major towns',
                                  style: KitabuText.ui(11,
                                      color: k.muted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kGutter),
                  child: RowHead('Available for Order'),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 14)),
              booksAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: Center(child: Text('Error: $e')),
                ),
                data: (books) {
                  final orderable =
                      books.where((b) => !b.isFree && b.price > 0).toList();
                  if (orderable.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(child: Text('No books available for order')),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kGutter),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (c, i) => _PhysicalBookCard(book: orderable[i]),
                        childCount: orderable.length,
                      ),
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        );
      }),
    );
  }
}

class _PhysicalBookCard extends StatelessWidget {
  const _PhysicalBookCard({required this.book});
  final Book book;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: KCard(
        onTap: () => context.push('/order/book/${book.id}'),
        child: Row(
          children: [
            BookCover(book, width: 72, height: 104, badge: false),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title,
                      style: KitabuText.ui(14,
                          weight: FontWeight.w700, color: k.ink),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(book.author,
                      style: KitabuText.ui(12, color: k.muted)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'KES ${(book.discountPrice ?? book.price).toStringAsFixed(0)}',
                        style: KitabuText.ui(15,
                            weight: FontWeight.w800, color: k.accent),
                      ),
                      if (book.discountPrice != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          'KES ${book.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: k.muted,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: k.accent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Add to Cart',
                            style: KitabuText.ui(12,
                                weight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
