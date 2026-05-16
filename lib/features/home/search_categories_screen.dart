import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/kitabu_colors.dart';
import '../../core/theme/kitabu_text.dart';
import '../../core/icons/kitabu_icons.dart';
import '../../core/widgets/common.dart';
import '../../data/repositories.dart';

class SearchCategoriesScreen extends ConsumerStatefulWidget {
  const SearchCategoriesScreen({super.key});

  @override
  ConsumerState<SearchCategoriesScreen> createState() =>
      _SearchCategoriesScreenState();
}

class _SearchCategoriesScreenState
    extends ConsumerState<SearchCategoriesScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit(String q) {
    if (q.trim().isEmpty) return;
    context.push('/home/search/results?q=${Uri.encodeComponent(q.trim())}');
  }

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    final catsAsync = ref.watch(allCategoriesProvider);

    return Scaffold(
      backgroundColor: k.bg,
      appBar: AppBar(
        backgroundColor: k.bg,
        leading: CircleButton(
          icon: KSvg(KIcons.arrowLeft, size: 18, color: k.ink),
          onTap: () => context.pop(),
          color: k.paper,
        ),
        leadingWidth: 56,
        title: SearchField(
          controller: _ctrl,
          autofocus: true,
          hint: 'Search books, authors…',
          onSubmitted: _submit,
        ),
        titleSpacing: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(kGutter),
        children: [
          const SizedBox(height: 8),
          Text('Browse Categories',
              style:
                  KitabuText.ui(13, weight: FontWeight.w600, color: k.muted)),
          const SizedBox(height: 14),
          catsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
            data: (cats) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3,
              ),
              itemCount: cats.length,
              itemBuilder: (ctx, i) {
                final cat = cats[i];
                final color = Color(cat.color);
                return GestureDetector(
                  onTap: () => ctx.push(
                      '/home/search/results?q=${cat.slug}&cat=${cat.slug}'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: color.withValues(alpha: 0.28)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        Text(cat.icon,
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(cat.name,
                                  style: KitabuText.ui(13,
                                      weight: FontWeight.w600,
                                      color: k.ink)),
                              Text('${cat.bookCount} books',
                                  style: KitabuText.ui(11,
                                      color: k.muted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
