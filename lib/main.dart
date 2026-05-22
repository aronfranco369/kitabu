import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/env.dart';
import 'core/theme/kitabu_theme.dart';
import 'core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );
  runApp(const ProviderScope(child: KitabuApp()));
}

class KitabuApp extends StatelessWidget {
  const KitabuApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Kitabu',
        theme: KitabuTheme.normal(),
        routerConfig: appRouter,
      );
}
