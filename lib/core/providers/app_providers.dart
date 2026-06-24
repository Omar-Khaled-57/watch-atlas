import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  return ref.watch(authServiceProvider).isAuthenticated;
});

final appInitializationProvider = FutureProvider<void>((ref) async {
  await SupabaseService.instance.init();
  TmdbService.instance.init();
  AnilistService.instance.init();
  await IsarService.instance.init();
  ConnectivityService.instance.init();
  SyncService.instance.init();
  try {
    await NotificationService.instance.init();
  } catch (e) {
    debugPrint('Notification init skipped: $e');
  }
});
