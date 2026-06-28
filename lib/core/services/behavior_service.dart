import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/recommendation_models.dart';
import 'supabase_service.dart';
import 'auth_service.dart';

/// Records user behaviour events to power the recommendation engine.
///
/// All events are stored in the `user_events` table with device, platform,
/// and session metadata for downstream analysis.
///
/// Use [instance] for quick access; inject a configured instance for tests.
class BehaviorService {
  static final BehaviorService instance = BehaviorService();

  BehaviorService({
    SupabaseService? supabase,
    AuthService? auth,
  })  : _supabase = supabase ?? SupabaseService.instance,
        _auth = auth ?? AuthService.instance;

  final SupabaseService _supabase;
  final AuthService _auth;
  String? _sessionId;

  String get _session => _sessionId ??= _generateSessionId();

  String _generateSessionId() =>
      DateTime.now().microsecondsSinceEpoch.toString();

  /// Generic event tracker — prefer the typed convenience methods below.
  Future<void> trackEvent({
    required EventType eventType,
    int? mediaId,
    Map<String, dynamic> metadata = const {},
  }) async {
    final uid = _auth.userId;
    if (uid.isEmpty) return;

    final event = BehaviorEvent(
      userId: uid,
      eventType: eventType,
      mediaId: mediaId,
      metadata: metadata,
      device: _detectDevice(),
      platform: _detectPlatform(),
      sessionId: _session,
    );

    try {
      await _supabase.userEvents.insert(event.toJson());
    } catch (e) {
      debugPrint('BehaviorService: failed to track $eventType: $e');
    }
  }

  // ---------------------------------------------------------------
  // Convenience trackers
  // ---------------------------------------------------------------

  Future<void> trackMediaView(int mediaId, {Map<String, dynamic>? extra}) =>
      trackEvent(
          eventType: EventType.mediaView,
          mediaId: mediaId,
          metadata: extra ?? {});

  Future<void> trackMediaViewDuration(int mediaId, int seconds) =>
      trackEvent(
          eventType: EventType.mediaViewDuration,
          mediaId: mediaId,
          metadata: {'duration_seconds': seconds});

  Future<void> trackMediaSave(int mediaId) =>
      trackEvent(eventType: EventType.mediaSave, mediaId: mediaId);

  Future<void> trackMediaUnsave(int mediaId) =>
      trackEvent(eventType: EventType.mediaUnsave, mediaId: mediaId);

  Future<void> trackMediaFavorite(int mediaId) =>
      trackEvent(eventType: EventType.mediaFavorite, mediaId: mediaId);

  Future<void> trackMediaUnfavorite(int mediaId) =>
      trackEvent(eventType: EventType.mediaUnfavorite, mediaId: mediaId);

  Future<void> trackMediaComplete(int mediaId) =>
      trackEvent(eventType: EventType.mediaComplete, mediaId: mediaId);

  Future<void> trackSearch(String query, {Map<String, dynamic>? filters}) =>
      trackEvent(
          eventType: EventType.search,
          metadata: {'query': query, 'filters': filters ?? {}});

  Future<void> trackGenreBrowse(String genre) =>
      trackEvent(
          eventType: EventType.genreBrowse, metadata: {'genre': genre});

  Future<void> trackRecommendationClick(int mediaId, String category) =>
      trackEvent(
          eventType: EventType.recommendationClick,
          mediaId: mediaId,
          metadata: {'category': category});

  Future<void> trackRecommendationDismiss(int mediaId, String category) =>
      trackEvent(
          eventType: EventType.recommendationDismiss,
          mediaId: mediaId,
          metadata: {'category': category});

  Future<void> trackRating(int mediaId, double rating) =>
      trackEvent(
          eventType: EventType.rating,
          mediaId: mediaId,
          metadata: {'rating': rating});

  // ---------------------------------------------------------------
  // Privacy controls
  // ---------------------------------------------------------------

  /// Deletes all behaviour events AND cached recommendations for the current user.
  Future<void> clearAllEvents() async {
    final uid = _auth.userId;
    if (uid.isEmpty) return;
    try {
      await _supabase.userEvents.delete().eq('user_id', uid);
    } catch (e) {
      debugPrint('BehaviorService: clearAllEvents failed: $e');
    }
    try {
      await _supabase.recommendationsCache.delete().eq('user_id', uid);
    } catch (e) {
      debugPrint('BehaviorService: clearRecommendationsCache failed: $e');
    }
  }

  Future<void> enableRecommendations() async =>
      _setRecsEnabled(true);

  Future<void> disableRecommendations() async =>
      _setRecsEnabled(false);

  Future<void> _setRecsEnabled(bool enabled) async {
    final uid = _auth.userId;
    if (uid.isEmpty) return;
    try {
      await _supabase.profiles
          .update({'recs_enabled': enabled})
          .eq('id', uid);
    } catch (e) {
      debugPrint('BehaviorService: setRecsEnabled($enabled) failed: $e');
    }
  }

  /// Returns whether personalised recommendations are enabled.
  Future<bool> isRecsEnabled() async {
    final uid = _auth.userId;
    if (uid.isEmpty) return true;
    try {
      final result =
          await _supabase.profiles.select('recs_enabled').eq('id', uid).single();
      return result['recs_enabled'] as bool? ?? true;
    } catch (_) {
      return true;
    }
  }

  // ---------------------------------------------------------------
  // Environment detection
  // ---------------------------------------------------------------

  String _detectDevice() {
    try {
      if (Platform.isAndroid) return 'android';
      if (Platform.isIOS) return 'ios';
      if (Platform.isMacOS) return 'macos';
      if (Platform.isWindows) return 'windows';
      if (Platform.isLinux) return 'linux';
    } catch (_) {}
    return 'unknown';
  }

  String _detectPlatform() {
    try {
      if (Platform.isAndroid || Platform.isIOS) return 'mobile';
      if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        return 'desktop';
      }
    } catch (_) {}
    return 'unknown';
  }
}
