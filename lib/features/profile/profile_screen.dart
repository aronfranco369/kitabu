import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/kitabu_colors.dart';
import '../../core/theme/kitabu_text.dart';
import '../../core/icons/kitabu_icons.dart';
import '../../core/widgets/common.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final k = context.kit;

    return Scaffold(
      backgroundColor: k.bg,
      appBar: AppBar(
        backgroundColor: k.bg,
        titleSpacing: kGutter,
        title: Text('Profile',
            style: KitabuText.ui(20,
                weight: FontWeight.w800, color: k.ink)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: kGutter),
            child: CircleButton(
              icon: KSvg(KIcons.settings, size: 18, color: k.ink),
              onTap: () => context.push('/profile/settings'),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Profile header
          Container(
            margin: const EdgeInsets.all(kGutter),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: k.paper,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: k.hairline),
            ),
            child: Row(
              children: [
                InitialsAvatar('Amara Osei', size: 60),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amara Osei',
                          style: KitabuText.ui(18,
                              weight: FontWeight.w800, color: k.ink)),
                      const SizedBox(height: 4),
                      Text('amara@example.com',
                          style: KitabuText.ui(13, color: k.muted)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _StatBadge('18', 'Books', k),
                          const SizedBox(width: 12),
                          _StatBadge('5', 'Requests', k),
                          const SizedBox(width: 12),
                          _StatBadge('4', 'Orders', k),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Reading stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kGutter),
            child: RowHead('Reading Stats'),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kGutter),
            child: Row(
              children: [
                Expanded(
                    child: _StatCard('3', 'Books read\nthis month', k)),
                const SizedBox(width: 12),
                Expanded(
                    child: _StatCard('247', 'Pages\nthis week', k)),
                const SizedBox(width: 12),
                Expanded(
                    child: _StatCard('14', 'Day\nstreak', k)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Menu items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kGutter),
            child: RowHead('Account'),
          ),
          const SizedBox(height: 8),
          _MenuItem(
            icon: KIcons.truck,
            label: 'Order History',
            onTap: () => context.push('/profile/orders'),
            k: k,
          ),
          _MenuItem(
            icon: KIcons.messageSquare,
            label: 'My Requests',
            onTap: () => context.go('/requests'),
            k: k,
          ),
          _MenuItem(
            icon: KIcons.bookmark,
            label: 'My Library',
            onTap: () => context.go('/library'),
            k: k,
          ),
          _MenuItem(
            icon: KIcons.settings,
            label: 'Account Settings',
            onTap: () => context.push('/profile/settings'),
            k: k,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kGutter),
            child: RowHead('Support'),
          ),
          const SizedBox(height: 8),
          _MenuItem(
            icon: KIcons.bookOpen,
            label: 'Help Center',
            onTap: () {},
            k: k,
          ),
          _MenuItem(
            icon: KIcons.share,
            label: 'Share Kitabu',
            onTap: () {},
            k: k,
          ),
          const SizedBox(height: 24),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kGutter),
            child: Cta(
              'Sign Out',
              full: true,
              variant: CtaVariant.ghost,
              onTap: () {},
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge(this.value, this.label, this.k);
  final String value;
  final String label;
  final KitabuColors k;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value,
              style: KitabuText.ui(16,
                  weight: FontWeight.w800, color: k.ink)),
          Text(label,
              style: KitabuText.ui(10, color: k.muted)),
        ],
      );
}

class _StatCard extends StatelessWidget {
  const _StatCard(this.value, this.label, this.k);
  final String value;
  final String label;
  final KitabuColors k;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: k.paper,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: k.hairline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: KitabuText.ui(22,
                    weight: FontWeight.w900, color: k.accent)),
            const SizedBox(height: 4),
            Text(label,
                style: KitabuText.ui(11, color: k.muted, height: 1.4)),
          ],
        ),
      );
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.k,
  });
  final String icon;
  final String label;
  final VoidCallback onTap;
  final KitabuColors k;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.fromLTRB(kGutter, 0, kGutter, 2),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: k.paper,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: k.hairline),
          ),
          child: Row(
            children: [
              KSvg(icon, size: 18, color: k.muted),
              const SizedBox(width: 14),
              Expanded(
                child: Text(label,
                    style: KitabuText.ui(14,
                        weight: FontWeight.w500, color: k.ink)),
              ),
              KSvg(KIcons.chevronRight, size: 16, color: k.muted2),
            ],
          ),
        ),
      );
}
