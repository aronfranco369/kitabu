import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/kitabu_colors.dart';
import '../../core/theme/kitabu_text.dart';
import '../../core/theme/kitabu_theme.dart';
import '../../core/icons/kitabu_icons.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/book_cover.dart';
import '../../data/repositories.dart';

class CartCheckoutScreen extends ConsumerWidget {
  const CartCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: KitabuTheme.clay(),
      child: Builder(builder: (ctx) {
        final k = ctx.kit;
        final booksAsync = ref.watch(allBooksProvider);

        return booksAsync.when(
          loading: () => Scaffold(
            backgroundColor: k.bg,
            appBar: BackTopBar(title: 'Cart', onBack: () => ctx.pop()),
            body: const Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Scaffold(
            backgroundColor: k.bg,
            appBar: BackTopBar(title: 'Cart', onBack: () => ctx.pop()),
            body: Center(child: Text('Error: $e')),
          ),
          data: (books) {
            final cartBooks = books
                .where((b) => !b.isFree && b.price > 0)
                .take(2)
                .toList();
            final subtotal = cartBooks.fold<double>(
                0, (s, b) => s + (b.discountPrice ?? b.price));

            return Scaffold(
              backgroundColor: k.bg,
              appBar: BackTopBar(
                title: 'Cart',
                onBack: () => ctx.pop(),
              ),
              body: ListView(
                padding: const EdgeInsets.all(kGutter),
                children: [
                  ...cartBooks.map((b) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: KCard(
                          child: Row(
                            children: [
                              BookCover(b,
                                  width: 60, height: 88, badge: false),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(b.title,
                                        style: KitabuText.ui(13,
                                            weight: FontWeight.w700,
                                            color: k.ink),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 4),
                                    Text(b.author,
                                        style: KitabuText.ui(11,
                                            color: k.muted)),
                                    const SizedBox(height: 8),
                                    Text(
                                      'KES ${(b.discountPrice ?? b.price).toStringAsFixed(0)}',
                                      style: KitabuText.ui(14,
                                          weight: FontWeight.w800,
                                          color: k.accent),
                                    ),
                                  ],
                                ),
                              ),
                              CircleButton(
                                icon: KSvg(KIcons.minus,
                                    size: 14, color: k.muted),
                                size: 32,
                              ),
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(height: 8),
                  Divider(color: k.hairline),
                  const SizedBox(height: 16),
                  _SummaryRow('Subtotal',
                      'KES ${subtotal.toStringAsFixed(0)}', k),
                  _SummaryRow('Delivery', 'KES 200', k),
                  const SizedBox(height: 8),
                  Divider(color: k.hairline),
                  const SizedBox(height: 8),
                  _SummaryRow(
                      'Total',
                      'KES ${(subtotal + 200).toStringAsFixed(0)}',
                      k,
                      bold: true),
                  const SizedBox(height: 24),
                  Text('Shipping Address',
                      style: KitabuText.ui(15,
                          weight: FontWeight.w700, color: k.ink)),
                  const SizedBox(height: 12),
                  KCard(
                    child: Row(
                      children: [
                        KSvg(KIcons.truck, size: 18, color: k.accent),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('14 Kimathi Street',
                                  style: KitabuText.ui(14,
                                      weight: FontWeight.w600,
                                      color: k.ink)),
                              Text('Nairobi, 00100',
                                  style: KitabuText.ui(12,
                                      color: k.muted)),
                            ],
                          ),
                        ),
                        Text('Change',
                            style: KitabuText.ui(13,
                                weight: FontWeight.w600,
                                color: k.accent)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Payment',
                      style: KitabuText.ui(15,
                          weight: FontWeight.w700, color: k.ink)),
                  const SizedBox(height: 12),
                  _PaymentCard(k: k),
                  const SizedBox(height: 100),
                ],
              ),
              bottomNavigationBar: StickyBottom(
                child: Cta(
                  'Place Order · KES ${(subtotal + 200).toStringAsFixed(0)}',
                  full: true,
                  onTap: () =>
                      ctx.pushReplacement('/order/confirmation/ord-new'),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, this.k, {this.bold = false});
  final String label;
  final String value;
  final KitabuColors k;
  final bool bold;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  style: bold
                      ? KitabuText.ui(15,
                          weight: FontWeight.w700, color: k.ink)
                      : KitabuText.ui(14, color: k.muted)),
            ),
            Text(value,
                style: bold
                    ? KitabuText.ui(15,
                        weight: FontWeight.w800, color: k.ink)
                    : KitabuText.ui(14,
                        weight: FontWeight.w600, color: k.ink)),
          ],
        ),
      );
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.k});
  final KitabuColors k;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [k.accentDeep, k.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('VISA',
                  style: KitabuText.ui(16,
                          weight: FontWeight.w900, color: Colors.white)
                      .copyWith(fontStyle: FontStyle.italic)),
              const Spacer(),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text('•••• •••• •••• 4242',
              style: KitabuText.mono(14, color: Colors.white)),
        ],
      ),
    );
  }
}
