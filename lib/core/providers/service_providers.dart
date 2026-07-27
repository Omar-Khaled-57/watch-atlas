import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/behavior_service.dart';
import '../services/cache_service.dart';
import '../services/supabase_service.dart';
import '../services/tmdb_service.dart';
import '../services/anilist_service.dart';
import '../services/auth_service.dart';
import '../services/connectivity_service.dart';
import '../services/notification_service.dart';
import '../services/sync_service.dart';

final cacheServiceProvider = Provider<CacheService>((ref) => CacheService());

final supabaseServiceProvider = Provider<SupabaseService>(
  (ref) => SupabaseService.instance,
);

final tmdbServiceProvider = Provider<TmdbService>((ref) => TmdbService.instance);

final anilistServiceProvider = Provider<AnilistService>(
  (ref) => AnilistService.instance,
);

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService.instance,
);

final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => ConnectivityService.instance,
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService.instance,
);

final behaviorServiceProvider = Provider<BehaviorService>(
  (ref) => BehaviorService(
    supabase: ref.read(supabaseServiceProvider),
    auth: ref.read(authServiceProvider),
  ),
);

final syncServiceProvider = Provider<SyncService>(
  (ref) => SyncService.instance,
);
