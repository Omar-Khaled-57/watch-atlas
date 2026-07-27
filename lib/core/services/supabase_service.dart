import 'dart:io';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/secrets.dart';

/// Singleton wrapper around the Supabase client.
///
/// Provides typed accessors for all Supabase tables ([profiles], [media],
/// [userMedia], [userLists], etc.) and storage buckets ([avatarsBucket],
/// [bannersBucket]). Initialize via [init] before first use.
///
/// Uses the singleton [instance] for app-wide access.
class SupabaseService {
  SupabaseService();

  static final SupabaseService instance = SupabaseService();
  SupabaseClient? _client;

  SupabaseClient get client {
    if (_client == null) {
      throw StateError('Supabase not initialized');
    }
    return _client!;
  }

  GoTrueClient get auth => client.auth;
  SupabaseQueryBuilder get profiles => client.from('profiles');
  SupabaseQueryBuilder get media => client.from('media');
  SupabaseQueryBuilder get userMedia => client.from('user_media');
  SupabaseQueryBuilder get userLists => client.from('user_lists');
  SupabaseQueryBuilder get listItems => client.from('list_items');
  SupabaseQueryBuilder get followers => client.from('followers');
  SupabaseQueryBuilder get notifications => client.from('notifications');
  SupabaseQueryBuilder get activityLogs => client.from('activity_logs');
  SupabaseQueryBuilder get userEvents => client.from('user_events');
  SupabaseQueryBuilder get userRecProfiles => client.from('user_rec_profiles');
  SupabaseQueryBuilder get mediaSimilarity => client.from('media_similarity');
  SupabaseQueryBuilder get recommendationsCache =>
      client.from('recommendations_cache');

  Future<void> init() async {
    final supabaseUrl = Secrets.supabaseUrl;
    final supabasePublishableKey = Secrets.supabaseAnonKey;
    if (supabaseUrl.isEmpty || supabasePublishableKey.isEmpty) {
      throw StateError(
        'Supabase credentials not configured. '
        'Run with --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...',
      );
    }
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabasePublishableKey,
    );
    _client = Supabase.instance.client;
  }

  StorageFileApi? _avatarsBucket;
  StorageFileApi? _bannersBucket;

  StorageFileApi get avatarsBucket =>
      _avatarsBucket ??= client.storage.from('avatars');
  StorageFileApi get bannersBucket =>
      _bannersBucket ??= client.storage.from('banners');

  Future<String> uploadAvatar(String userId, String filePath) async {
    final ext = filePath.split('.').last;
    final path = '$userId/avatar.$ext';
    await avatarsBucket.upload(path, File(filePath));
    return avatarsBucket.getPublicUrl(path);
  }

  Future<String> uploadAvatarBytes(
    String userId,
    String filePath,
    Uint8List bytes,
  ) async {
    final ext = filePath.split('.').last;
    final path = '$userId/avatar.$ext';
    await avatarsBucket.uploadBinary(path, bytes);
    return avatarsBucket.getPublicUrl(path);
  }

  Future<String> uploadBanner(String userId, String filePath) async {
    final ext = filePath.split('.').last;
    final path = '$userId/banner.$ext';
    await bannersBucket.upload(path, File(filePath));
    return bannersBucket.getPublicUrl(path);
  }

  Future<String> uploadBannerBytes(
    String userId,
    String filePath,
    Uint8List bytes,
  ) async {
    final ext = filePath.split('.').last;
    final path = '$userId/banner.$ext';
    await bannersBucket.uploadBinary(path, bytes);
    return bannersBucket.getPublicUrl(path);
  }

  RealtimeChannel channel(String name) => client.channel(name);

  void dispose() {
    _client?.dispose();
    _client = null;
  }
}
