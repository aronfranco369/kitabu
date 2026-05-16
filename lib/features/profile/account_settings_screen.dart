import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/kitabu_colors.dart';
import '../../core/theme/kitabu_text.dart';
import '../../core/icons/kitabu_icons.dart';
import '../../core/widgets/common.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() =>
      _AccountSettingsScreenState();
}

class _AccountSettingsScreenState
    extends State<AccountSettingsScreen> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _orderUpdates = true;
  bool _newArrivals = false;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;

    return Scaffold(
      backgroundColor: k.bg,
      appBar: BackTopBar(
        title: 'Account Settings',
        onBack: () => context.pop(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(kGutter),
        children: [
          // Profile section
          _SectionLabel('Profile', k),
          KCard(
            child: Column(
              children: [
                _SettingRow(
                  label: 'Full Name',
                  value: 'Amara Osei',
                  onTap: () {},
                  k: k,
                ),
                Divider(color: k.hairline, height: 1),
                _SettingRow(
                  label: 'Email',
                  value: 'amara@example.com',
                  onTap: () {},
                  k: k,
                ),
                Divider(color: k.hairline, height: 1),
                _SettingRow(
                  label: 'Phone',
                  value: '+254 7XX XXX XXX',
                  onTap: () {},
                  k: k,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Shipping
          _SectionLabel('Shipping Address', k),
          KCard(
            child: Column(
              children: [
                _SettingRow(
                  label: 'Default Address',
                  value: '14 Kimathi St, Nairobi',
                  onTap: () {},
                  k: k,
                ),
                Divider(color: k.hairline, height: 1),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    child: Row(
                      children: [
                        KSvg(KIcons.plus, size: 16, color: k.accent),
                        const SizedBox(width: 10),
                        Text('Add new address',
                            style: KitabuText.ui(14,
                                weight: FontWeight.w600, color: k.accent)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Notifications
          _SectionLabel('Notifications', k),
          KCard(
            child: Column(
              children: [
                _ToggleRow(
                  label: 'Email Notifications',
                  sub: 'Order updates & receipts',
                  value: _emailNotifications,
                  onChanged: (v) =>
                      setState(() => _emailNotifications = v),
                  k: k,
                ),
                Divider(color: k.hairline, height: 1),
                _ToggleRow(
                  label: 'Push Notifications',
                  sub: 'In-app alerts',
                  value: _pushNotifications,
                  onChanged: (v) =>
                      setState(() => _pushNotifications = v),
                  k: k,
                ),
                Divider(color: k.hairline, height: 1),
                _ToggleRow(
                  label: 'Order Updates',
                  sub: 'Shipping & delivery',
                  value: _orderUpdates,
                  onChanged: (v) =>
                      setState(() => _orderUpdates = v),
                  k: k,
                ),
                Divider(color: k.hairline, height: 1),
                _ToggleRow(
                  label: 'New Arrivals',
                  sub: 'Books we think you\'ll love',
                  value: _newArrivals,
                  onChanged: (v) =>
                      setState(() => _newArrivals = v),
                  k: k,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Danger zone
          _SectionLabel('Account', k),
          KCard(
            child: Column(
              children: [
                _SettingRow(
                  label: 'Change Password',
                  onTap: () {},
                  k: k,
                ),
                Divider(color: k.hairline, height: 1),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Delete Account',
                              style: KitabuText.ui(14,
                                  color: Colors.red.shade600)),
                        ),
                        KSvg(KIcons.chevronRight,
                            size: 16, color: k.muted2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label, this.k);
  final String label;
  final KitabuColors k;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Eyebrow(label),
      );
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    this.value,
    required this.onTap,
    required this.k,
  });
  final String label;
  final String? value;
  final VoidCallback onTap;
  final KitabuColors k;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(label,
                    style:
                        KitabuText.ui(14, color: k.ink)),
              ),
              if (value != null)
                Text(value!,
                    style: KitabuText.ui(13, color: k.muted)),
              const SizedBox(width: 6),
              KSvg(KIcons.chevronRight, size: 16, color: k.muted2),
            ],
          ),
        ),
      );
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.sub,
    required this.value,
    required this.onChanged,
    required this.k,
  });
  final String label;
  final String sub;
  final bool value;
  final ValueChanged<bool> onChanged;
  final KitabuColors k;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: KitabuText.ui(14, color: k.ink)),
                  Text(sub,
                      style: KitabuText.ui(11, color: k.muted)),
                ],
              ),
            ),
            KToggle(value: value, onChanged: onChanged),
          ],
        ),
      );
}
