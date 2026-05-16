import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/kitabu_colors.dart';
import '../../core/theme/kitabu_text.dart';
import '../../core/theme/kitabu_theme.dart';
import '../../core/icons/kitabu_icons.dart';
import '../../core/widgets/common.dart';
import '../../data/repositories.dart';

class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: KitabuTheme.clay(),
      child: Builder(builder: (ctx) {
        final k = ctx.kit;
        final orderAsync = ref.watch(orderByIdProvider('ord-2'));

        return Scaffold(
          backgroundColor: k.bg,
          body: orderAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (order) => ListView(
              padding: EdgeInsets.fromLTRB(
                kGutter,
                MediaQuery.of(ctx).padding.top + 40,
                kGutter,
                kGutter,
              ),
              children: [
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: k.free.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: KSvg(KIcons.check,
                          size: 36, color: k.free),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Order Placed!',
                    style: KitabuText.ui(26,
                        weight: FontWeight.w800, color: k.ink),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(
                  'Your physical book is on its way.',
                  style: KitabuText.ui(15, color: k.muted),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (order != null) ...[
                  KCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ConfRow('Order ID', '#${order.id}', k),
                        _ConfRow(
                            'Book', order.book.title, k),
                        _ConfRow(
                            'Total',
                            'KES ${order.totalPrice.toStringAsFixed(0)}',
                            k),
                        if (order.trackingNumber != null)
                          _ConfRow('Tracking',
                              order.trackingNumber!, k),
                        if (order.estimatedDelivery != null)
                          _ConfRow(
                              'Est. Delivery',
                              '${order.estimatedDelivery!.day}/${order.estimatedDelivery!.month}/${order.estimatedDelivery!.year}',
                              k),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Order Progress',
                      style: KitabuText.ui(15,
                          weight: FontWeight.w700, color: k.ink)),
                  const SizedBox(height: 14),
                  ...order.steps.asMap().entries.map((e) {
                    final i = e.key;
                    final step = e.value;
                    final isLast = i == order.steps.length - 1;
                    return _TimelineStep(
                      step: step,
                      isLast: isLast,
                    );
                  }),
                ],
                const SizedBox(height: 32),
                Cta(
                  'Continue Shopping',
                  full: true,
                  variant: CtaVariant.secondary,
                  onTap: () => ctx.go('/order'),
                ),
                const SizedBox(height: 12),
                Cta(
                  'View Order History',
                  full: true,
                  variant: CtaVariant.ghost,
                  onTap: () => ctx.push('/profile/orders'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _ConfRow extends StatelessWidget {
  const _ConfRow(this.label, this.value, this.k);
  final String label;
  final String value;
  final KitabuColors k;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            SizedBox(
              width: 110,
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

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({required this.step, required this.isLast});
  final dynamic step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    final done = step.isComplete as bool;
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: done ? k.free : k.hairline,
                  shape: BoxShape.circle,
                ),
                child: done
                    ? Center(
                        child:
                            KSvg(KIcons.check, size: 11, color: Colors.white))
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: done ? k.free.withValues(alpha: 0.3) : k.hairline,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.label as String,
                      style: KitabuText.ui(14,
                          weight: FontWeight.w600,
                          color: done ? k.ink : k.muted)),
                  if (step.completedAt != null)
                    Text(
                      '${(step.completedAt as DateTime).day}/${(step.completedAt as DateTime).month}',
                      style: KitabuText.ui(11, color: k.muted),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
