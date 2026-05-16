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

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final k = context.kit;
    final libraryAsync = ref.watch(libraryProvider);

    return Scaffold(
      backgroundColor: k.bg,
      appBar: AppBar(
        backgroundColor: k.bg,
        titleSpacing: kGutter,
        title: Text('My Library',
            style: KitabuText.ui(20,
                weight: FontWeight.w800, color: k.ink)),
      ),
      body: libraryAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (entries) {
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  KSvg(KIcons.bookmark, size: 48, color: k.muted2),
                  const SizedBox(height: 16),
                  Text('Your library is empty',
                      style: KitabuText.ui(16,
                          weight: FontWeight.w600, color: k.ink)),
                  const SizedBox(height: 8),
                  Text('Add books from the catalog',
                      style: KitabuText.ui(14, color: k.muted)),
                  const SizedBox(height: 24),
                  Cta(
                    'Browse Books',
                    variant: CtaVariant.secondary,
                    onTap: () => context.go('/home'),
                  ),
                ],
              ),
            );
          }

          final inProgress = entries
              .where((e) => e.readProgress > 0 && e.readProgress < 1)
              .toList();
          final completed =
              entries.where((e) => e.readProgress >= 1).toList();
          final notStarted =
              entries.where((e) => e.readProgress == 0).toList();

          return ListView(
            padding: const EdgeInsets.all(kGutter),
            children: [
              if (inProgress.isNotEmpty) ...[
                RowHead('Continue Reading'),
                const SizedBox(height: 14),
                ...inProgress.map((e) => _LibraryCard(entry: e)),
                const SizedBox(height: 24),
              ],
              if (notStarted.isNotEmpty) ...[
                RowHead('Not Started'),
                const SizedBox(height: 14),
                ...notStarted.map((e) => _LibraryCard(entry: e)),
                const SizedBox(height: 24),
              ],
              if (completed.isNotEmpty) ...[
                RowHead('Finished'),
                const SizedBox(height: 14),
                ...completed.map((e) => _LibraryCard(entry: e)),
              ],
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}

class _LibraryCard extends StatelessWidget {
  const _LibraryCard({required this.entry});
  final LibraryEntry entry;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    final b = entry.book;
    final pct = (entry.readProgress * 100).round();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => context.push('/library/read/${b.slug}'),
        child: KCard(
          child: Row(
            children: [
              BookCover(b, width: 72, height: 104, badge: false),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b.title,
                        style: KitabuText.ui(14,
                            weight: FontWeight.w700, color: k.ink),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(b.author,
                        style: KitabuText.ui(12, color: k.muted)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ProgressBar(entry.readProgress,
                              color: entry.readProgress >= 1
                                  ? k.free
                                  : k.accent),
                        ),
                        const SizedBox(width: 10),
                        Text('$pct%',
                            style: KitabuText.ui(11,
                                weight: FontWeight.w600,
                                color: entry.readProgress >= 1
                                    ? k.free
                                    : k.accent)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        KSvg(KIcons.bookOpen, size: 12, color: k.accent),
                        const SizedBox(width: 5),
                        Text(
                          entry.readProgress >= 1
                              ? 'Finished'
                              : entry.readProgress == 0
                                  ? 'Start reading'
                                  : '${(entry.readProgress * b.pageCount).round()} of ${b.pageCount} pages',
                          style: KitabuText.ui(11,
                              weight: FontWeight.w600, color: k.accent),
                        ),
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
  }
}
