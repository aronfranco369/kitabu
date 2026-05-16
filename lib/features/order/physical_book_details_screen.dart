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

class PhysicalBookDetailsScreen extends ConsumerWidget {
  const PhysicalBookDetailsScreen({super.key, required this.slug});
  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: KitabuTheme.clay(),
      child: Builder(builder: (ctx) {
        final k = ctx.kit;
        final bookAsync = ref.watch(bookBySlugProvider(slug));

        return bookAsync.when(
          loading: () => Scaffold(
            backgroundColor: k.bg,
            appBar: BackTopBar(onBack: () => ctx.pop()),
            body: const Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Scaffold(
            backgroundColor: k.bg,
            appBar: BackTopBar(onBack: () => ctx.pop()),
            body: Center(child: Text('Error: $e')),
          ),
          data: (book) {
            if (book == null) {
              return Scaffold(
                backgroundColor: k.bg,
                appBar: BackTopBar(onBack: () => ctx.pop()),
                body: const Center(child: Text('Book not found')),
              );
            }
            return Scaffold(
              backgroundColor: k.bg,
              appBar: BackTopBar(
                title: 'Physical Copy',
                onBack: () => ctx.pop(),
              ),
              body: ListView(
                padding: const EdgeInsets.all(kGutter),
                children: [
                  KCard(
                    child: Row(
                      children: [
                        BookCover(book,
                            width: 100, height: 144, badge: false),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(book.title,
                                  style: KitabuText.ui(16,
                                      weight: FontWeight.w800,
                                      color: k.ink),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 6),
                              Text(book.author,
                                  style: KitabuText.ui(13,
                                      color: k.muted)),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  KSvg(KIcons.starFilled,
                                      size: 13, color: k.gold),
                                  const SizedBox(width: 4),
                                  Text(
                                      book.rating.toStringAsFixed(1),
                                      style: KitabuText.ui(13,
                                          weight: FontWeight.w600,
                                          color: k.ink)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'KES ${book.physicalPrice!.toStringAsFixed(0)}',
                                style: KitabuText.ui(20,
                                    weight: FontWeight.w900,
                                    color: k.accent),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Quantity',
                      style: KitabuText.ui(15,
                          weight: FontWeight.w700, color: k.ink)),
                  const SizedBox(height: 12),
                  _QuantityPicker(price: book.physicalPrice!),
                  const SizedBox(height: 20),
                  Divider(color: k.hairline),
                  const SizedBox(height: 16),
                  Text('About this edition',
                      style: KitabuText.ui(15,
                          weight: FontWeight.w700, color: k.ink)),
                  const SizedBox(height: 10),
                  Text(book.description,
                      style: KitabuText.serif(14,
                          color: k.ink2, height: 1.65)),
                  const SizedBox(height: 20),
                  _ShippingInfo(k: k),
                  const SizedBox(height: 100),
                ],
              ),
              bottomNavigationBar: StickyBottom(
                child: Cta(
                  'Add to Cart',
                  full: true,
                  icon: KSvg(KIcons.cart, size: 18,
                      color: Colors.white),
                  onTap: () => ctx.push('/order/cart'),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class _QuantityPicker extends StatefulWidget {
  const _QuantityPicker({required this.price});
  final double price;

  @override
  State<_QuantityPicker> createState() => _QuantityPickerState();
}

class _QuantityPickerState extends State<_QuantityPicker> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    return Row(
      children: [
        CircleButton(
          icon: KSvg(KIcons.minus, size: 16, color: k.ink),
          onTap: qty > 1 ? () => setState(() => qty--) : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('$qty',
              style: KitabuText.ui(18,
                  weight: FontWeight.w700, color: k.ink)),
        ),
        CircleButton(
          icon: KSvg(KIcons.plus, size: 16, color: k.ink),
          onTap: () => setState(() => qty++),
        ),
        const Spacer(),
        Text(
          'KES ${(widget.price * qty).toStringAsFixed(0)}',
          style: KitabuText.ui(18,
              weight: FontWeight.w800, color: k.accent),
        ),
      ],
    );
  }
}

class _ShippingInfo extends StatelessWidget {
  const _ShippingInfo({required this.k});
  final KitabuColors k;

  @override
  Widget build(BuildContext context) {
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              KSvg(KIcons.truck, size: 18, color: k.accent),
              const SizedBox(width: 10),
              Text('Shipping Info',
                  style: KitabuText.ui(14,
                      weight: FontWeight.w700, color: k.ink)),
            ],
          ),
          const SizedBox(height: 12),
          _ShipRow('Nairobi CBD', '1-2 business days', k),
          _ShipRow('Nairobi suburbs', '2-3 business days', k),
          _ShipRow('Major towns', '3-5 business days', k),
          const SizedBox(height: 4),
          Text('Free delivery on orders over KES 3,000',
              style: KitabuText.ui(12, color: k.free)),
        ],
      ),
    );
  }
}

class _ShipRow extends StatelessWidget {
  const _ShipRow(this.area, this.duration, this.k);
  final String area;
  final String duration;
  final KitabuColors k;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(child: Text(area, style: KitabuText.ui(13, color: k.muted))),
            Text(duration,
                style: KitabuText.ui(13,
                    weight: FontWeight.w600, color: k.ink)),
          ],
        ),
      );
}
