import 'package:flutter/material.dart';

class KitabuColors extends ThemeExtension<KitabuColors> {
  const KitabuColors({
    required this.bg,
    required this.paper,
    required this.surface,
    required this.ink,
    required this.ink2,
    required this.muted,
    required this.muted2,
    required this.hairline,
    required this.hairline2,
    required this.accent,
    required this.accentDeep,
    required this.accentSoft,
    required this.accentTint,
    required this.clay,
    required this.claySoft,
    required this.clayPaper,
    required this.clayCard,
    required this.free,
    required this.freeSoft,
    required this.gold,
    required this.inkBlue,
  });

  final Color bg;
  final Color paper;
  final Color surface;
  final Color ink;
  final Color ink2;
  final Color muted;
  final Color muted2;
  final Color hairline;
  final Color hairline2;
  final Color accent;
  final Color accentDeep;
  final Color accentSoft;
  final Color accentTint;
  final Color clay;
  final Color claySoft;
  final Color clayPaper;
  final Color clayCard;
  final Color free;
  final Color freeSoft;
  final Color gold;
  final Color inkBlue;

  factory KitabuColors.normal() => KitabuColors(
        bg: const Color(0xFFFAF7F2),
        paper: const Color(0xFFFFFFFF),
        surface: const Color(0xFFF4EFE8),
        ink: const Color(0xFF1A1611),
        ink2: const Color(0xFF3D3228),
        muted: const Color(0xFF7A6E63),
        muted2: const Color(0xFFB0A89E),
        hairline: const Color(0xFFE8E0D5),
        hairline2: const Color(0xFFF0EBE3),
        accent: const Color(0xFFC0532B),
        accentDeep: const Color(0xFF8B3318),
        accentSoft: const Color(0xFFE8876A),
        accentTint: const Color(0xFFFAEDE7),
        clay: const Color(0xFFB8723A),
        claySoft: const Color(0xFFD4956A),
        clayPaper: const Color(0xFFFFF8F0),
        clayCard: const Color(0xFFFFF0E0),
        free: const Color(0xFF2E7D4E),
        freeSoft: const Color(0xFFE8F5ED),
        gold: const Color(0xFFD4A017),
        inkBlue: const Color(0xFF1A3A5C),
      );

  factory KitabuColors.clay() {
    final n = KitabuColors.normal();
    return KitabuColors(
      bg: n.clayPaper,
      paper: n.clayCard,
      surface: const Color(0xFFFFE8CC),
      ink: n.ink,
      ink2: n.ink2,
      muted: n.muted,
      muted2: n.muted2,
      hairline: const Color(0xFFDDC4A0),
      hairline2: const Color(0xFFEDD8B8),
      accent: n.clay,
      accentDeep: const Color(0xFF8B5020),
      accentSoft: n.claySoft,
      accentTint: const Color(0xFFFFF4E8),
      clay: n.clay,
      claySoft: n.claySoft,
      clayPaper: n.clayPaper,
      clayCard: n.clayCard,
      free: n.free,
      freeSoft: n.freeSoft,
      gold: n.gold,
      inkBlue: n.inkBlue,
    );
  }

  factory KitabuColors.dark() {
    final n = KitabuColors.normal();
    return KitabuColors(
      bg: const Color(0xFF1A1611),
      paper: const Color(0xFF252018),
      surface: const Color(0xFF302820),
      ink: const Color(0xFFE8DFCE),
      ink2: const Color(0xFFCEC3AD),
      muted: const Color(0xFF9A9080),
      muted2: const Color(0xFF6A6055),
      hairline: const Color(0xFF3A3028),
      hairline2: const Color(0xFF2A2218),
      accent: n.accent,
      accentDeep: n.accentDeep,
      accentSoft: n.accentSoft,
      accentTint: const Color(0xFF3A1A10),
      clay: n.clay,
      claySoft: n.claySoft,
      clayPaper: n.clayPaper,
      clayCard: n.clayCard,
      free: n.free,
      freeSoft: const Color(0xFF0A2A18),
      gold: n.gold,
      inkBlue: const Color(0xFF4A7AAC),
    );
  }

  @override
  KitabuColors copyWith({
    Color? bg,
    Color? paper,
    Color? surface,
    Color? ink,
    Color? ink2,
    Color? muted,
    Color? muted2,
    Color? hairline,
    Color? hairline2,
    Color? accent,
    Color? accentDeep,
    Color? accentSoft,
    Color? accentTint,
    Color? clay,
    Color? claySoft,
    Color? clayPaper,
    Color? clayCard,
    Color? free,
    Color? freeSoft,
    Color? gold,
    Color? inkBlue,
  }) =>
      KitabuColors(
        bg: bg ?? this.bg,
        paper: paper ?? this.paper,
        surface: surface ?? this.surface,
        ink: ink ?? this.ink,
        ink2: ink2 ?? this.ink2,
        muted: muted ?? this.muted,
        muted2: muted2 ?? this.muted2,
        hairline: hairline ?? this.hairline,
        hairline2: hairline2 ?? this.hairline2,
        accent: accent ?? this.accent,
        accentDeep: accentDeep ?? this.accentDeep,
        accentSoft: accentSoft ?? this.accentSoft,
        accentTint: accentTint ?? this.accentTint,
        clay: clay ?? this.clay,
        claySoft: claySoft ?? this.claySoft,
        clayPaper: clayPaper ?? this.clayPaper,
        clayCard: clayCard ?? this.clayCard,
        free: free ?? this.free,
        freeSoft: freeSoft ?? this.freeSoft,
        gold: gold ?? this.gold,
        inkBlue: inkBlue ?? this.inkBlue,
      );

  @override
  KitabuColors lerp(KitabuColors? other, double t) {
    if (other == null) return this;
    return KitabuColors(
      bg: Color.lerp(bg, other.bg, t)!,
      paper: Color.lerp(paper, other.paper, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      ink2: Color.lerp(ink2, other.ink2, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      muted2: Color.lerp(muted2, other.muted2, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      hairline2: Color.lerp(hairline2, other.hairline2, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentDeep: Color.lerp(accentDeep, other.accentDeep, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      accentTint: Color.lerp(accentTint, other.accentTint, t)!,
      clay: Color.lerp(clay, other.clay, t)!,
      claySoft: Color.lerp(claySoft, other.claySoft, t)!,
      clayPaper: Color.lerp(clayPaper, other.clayPaper, t)!,
      clayCard: Color.lerp(clayCard, other.clayCard, t)!,
      free: Color.lerp(free, other.free, t)!,
      freeSoft: Color.lerp(freeSoft, other.freeSoft, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      inkBlue: Color.lerp(inkBlue, other.inkBlue, t)!,
    );
  }
}

extension KitabuColorsX on BuildContext {
  KitabuColors get kit => Theme.of(this).extension<KitabuColors>()!;
}
