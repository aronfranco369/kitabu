import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/kitabu_colors.dart';
import '../theme/kitabu_text.dart';
import '../icons/kitabu_icons.dart';

const kGutter = 20.0;
const kHalfGutter = 10.0;

// ── Eyebrow ──────────────────────────────────────────────────────────────────

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.kit.muted;
    return Text(
      text.toUpperCase(),
      style: KitabuText.ui(10, weight: FontWeight.w700,
          color: c, letterSpacing: 1.2),
    );
  }
}

// ── RowHead ───────────────────────────────────────────────────────────────────

class RowHead extends StatelessWidget {
  const RowHead(
    this.title, {
    super.key,
    this.action,
    this.onAction,
  });
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    return Row(
      children: [
        Expanded(
          child: Text(title,
              style:
                  KitabuText.ui(17, weight: FontWeight.w700, color: k.ink)),
        ),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(action!,
                style: KitabuText.ui(13,
                    weight: FontWeight.w600, color: k.accent)),
          ),
      ],
    );
  }
}

// ── KCard ─────────────────────────────────────────────────────────────────────

class KCard extends StatelessWidget {
  const KCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color ?? k.paper,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: k.hairline),
        ),
        child: child,
      ),
    );
  }
}

// ── KChip ─────────────────────────────────────────────────────────────────────

class KChip extends StatelessWidget {
  const KChip(
    this.label, {
    super.key,
    this.selected = false,
    this.onTap,
    this.icon,
  });
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? k.accentTint : k.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? k.accent : k.hairline,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 6)],
            Text(
              label,
              style: KitabuText.ui(13,
                  weight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? k.accent : k.muted),
            ),
          ],
        ),
      ),
    );
  }
}

// ── HRow ──────────────────────────────────────────────────────────────────────

class HRow extends StatelessWidget {
  const HRow({super.key, required this.children, this.spacing = 10});
  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: kGutter),
        child: Row(
          children: children
              .expand((w) => [w, SizedBox(width: spacing)])
              .toList()
            ..removeLast(),
        ),
      );
}

// ── ProgressBar ───────────────────────────────────────────────────────────────

class ProgressBar extends StatelessWidget {
  const ProgressBar(this.value, {super.key, this.height = 4, this.color});
  final double value;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: k.hairline,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? k.accent),
      ),
    );
  }
}

// ── Cta ───────────────────────────────────────────────────────────────────────

enum CtaVariant { primary, secondary, ghost, danger }

class Cta extends StatelessWidget {
  const Cta(
    this.label, {
    super.key,
    this.onTap,
    this.variant = CtaVariant.primary,
    this.full = false,
    this.icon,
    this.loading = false,
  });
  final String label;
  final VoidCallback? onTap;
  final CtaVariant variant;
  final bool full;
  final Widget? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;

    Color bg;
    Color fg;
    Color border;

    switch (variant) {
      case CtaVariant.primary:
        bg = k.accent;
        fg = Colors.white;
        border = k.accent;
      case CtaVariant.secondary:
        bg = k.accentTint;
        fg = k.accent;
        border = k.accentSoft.withValues(alpha: 0.4);
      case CtaVariant.ghost:
        bg = Colors.transparent;
        fg = k.muted;
        border = k.hairline;
      case CtaVariant.danger:
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFDC2626);
        border = const Color(0xFFFCA5A5);
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: full ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
        ),
        child: loading
            ? SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(fg),
                ),
              )
            : Row(
                mainAxisSize: full ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 8)],
                  Text(
                    label,
                    style: KitabuText.ui(15, weight: FontWeight.w600, color: fg),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── PressableScale ────────────────────────────────────────────────────────────

class PressableScale extends StatefulWidget {
  const PressableScale({super.key, required this.child, this.onTap});
  final Widget child;
  final VoidCallback? onTap;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1, end: 0.95).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          widget.onTap?.call();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: ScaleTransition(scale: _scale, child: widget.child),
      );
}

// ── CircleButton ──────────────────────────────────────────────────────────────

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 40,
    this.color,
    this.iconColor,
  });
  final Widget icon;
  final VoidCallback? onTap;
  final double size;
  final Color? color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color ?? k.surface,
          shape: BoxShape.circle,
          border: Border.all(color: k.hairline),
        ),
        child: Center(child: icon),
      ),
    );
  }
}

// ── BackTopBar ────────────────────────────────────────────────────────────────

class BackTopBar extends StatelessWidget implements PreferredSizeWidget {
  const BackTopBar({
    super.key,
    this.title,
    this.actions,
    this.onBack,
    this.transparent = false,
  });
  final String? title;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final bool transparent;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    return AppBar(
      backgroundColor: transparent ? Colors.transparent : k.bg,
      leading: CircleButton(
        icon: KSvg(KIcons.arrowLeft, size: 18, color: k.ink),
        onTap: onBack ?? () => Navigator.of(context).maybePop(),
        color: k.paper,
      ),
      leadingWidth: 56,
      title: title != null
          ? Text(title!,
              style: KitabuText.ui(17, weight: FontWeight.w700, color: k.ink))
          : null,
      actions: actions,
    );
  }
}

// ── SearchField ───────────────────────────────────────────────────────────────

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.controller,
    this.hint = 'Search…',
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.readOnly = false,
    this.onTap,
  });
  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    return TextField(
      controller: controller,
      autofocus: autofocus,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: KitabuText.ui(15, color: k.ink),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: KitabuText.ui(15, color: k.muted),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: KSvg(KIcons.search, size: 18, color: k.muted),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }
}

// ── Dot ───────────────────────────────────────────────────────────────────────

class Dot extends StatelessWidget {
  const Dot({super.key, this.color, this.size = 4});
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color ?? context.kit.muted2,
          shape: BoxShape.circle,
        ),
      );
}

// ── KToggle ───────────────────────────────────────────────────────────────────

class KToggle extends StatelessWidget {
  const KToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 26,
        decoration: BoxDecoration(
          color: value ? k.accent : k.hairline,
          borderRadius: BorderRadius.circular(13),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

// ── StickyBottom ──────────────────────────────────────────────────────────────

class StickyBottom extends StatelessWidget {
  const StickyBottom({super.key, required this.child, this.color});
  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    return Container(
      padding: EdgeInsets.fromLTRB(
          kGutter, 14, kGutter, 14 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: color ?? k.paper,
        border: Border(top: BorderSide(color: k.hairline)),
      ),
      child: child,
    );
  }
}

// ── StatusPill ────────────────────────────────────────────────────────────────

class StatusPill extends StatelessWidget {
  const StatusPill(this.label, {super.key, this.color, this.bgColor});
  final String label;
  final Color? color;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    final c = color ?? k.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor ?? c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style:
              KitabuText.ui(11, weight: FontWeight.w600, color: c)),
    );
  }
}

// ── KitabuBottomNav ──────────────────────────────────────────────────────────

class KitabuBottomNav extends StatelessWidget {
  const KitabuBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem('Home', KIcons.home, KIcons.homeFilled),
    _NavItem('Order', KIcons.box, KIcons.boxFilled),
    _NavItem('Requests', KIcons.messageSquare, KIcons.messageSquareFilled),
    _NavItem('Library', KIcons.bookmark, KIcons.bookmarkFilled),
    _NavItem('Profile', KIcons.user, KIcons.userFilled),
  ];

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    final bottom = MediaQuery.of(context).padding.bottom;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: k.paper.withValues(alpha: 0.88),
            border: Border(top: BorderSide(color: k.hairline)),
          ),
          padding: EdgeInsets.only(bottom: bottom),
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final selected = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onTap(i);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        KSvg(
                          selected ? item.filledSvg : item.svg,
                          size: 22,
                          color: selected ? k.accent : k.muted,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: KitabuText.ui(
                            10,
                            weight: selected
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: selected ? k.accent : k.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.svg, this.filledSvg);
  final String label;
  final String svg;
  final String filledSvg;
}

// ── InitialsAvatar ────────────────────────────────────────────────────────────

class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar(this.name, {super.key, this.size = 44});
  final String name;
  final double size;

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isEmpty ? '?' : name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final k = context.kit;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: k.accentTint,
        shape: BoxShape.circle,
        border: Border.all(color: k.accentSoft.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Text(
          _initials,
          style: KitabuText.ui(size * 0.35,
              weight: FontWeight.w700, color: k.accent),
        ),
      ),
    );
  }
}

// ── Pad ───────────────────────────────────────────────────────────────────────

class Pad extends StatelessWidget {
  const Pad({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: kGutter), child: child);
}
