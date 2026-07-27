import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';
import '../services/connectivity_service.dart';
import '../services/sync_service.dart';
import 'service_providers.dart';

final appInitializationProvider = FutureProvider<void>((ref) async {
  const timeout = Duration(seconds: 10);

  try {
    await Future.wait([
      NotificationService.instance.init().timeout(timeout).catchError((e) {
        debugPrint('[Init] NotificationService init failed: $e');
      }),
    ]);
  } catch (e) {
    debugPrint('[Init] Parallel service init failed: $e');
  }

  try {
    ref.read(tmdbServiceProvider).init();
  } catch (e) {
    debugPrint('[Init] TmdbService init failed: $e');
  }
  try {
    ref.read(anilistServiceProvider).init();
  } catch (e) {
    debugPrint('[Init] AnilistService init failed: $e');
  }
  try {
    ConnectivityService.instance.init();
  } catch (e) {
    debugPrint('[Init] ConnectivityService init failed: $e');
  }
  try {
    SyncService.instance.init();
  } catch (e) {
    debugPrint('[Init] SyncService init failed: $e');
  }
});
