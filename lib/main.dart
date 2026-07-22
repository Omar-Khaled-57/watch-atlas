import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/secrets.dart';
import 'core/theme/app_theme.dart';
import 'core/services/supabase_service.dart';
import 'core/providers/app_providers.dart';
import 'router/app_router.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Secrets.isConfigured) {
    debugPrint(
      '[WatchAtlas] WARNING: Secrets not configured. '
      'Run with --dart-define=SUPABASE_URL=... or '
      '--dart-define-from-file=secrets.json',
    );
  }
  try {
    await SupabaseService.instance.init();
  } catch (e) {
    debugPrint('Supabase init error: $e');
  }
  runApp(const ProviderScope(child: WatchAtlasApp()));
}

class WatchAtlasApp extends ConsumerWidget {
  const WatchAtlasApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
