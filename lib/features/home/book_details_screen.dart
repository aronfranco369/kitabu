import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/kitabu_colors.dart';
import '../../core/theme/kitabu_text.dart';
import '../../core/icons/kitabu_icons.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/book_cover.dart';
import '../../data/repositories.dart';

class BookDetailsScreen extends ConsumerWidget {
  const BookDetailsScreen({super.key, required this.slug});
  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final k = context.kit;
    final bookAsync = ref.watch(bookBySlugProvider(slug));

    return bookAsync.when(
      loading: () => Scaffold(
        backgroundColor: k.bg,
        appBar: BackTopBar(onBack: () => context.pop()),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: k.bg,
        appBar: BackTopBar(onBack: () => context.pop()),
        body: Center(child: Text('Error: $e')),
      ),
      data: (book) {
        if (book == null) {
          return Scaffold(
            backgroundColor: k.bg,
            appBar: BackTopBar(onBack: () => context.pop()),
            body: const Center(child: Text('Book not found')),
          );
        }
        return Scaffold(
          backgroundColor: k.bg,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: k.bg,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: CircleButton(
                    icon: KSvg(KIcons.arrowLeft,
                        size: 18, color: k.ink),
                    onTap: () => context.pop(),
                    color: k.paper,
                  ),
                ),
                actions: [
                  CircleButton(
                    icon: KSvg(KIcons.share, size: 18, color: k.ink),
                    color: k.paper,
                  ),
                  const SizedBox(width: 12),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: k.surface,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: BookCover(book,
                            width: 140, height: 200, badge: false),
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(kGutter),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (book.isFree)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: StatusPill('FREE',
                            color: k.free, bgColor: k.freeSoft),
                      ),
                    Text(book.title,
                        style: KitabuText.ui(22,
                            weight: FontWeight.w800, color: k.ink)),
                    const SizedBox(height: 6),
                    Text(book.author,
                        style:
                            KitabuText.ui(15, color: k.muted)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        KSvg(KIcons.starFilled,
                            size: 14, color: k.gold),
                        const SizedBox(width: 5),
                        Text(book.rating.toStringAsFixed(1),
                            style: KitabuText.ui(14,
                                weight: FontWeight.w700,
                                color: k.ink)),
                        const SizedBox(width: 4),
                        Text('(${book.reviewCount})',
                            style: KitabuText.ui(13,
                                color: k.muted)),
                        const SizedBox(width: 14),
                        Dot(color: k.muted2),
                        const SizedBox(width: 14),
                        Text('${book.pageCount} pages',
                            style: KitabuText.ui(13,
                                color: k.muted)),
                        if (book.publishedYear != null) ...[
                          const SizedBox(width: 14),
                          Dot(color: k.muted2),
                          const SizedBox(width: 14),
                          Text('${book.publishedYear}',
                              style: KitabuText.ui(13,
                                  color: k.muted)),
                        ],
                      ],
                    ),
                    const SizedBox(height: 20),
                    Divider(color: k.hairline),
                    const SizedBox(height: 16),
                    Text('About this book',
                        style: KitabuText.ui(15,
                            weight: FontWeight.w700, color: k.ink)),
                    const SizedBox(height: 10),
                    Text(book.description,
                        style: KitabuText.serif(15,
                            color: k.ink2, height: 1.7)),
                    const SizedBox(height: 20),
                    if (book.tags.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: book.tags
                            .map((t) => KChip(t))
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                    ],
                    Divider(color: k.hairline),
                    const SizedBox(height: 16),
                    _InfoRow('Language', book.language),
                    if (book.publisher != null)
                      _InfoRow('Publisher', book.publisher!),
                    _InfoRow('Category', book.category),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
          bottomNavigationBar: StickyBottom(
            child: Row(
              children: [
                if (book.physicalPrice != null) ...[
                  Expanded(
                    child: Cta(
                      'Order Physical',
                      variant: CtaVariant.secondary,
                      icon: KSvg(KIcons.box, size: 16,
                          color: k.accent),
                      onTap: () => context
                          .push('/order/book/${book.slug}'),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Cta(
                    book.isFree ? 'Read Free' : 'Add to Library',
                    icon: KSvg(KIcons.bookOpen, size: 16,
                        color: Colors.white),
                    onTap: () =>
                        context.push('/library/read/${book.slug}'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: KitabuText.ui(13, color: k.muted)),
          ),
          Expanded(
            child: Text(value,
                style: KitabuText.ui(13,
                    weight: FontWeight.w600, color: k.ink)),
          ),
        ],
      ),
    );
  }
}
