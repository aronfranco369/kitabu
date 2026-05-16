import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitabu/core/theme/kitabu_theme.dart';
import 'package:kitabu/core/router/app_router.dart';

void main() {
  testWidgets('App boots without Supabase', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: KitabuTheme.normal(),
          routerConfig: appRouter,
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
