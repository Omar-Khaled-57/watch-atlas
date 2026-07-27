import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'core/config/secrets.dart';
import 'core/theme/app_theme.dart';
import 'core/services/supabase_service.dart';
import 'core/providers/app_providers.dart';
import 'router/app_router.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  if (!Secrets.isConfigured) {
    debugPrint(
      '[WatchAtlas] WARNING: Secrets not configured. '
      'Run with --dart-define=SUPABASE_URL=... or '
      '--dart-define-from-file=secrets.json',
    );
  }
  String? initError;
  try {
    await SupabaseService.instance.init();
  } catch (e) {
    debugPrint('Supabase init error: $e');
    initError = e.toString();
  }
  runApp(ProviderScope(child: WatchAtlasApp(initError: initError)));
}

class WatchAtlasApp extends ConsumerWidget {
  const WatchAtlasApp({super.key, this.initError});

  final String? initError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    if (initError != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_off_rounded,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unable to Connect',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'WatchAtlas could not connect to its backend service. '
                    'Please check your internet connection and try again.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Close & Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

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
