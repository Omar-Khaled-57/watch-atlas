import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

class SupabaseService {
  SupabaseService._();

  static final SupabaseService instance = SupabaseService._();
  SupabaseClient? _client;

  SupabaseClient get client {
    if (_client == null) {
      throw StateError('Supabase not initialized. Call init() first.');
    }
    return _client!;
  }

  GoTrueClient get auth => client.auth;
  SupabaseQueryBuilder get profiles => client.from('profiles');
  SupabaseQueryBuilder get media => client.from('media');
  SupabaseQueryBuilder get customMedia => client.from('custom_media');
  SupabaseQueryBuilder get userMedia => client.from('user_media');
  SupabaseQueryBuilder get userProgress => client.from('user_progress');
  SupabaseQueryBuilder get userRatings => client.from('user_ratings');
  SupabaseQueryBuilder get userReviews => client.from('user_reviews');
  SupabaseQueryBuilder get userLists => client.from('user_lists');
  SupabaseQueryBuilder get listItems => client.from('list_items');
  SupabaseQueryBuilder get followers => client.from('followers');
  SupabaseQueryBuilder get comments => client.from('comments');
  SupabaseQueryBuilder get notifications => client.from('notifications');
  SupabaseQueryBuilder get activityLogs => client.from('activity_logs');
  SupabaseQueryBuilder get watchHistory => client.from('watch_history');
  SupabaseQueryBuilder get syncQueue => client.from('sync_queue');
  SupabaseQueryBuilder get recommendations => client.from('recommendations');

  Future<void> init() async {
    await dotenv.load();
    final supabaseUrl = dotenv.env[AppConstants.supabaseUrlKey] ?? '';
    final supabaseAnonKey = dotenv.env[AppConstants.supabaseAnonKey] ?? '';
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
    _client = Supabase.instance.client;
  }

  RealtimeChannel channel(String name) => client.channel(name);

  void dispose() {
    client.dispose();
    _client = null;
  }
}
