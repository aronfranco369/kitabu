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

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  Color _statusColor(String status, KitabuColors k) {
    switch (status) {
      case 'delivered':
        return k.free;
      case 'shipped':
        return k.accent;
      case 'processing':
        return k.gold;
      default:
        return k.muted;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final k = context.kit;
    final ordersAsync = ref.watch(allOrdersProvider);

    return Scaffold(
      backgroundColor: k.bg,
      appBar: BackTopBar(
        title: 'Order History',
        onBack: () => context.pop(),
      ),
      body: ordersAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  KSvg(KIcons.truck, size: 48, color: k.muted2),
                  const SizedBox(height: 16),
                  Text('No orders yet',
                      style: KitabuText.ui(16,
                          weight: FontWeight.w600, color: k.ink)),
                  const SizedBox(height: 24),
                  Cta(
                    'Browse Physical Books',
                    variant: CtaVariant.secondary,
                    onTap: () => context.go('/order'),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(kGutter),
            itemCount: orders.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) =>
                _OrderCard(order: orders[i], k: k,
                    statusColor: _statusColor(orders[i].status, k)),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.k,
    required this.statusColor,
  });
  final PhysicalOrder order;
  final KitabuColors k;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/order/confirmation/${order.id}'),
      child: KCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('#${order.id}',
                    style: KitabuText.mono(12, color: k.muted)),
                const Spacer(),
                StatusPill(
                  order.status[0].toUpperCase() +
                      order.status.substring(1),
                  color: statusColor,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                BookCover(order.book,
                    width: 52, height: 76, badge: false),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.book.title,
                          style: KitabuText.ui(14,
                              weight: FontWeight.w700, color: k.ink),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text('Qty: ${order.quantity}',
                          style: KitabuText.ui(12, color: k.muted)),
                      const SizedBox(height: 6),
                      Text(
                          'KES ${order.totalPrice.toStringAsFixed(0)}',
                          style: KitabuText.ui(15,
                              weight: FontWeight.w800,
                              color: k.ink)),
                    ],
                  ),
                ),
              ],
            ),
            if (order.trackingNumber != null) ...[
              const SizedBox(height: 12),
              Divider(color: k.hairline),
              const SizedBox(height: 10),
              Row(
                children: [
                  KSvg(KIcons.truck, size: 13, color: k.muted),
                  const SizedBox(width: 6),
                  Text(order.trackingNumber!,
                      style: KitabuText.mono(12, color: k.muted)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
