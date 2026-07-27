import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../models/user_model.dart';

final followersProvider = FutureProvider.family<List<UserModel>, String>((
  ref,
  userId,
) async {
  final supabase = ref.watch(supabaseServiceProvider);
  final response = await supabase.followers
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

final followingProvider = FutureProvider.family<List<UserModel>, String>((
  ref,
  userId,
) async {
  final supabase = ref.watch(supabaseServiceProvider);
  final response = await supabase.followers
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

final currentUserFollowersProvider = FutureProvider<List<UserModel>>((
  ref,
) async {
  final auth = ref.watch(authServiceProvider);
  if (!auth.isAuthenticated) return [];
  return ref.watch(followersProvider(auth.userId)).value ?? [];
});

final currentUserFollowingProvider = FutureProvider<List<UserModel>>((
  ref,
) async {
  final auth = ref.watch(authServiceProvider);
  if (!auth.isAuthenticated) return [];
  return ref.watch(followingProvider(auth.userId)).value ?? [];
});

final friendActivityProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final auth = ref.watch(authServiceProvider);
  final supabase = ref.watch(supabaseServiceProvider);
  if (!auth.isAuthenticated) return [];
  final followingIds = await supabase.followers
      .select('following_id')
      .eq('follower_id', auth.userId);
  final ids = (followingIds as List<dynamic>)
      .map((e) => (e as Map<String, dynamic>)['following_id'] as String)
      .toList();
  if (ids.isEmpty) return [];
  final response = await supabase.activityLogs
      .select()
      .inFilter('user_id', ids)
      .order('created_at', ascending: false)
      .limit(100);
  return (response as List<dynamic>).cast<Map<String, dynamic>>();
});

final searchUsersProvider = FutureProvider.family<List<UserModel>, String>((
  ref,
  query,
) async {
  if (query.trim().isEmpty) return [];
  final supabase = ref.watch(supabaseServiceProvider);
  final response = await supabase.profiles
      .select()
      .or('username.ilike.%$query%,display_name.ilike.%$query%')
      .limit(20);
  final list = response as List<dynamic>;
  return list
      .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
      .toList();
});

final isFollowingProvider = FutureProvider.family<bool, String>((
  ref,
  targetUserId,
) async {
  final auth = ref.watch(authServiceProvider);
  final supabase = ref.watch(supabaseServiceProvider);
  if (!auth.isAuthenticated) return false;
  final response = await supabase.followers
      .select()
      .eq('follower_id', auth.userId)
      .eq('following_id', targetUserId)
      .maybeSingle();
  return response != null;
});

final followUserProvider = FutureProvider.family<void, String>((
  ref,
  targetUserId,
) async {
  final auth = ref.watch(authServiceProvider);
  final supabase = ref.watch(supabaseServiceProvider);
  final userId = auth.userId;
  await supabase.followers.insert({
    'follower_id': userId,
    'following_id': targetUserId,
    'created_at': DateTime.now().toIso8601String(),
  });
  ref.invalidate(currentUserFollowingProvider);
  ref.invalidate(friendActivityProvider);
  ref.invalidate(followersProvider(targetUserId));
  ref.invalidate(isFollowingProvider(targetUserId));
});

final unfollowUserProvider = FutureProvider.family<void, String>((
  ref,
  targetUserId,
) async {
  final auth = ref.watch(authServiceProvider);
  final supabase = ref.watch(supabaseServiceProvider);
  final userId = auth.userId;
  await supabase.followers
      .delete()
      .eq('follower_id', userId)
      .eq('following_id', targetUserId);
  ref.invalidate(currentUserFollowingProvider);
  ref.invalidate(friendActivityProvider);
  ref.invalidate(followersProvider(targetUserId));
  ref.invalidate(isFollowingProvider(targetUserId));
});

final blockedUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  final auth = ref.watch(authServiceProvider);
  final supabase = ref.watch(supabaseServiceProvider);
  if (!auth.isAuthenticated) return [];
  final response = await supabase.client
      .from('blocked_users')
      .select('blocked_user_id, profiles!blocked_user_id(*)')
      .eq('user_id', auth.userId);
  final list = response as List<dynamic>;
  return list.map((e) {
    final data = e as Map<String, dynamic>;
    return UserModel.fromJson(data['profiles'] as Map<String, dynamic>);
  }).toList();
});

final isBlockedProvider = FutureProvider.family<bool, String>((
  ref,
  targetUserId,
) async {
  final auth = ref.watch(authServiceProvider);
  final supabase = ref.watch(supabaseServiceProvider);
  if (!auth.isAuthenticated) return false;
  final response = await supabase.client
      .from('blocked_users')
      .select()
      .eq('user_id', auth.userId)
      .eq('blocked_user_id', targetUserId)
      .maybeSingle();
  return response != null;
});

final blockUserProvider = FutureProvider.family<void, String>((
  ref,
  targetUserId,
) async {
  final auth = ref.watch(authServiceProvider);
  final supabase = ref.watch(supabaseServiceProvider);
  final userId = auth.userId;
  await supabase.client.from('blocked_users').insert({
    'user_id': userId,
    'blocked_user_id': targetUserId,
    'created_at': DateTime.now().toIso8601String(),
  });
  await supabase.followers
      .delete()
      .eq('follower_id', userId)
      .eq('following_id', targetUserId);
  await supabase.followers
      .delete()
      .eq('follower_id', targetUserId)
      .eq('following_id', userId);
  ref.invalidate(blockedUsersProvider);
  ref.invalidate(isBlockedProvider(targetUserId));
  ref.invalidate(currentUserFollowingProvider);
  ref.invalidate(currentUserFollowersProvider);
  ref.invalidate(isFollowingProvider(targetUserId));
});

final unblockUserProvider = FutureProvider.family<void, String>((
  ref,
  targetUserId,
) async {
  final auth = ref.watch(authServiceProvider);
  final supabase = ref.watch(supabaseServiceProvider);
  final userId = auth.userId;
  await supabase.client
      .from('blocked_users')
      .delete()
      .eq('user_id', userId)
      .eq('blocked_user_id', targetUserId);
  ref.invalidate(blockedUsersProvider);
  ref.invalidate(isBlockedProvider(targetUserId));
});

final reportUserProvider =
    FutureProvider.family<
      void,
      ({String userId, String reason, String description})
    >((ref, params) async {
      final auth = ref.watch(authServiceProvider);
      final supabase = ref.watch(supabaseServiceProvider);
      final reporterId = auth.userId;
      await supabase.client.from('reports').insert({
        'reporter_id': reporterId,
        'reported_user_id': params.userId,
        'reason': params.reason,
        'description': params.description,
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      });
    });
