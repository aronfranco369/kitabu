import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/kitabu_colors.dart';
import '../../core/theme/kitabu_text.dart';
import '../../core/icons/kitabu_icons.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';
import '../../data/repositories.dart';

class RequestDetailsScreen extends ConsumerWidget {
  const RequestDetailsScreen({super.key, required this.id});
  final String id;

  Color _statusColor(RequestStatus s, KitabuColors k) {
    switch (s) {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final k = context.kit;
    final requestAsync = ref.watch(requestByIdProvider(id));

    return Scaffold(
      backgroundColor: k.bg,
      appBar: BackTopBar(
        title: 'Request Details',
        onBack: () => context.pop(),
      ),
      body: requestAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (request) {
          if (request == null) {
            return const Center(child: Text('Request not found'));
          }
          final color = _statusColor(request.status, k);
          return ListView(
            padding: const EdgeInsets.all(kGutter),
            children: [
              KCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(request.title,
                              style: KitabuText.ui(18,
                                  weight: FontWeight.w800, color: k.ink)),
                        ),
                        StatusPill(request.status.label,
                            color: color),
                      ],
                    ),
                    if (request.author.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(request.author,
                          style: KitabuText.ui(14, color: k.muted)),
                    ],
                    if (request.note.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Divider(color: k.hairline),
                      const SizedBox(height: 12),
                      Text('Your note',
                          style: KitabuText.ui(12,
                              weight: FontWeight.w600, color: k.muted)),
                      const SizedBox(height: 6),
                      Text(request.note,
                          style: KitabuText.serif(14,
                              color: k.ink2, height: 1.6)),
                    ],
                    const SizedBox(height: 12),
                    Divider(color: k.hairline),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        KSvg(KIcons.clock, size: 12, color: k.muted2),
                        const SizedBox(width: 5),
                        Text(
                          'Submitted ${request.createdAt.day}/${request.createdAt.month}/${request.createdAt.year}',
                          style: KitabuText.ui(12, color: k.muted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (request.status == RequestStatus.available) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: k.freeSoft,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: k.free.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      KSvg(KIcons.check, size: 20, color: k.free),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('This book is now available!',
                                style: KitabuText.ui(14,
                                    weight: FontWeight.w700,
                                    color: k.free)),
                            Text('Find it in the catalog',
                                style: KitabuText.ui(12, color: k.muted)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/home'),
                        child: Text('View',
                            style: KitabuText.ui(13,
                                weight: FontWeight.w700,
                                color: k.free)),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              if (request.events.isNotEmpty) ...[
                Text('Timeline',
                    style: KitabuText.ui(15,
                        weight: FontWeight.w700, color: k.ink)),
                const SizedBox(height: 14),
                ...request.events.asMap().entries.map((entry) {
                  final i = entry.key;
                  final evt = entry.value;
                  final isLast = i == request.events.length - 1;
                  final evtColor =
                      _statusColor(evt.status, k);
                  return IntrinsicHeight(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: evtColor.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: evtColor, width: 1.5),
                              ),
                              child: Center(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: evtColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            if (!isLast)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  color: k.hairline,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    StatusPill(evt.status.label,
                                        color: evtColor),
                                    const Spacer(),
                                    Text(
                                      '${evt.createdAt.day}/${evt.createdAt.month}',
                                      style: KitabuText.ui(11,
                                          color: k.muted),
                                    ),
                                  ],
                                ),
                                if (evt.note.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(evt.note,
                                      style: KitabuText.ui(13,
                                          color: k.ink2, height: 1.5)),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}
