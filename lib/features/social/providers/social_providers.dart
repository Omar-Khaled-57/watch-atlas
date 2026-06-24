import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/supabase_service.dart';
import '../../../models/user_model.dart';

final _supabase = SupabaseService.instance;
final _authService = AuthService.instance;

final followersProvider = FutureProvider.family<List<UserModel>, String>((ref, userId) async {
  final response = await _supabase.followers
      .select('''
        follower_id,
        profiles!follower_id(*)
      ''')
      .eq('following_id', userId);
  final list = response as List<dynamic>;
  return list.map((e) {
    final data = e as Map<String, dynamic>;
    return UserModel.fromJson(data['profiles'] as Map<String, dynamic>);
  }).toList();
});

final followingProvider = FutureProvider.family<List<UserModel>, String>((ref, userId) async {
  final response = await _supabase.followers
      .select('''
        following_id,
        profiles!following_id(*)
      ''')
      .eq('follower_id', userId);
  final list = response as List<dynamic>;
  return list.map((e) {
    final data = e as Map<String, dynamic>;
    return UserModel.fromJson(data['profiles'] as Map<String, dynamic>);
  }).toList();
});

final currentUserFollowersProvider = FutureProvider<List<UserModel>>((ref) async {
  if (!_authService.isAuthenticated) return [];
  return ref.watch(followersProvider(_authService.userId)).value ?? [];
});

final currentUserFollowingProvider = FutureProvider<List<UserModel>>((ref) async {
  if (!_authService.isAuthenticated) return [];
  return ref.watch(followingProvider(_authService.userId)).value ?? [];
});

final friendActivityProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  if (!_authService.isAuthenticated) return [];
  final followingIds = await _supabase.followers
      .select('following_id')
      .eq('follower_id', _authService.userId);
  final ids = (followingIds as List<dynamic>)
      .map((e) => (e as Map<String, dynamic>)['following_id'] as String)
      .toList();
  if (ids.isEmpty) return [];
  final response = await _supabase.activityLogs
      .select()
      .inFilter('user_id', ids)
      .order('created_at', ascending: false)
      .limit(100);
  return (response as List<dynamic>).cast<Map<String, dynamic>>();
});

final searchUsersProvider = FutureProvider.family<List<UserModel>, String>((ref, query) async {
  if (query.trim().isEmpty) return [];
  final response = await _supabase.profiles
      .select()
      .or('username.ilike.%$query%,display_name.ilike.%$query%')
      .limit(20);
  final list = response as List<dynamic>;
  return list.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
});

final isFollowingProvider = FutureProvider.family<bool, String>((ref, targetUserId) async {
  if (!_authService.isAuthenticated) return false;
  final response = await _supabase.followers
      .select()
      .eq('follower_id', _authService.userId)
      .eq('following_id', targetUserId)
      .maybeSingle();
  return response != null;
});

final followUserProvider = FutureProvider.family<void, String>((ref, targetUserId) async {
  final userId = _authService.userId;
  await _supabase.followers.insert({
    'follower_id': userId,
    'following_id': targetUserId,
    'created_at': DateTime.now().toIso8601String(),
  });
  ref.invalidate(currentUserFollowingProvider);
  ref.invalidate(friendActivityProvider);
  ref.invalidate(followersProvider(targetUserId));
  ref.invalidate(isFollowingProvider(targetUserId));
});

final unfollowUserProvider = FutureProvider.family<void, String>((ref, targetUserId) async {
  final userId = _authService.userId;
  await _supabase.followers
      .delete()
      .eq('follower_id', userId)
      .eq('following_id', targetUserId);
  ref.invalidate(currentUserFollowingProvider);
  ref.invalidate(friendActivityProvider);
  ref.invalidate(followersProvider(targetUserId));
  ref.invalidate(isFollowingProvider(targetUserId));
});
