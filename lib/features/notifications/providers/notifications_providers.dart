import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/supabase_service.dart';
import '../../../models/notification_model.dart';

final _supabase = SupabaseService.instance;
final _authService = AuthService.instance;

final notificationsProvider = FutureProvider<List<NotificationModel>>((ref) async {
  if (!_authService.isAuthenticated) return [];
  final response = await _supabase.notifications
      .select()
      .eq('user_id', _authService.userId)
      .order('created_at', ascending: false)
      .limit(100);
  final list = response as List<dynamic>;
  return list.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
});

final unreadCountProvider = FutureProvider<int>((ref) async {
  final notifications = await ref.watch(notificationsProvider.future);
  return notifications.where((n) => !n.isRead).length;
});

final markNotificationReadProvider = FutureProvider.family<void, String>((ref, notificationId) async {
  await _supabase.notifications
      .update({'is_read': true})
      .eq('id', notificationId);
  ref.invalidate(notificationsProvider);
  ref.invalidate(unreadCountProvider);
});

final markAllNotificationsReadProvider = FutureProvider<void>((ref) async {
  await _supabase.notifications
      .update({'is_read': true})
      .eq('user_id', _authService.userId)
      .eq('is_read', false);
  ref.invalidate(notificationsProvider);
  ref.invalidate(unreadCountProvider);
});

final clearAllNotificationsProvider = FutureProvider<void>((ref) async {
  await _supabase.notifications
      .delete()
      .eq('user_id', _authService.userId);
  ref.invalidate(notificationsProvider);
  ref.invalidate(unreadCountProvider);
});
