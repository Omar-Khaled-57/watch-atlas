import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/isar_service.dart';
import '../services/supabase_service.dart';
import '../services/tmdb_service.dart';
import '../services/anilist_service.dart';
import '../services/auth_service.dart';
import '../services/connectivity_service.dart';
import '../services/notification_service.dart';
import '../services/sync_service.dart';
import '../../models/user_model.dart';

final isarServiceProvider = Provider<IsarService>((ref) => IsarService.instance);
final supabaseServiceProvider = Provider<SupabaseService>((ref) => SupabaseService.instance);
final tmdbServiceProvider = Provider<TmdbService>((ref) => TmdbService.instance);
final anilistServiceProvider = Provider<AnilistService>((ref) => AnilistService.instance);
final authServiceProvider = Provider<AuthService>((ref) => AuthService.instance);
final connectivityServiceProvider = Provider<ConnectivityService>((ref) => ConnectivityService.instance);
final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService.instance);
final syncServiceProvider = Provider<SyncService>((ref) => SyncService.instance);

final isOnlineProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.onConnectivityChanged;
});

final authStateProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(authServiceProvider);
  return service.authStateChanges.map((_) => service.isAuthenticated);
});

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final service = ref.watch(authServiceProvider);
  if (!service.isAuthenticated) return null;
  return service.getProfile();
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final service = ref.watch(authServiceProvider);
  ref.watch(authStateProvider);
  return service.isAuthenticated;
});

final appInitializationProvider = FutureProvider<void>((ref) async {
  const timeout = Duration(seconds: 10);

  try {
    await Future.wait([
      IsarService.instance.init().timeout(timeout).catchError((_) {}),
      NotificationService.instance.init().timeout(timeout).catchError((_) {}),
    ]);
  } catch (_) {}

  try { TmdbService.instance.init(); } catch (_) {}
  try { AnilistService.instance.init(); } catch (_) {}
  try { ConnectivityService.instance.init(); } catch (_) {}
  try { SyncService.instance.init(); } catch (_) {}
});

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _load();
    return ThemeMode.system;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('theme_mode');
    state = switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    final key = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    await prefs.setString('theme_mode', key);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    _load();
    return const Locale('en');
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('locale');
    state = switch (value) {
      'ar' => const Locale('ar'),
      _ => const Locale('en'),
    };
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }
}

class _ShowForYouNotifier extends Notifier<bool> {
  @override
  bool build() => true;
}

final showForYouSectionProvider = NotifierProvider<_ShowForYouNotifier, bool>(_ShowForYouNotifier.new);
