import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/kitabu_colors.dart';
import '../../core/theme/kitabu_text.dart';
import '../../core/icons/kitabu_icons.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';
import '../../data/repositories.dart';

class RequestsScreen extends ConsumerWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final k = context.kit;
    final requestsAsync = ref.watch(allRequestsProvider);

    return Scaffold(
      backgroundColor: k.bg,
      appBar: AppBar(
        backgroundColor: k.bg,
        titleSpacing: kGutter,
        title: Text('Book Requests',
            style: KitabuText.ui(20,
                weight: FontWeight.w800, color: k.ink)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: kGutter),
            child: Cta(
              'New Request',
              icon: KSvg(KIcons.plus, size: 14, color: Colors.white),
              onTap: () => context.push('/requests/new'),
            ),
          ),
        ],
      ),
      body: requestsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (requests) {
          if (requests.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  KSvg(KIcons.messageSquare, size: 48, color: k.muted2),
                  const SizedBox(height: 16),
                  Text('No requests yet',
                      style: KitabuText.ui(16,
                          weight: FontWeight.w600, color: k.ink)),
                  const SizedBox(height: 8),
                  Text("Can't find a book? Request it!",
                      style: KitabuText.ui(14, color: k.muted)),
                  const SizedBox(height: 24),
                  Cta(
                    'Make a Request',
                    onTap: () => context.push('/requests/new'),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(kGutter),
            itemCount: requests.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) =>
                _RequestCard(request: requests[i]),
          );
        },
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request});
  final BookRequest request;

  Color _statusColor(BuildContext context) {
    final k = context.kit;
    switch (request.status) {
      case RequestStatus.available:
        return k.free;
      case RequestStatus.unavailable:
        return Colors.red.shade400;
      case RequestStatus.sourcing:
        return k.gold;
      case RequestStatus.inReview:
        return k.accent;
      default:
        return k.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    final color = _statusColor(context);

    return GestureDetector(
      onTap: () =>
          context.push('/requests/${request.id}'),
      child: KCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(request.title,
                      style: KitabuText.ui(15,
                          weight: FontWeight.w700, color: k.ink),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                StatusPill(request.status.label, color: color),
              ],
            ),
            if (request.author.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(request.author,
                  style: KitabuText.ui(13, color: k.muted)),
            ],
            if (request.note.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(request.note,
                  style: KitabuText.ui(12, color: k.muted),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                KSvg(KIcons.clock, size: 12, color: k.muted2),
                const SizedBox(width: 5),
                Text(
                  '${request.createdAt.day}/${request.createdAt.month}/${request.createdAt.year}',
                  style: KitabuText.ui(11, color: k.muted),
                ),
                const Spacer(),
                if (request.events.isNotEmpty)
                  Text(
                    '${request.events.length} update${request.events.length != 1 ? 's' : ''}',
                    style: KitabuText.ui(11,
                        weight: FontWeight.w600, color: k.accent),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
