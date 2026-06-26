import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/supabase_service.dart';
import '../../../models/user_model.dart';
import '../../auth/providers/auth_providers.dart';

class UserActivity {
  final String id;
  final String type;
  final String description;
  final String? mediaTitle;
  final String? mediaPoster;
  final DateTime? createdAt;

  const UserActivity({
    required this.id,
    required this.type,
    required this.description,
    this.mediaTitle,
    this.mediaPoster,
    this.createdAt,
  });

  factory UserActivity.fromJson(Map<String, dynamic> json) => UserActivity(
        id: json['id'] as String,
        type: json['type'] as String? ?? 'unknown',
        description: json['description'] as String? ?? '',
        mediaTitle: json['media_title'] as String?,
        mediaPoster: json['media_poster'] as String?,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'] as String)
            : null,
      );
}

final _supabase = SupabaseService.instance;
final _authService = AuthService.instance;

final currentUserProfileProvider = FutureProvider<UserModel?>((ref) async {
  ref.watch(authStateProvider);
  ref.watch(authNotifierProvider);
  final uid = _authService.userId;
  if (uid.isEmpty || !_authService.isAuthenticated) return null;
  final profile = await _authService.getProfile();
  debugPrint('currentUserProfileProvider: uid=$uid profile=${profile != null}');
  return profile;
});

final userProfileProvider = FutureProvider.family<UserModel?, String>((ref, userId) async {
  try {
    final response = await _supabase.profiles
        .select()
        .eq('id', userId)
        .single();
    return UserModel.fromJson(response);
  } catch (e) {
    debugPrint('Failed to load profile for $userId: $e');
    return null;
  }
});

final updateProfileProvider = FutureProvider.family<void, Map<String, dynamic>>((ref, updates) async {
  await _authService.updateProfile(updates);
});

final userActivityProvider = FutureProvider.family<List<UserActivity>, String>((ref, userId) async {
  final response = await _supabase.activityLogs
      .select()
      .eq('user_id', userId)
      .order('created_at', ascending: false)
      .limit(50);
  final list = response as List<dynamic>;
  return list.map((e) => UserActivity.fromJson(e as Map<String, dynamic>)).toList();
});

final currentUserActivityProvider = FutureProvider<List<UserActivity>>((ref) async {
  ref.watch(authStateProvider);
  ref.watch(authNotifierProvider);
  final uid = _authService.userId;
  if (uid.isEmpty || !_authService.isAuthenticated) return [];
  final response = await _supabase.activityLogs
      .select()
      .eq('user_id', uid)
      .order('created_at', ascending: false)
      .limit(50);
  final list = response as List<dynamic>;
  return list.map((e) => UserActivity.fromJson(e as Map<String, dynamic>)).toList();
});
