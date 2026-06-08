import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../models/library_item.dart';
import '../models/media.dart';
import '../theme/app_theme.dart';
import '../widgets/movie_card.dart';
import '../widgets/sinemax_icon.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _tabs.animation!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SinemaxColors.bg,
      appBar: AppBar(
        backgroundColor: SinemaxColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Library', style: SinemaxTextStyles.display(22, weight: FontWeight.w700)),
        bottom: _PillTabBar(controller: _tabs),
      ),
      body: TabBarView(controller: _tabs, children: [_RecentTab(), _SavedTab(), _DownloadsTab()]),
    );
  }
}

class _PillTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  const _PillTabBar({required this.controller});

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    final labels = ['Recent', 'Saved', 'Downloads'];
    final activeIndex = (controller.animation?.value ?? controller.index.toDouble()).round();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(color: SinemaxColors.panel, borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: List.generate(labels.length, (i) {
            final selected = activeIndex == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.animateTo(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(color: selected ? SinemaxColors.blue : Colors.transparent, borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: SinemaxTextStyles.body(13, weight: selected ? FontWeight.w600 : FontWeight.w400, color: selected ? Colors.white : SinemaxColors.muted),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ── Recent ────────────────────────────────────────────────────────────────────

class _RecentTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(recentContentProvider);

    return recentAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => _Empty(icon: 'clock', message: 'Failed to load'),
      data: (pairs) {
        if (pairs.isEmpty) {
          return _Empty(icon: 'clock', message: 'Nothing watched yet');
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: pairs.length,
          itemBuilder: (context, i) {
            final (item, media) = pairs[i];
            return MovieCard(
              media: media,
              meta: '${_fmtDate(item.watchedAt)}${item.context.isNotEmpty ? ' · ${item.context}' : ''}',
              progress: item.progress > 0 && item.progress < 1 ? item.progress : null,
              onTap: () => context.push('/detail/${media.id}'),
            );
          },
        );
      },
    );
  }
}

// ── Saved ─────────────────────────────────────────────────────────────────────

class _SavedTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedAsync = ref.watch(savedContentProvider);

    return savedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => _Empty(icon: 'bookmark', message: 'Failed to load'),
      data: (saved) {
        if (saved.isEmpty) {
          return _Empty(icon: 'bookmark', message: 'No saved titles yet');
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: saved.length,
          itemBuilder: (context, i) {
            final media = saved[i];
            return MovieCard(
              media: media,
              trailing: GestureDetector(
                onTap: () => ref.read(savedProvider.notifier).toggle(media.id),
                child: const SinemaxIcon('x', size: 18, color: SinemaxColors.muted2),
              ),
              onTap: () => context.push('/detail/${media.id}'),
            );
          },
        );
      },
    );
  }
}

// ── Downloads ─────────────────────────────────────────────────────────────────

class _DownloadsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dlAsync = ref.watch(downloadsContentProvider);

    return dlAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => _Empty(icon: 'download', message: 'Failed to load'),
      data: (pairs) {
        if (pairs.isEmpty) {
          return _Empty(icon: 'download', message: 'No downloads yet');
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: pairs.length,
          itemBuilder: (context, i) {
            final (dl, media) = pairs[i];
            return MovieCard(
              media: media,
              meta: '${dl.quality} · ${dl.size} · ${_fmtDate(dl.at)}',
              trailing: GestureDetector(
                onTap: () => ref.read(downloadsProvider.notifier).remove(dl.contentId),
                child: const SinemaxIcon('trash', size: 18, color: SinemaxColors.muted2),
              ),
              onTap: () => context.push('/detail/${media.id}'),
            );
          },
        );
      },
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _Empty extends StatelessWidget {
  final String icon;
  final String message;
  const _Empty({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SinemaxIcon(icon, size: 44, color: SinemaxColors.muted2),
          const SizedBox(height: 14),
          Text(message, style: SinemaxTextStyles.body(15, color: SinemaxColors.muted)),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

String _fmtDate(String isoStr) {
  try {
    final dt = DateTime.parse(isoStr);
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}';
  } catch (_) {
    return isoStr;
  }
}
