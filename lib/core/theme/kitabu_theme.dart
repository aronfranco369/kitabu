import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'kitabu_colors.dart';
import 'kitabu_text.dart';

class KitabuTheme {
  KitabuTheme._();

  static ThemeData normal() => _build(KitabuColors.normal(), Brightness.light);
  static ThemeData clay() => _build(KitabuColors.clay(), Brightness.light);
  static ThemeData dark() => _build(KitabuColors.dark(), Brightness.dark);

  static ThemeData _build(KitabuColors k, Brightness brightness) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: k.bg,
      extensions: [k],
      colorScheme: base.colorScheme.copyWith(
        primary: k.accent,
        onPrimary: Colors.white,
        surface: k.paper,
        onSurface: k.ink,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: k.bg,
        foregroundColor: k.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: KitabuText.ui(17, weight: FontWeight.w600, color: k.ink),
      ),
      textTheme: base.textTheme.copyWith(
        bodyLarge: KitabuText.ui(16, color: k.ink),
        bodyMedium: KitabuText.ui(14, color: k.ink),
        bodySmall: KitabuText.ui(12, color: k.muted),
        labelLarge: KitabuText.ui(14, weight: FontWeight.w600, color: k.ink),
        titleMedium: KitabuText.ui(16, weight: FontWeight.w600, color: k.ink),
        titleLarge: KitabuText.ui(20, weight: FontWeight.w700, color: k.ink),
        headlineSmall: KitabuText.ui(24, weight: FontWeight.w700, color: k.ink),
      ),
      dividerTheme: DividerThemeData(color: k.hairline, space: 1, thickness: 1),
      cardTheme: CardThemeData(
        color: k.paper,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: k.hairline),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: k.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: k.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: k.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: k.accent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: k.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: KitabuText.ui(15, weight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }
}
