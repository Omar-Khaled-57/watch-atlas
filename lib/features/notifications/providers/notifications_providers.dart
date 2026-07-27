import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../models/notification_model.dart';

final notificationsProvider = FutureProvider<List<NotificationModel>>((
  ref,
) async {
  final auth = ref.watch(authServiceProvider);
  final supabase = ref.watch(supabaseServiceProvider);
  if (!auth.isAuthenticated) return [];
  final response = await supabase.notifications
      .select()
      .eq('user_id', auth.userId)
      .order('created_at', ascending: false)
      .limit(100);
  final list = response as List<dynamic>;
  return list
      .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
      .toList();
});

final unreadCountProvider = FutureProvider<int>((ref) async {
  final notifications = await ref.watch(notificationsProvider.future);
  return notifications.where((n) => !n.isRead).length;
});

final markNotificationReadProvider = FutureProvider.family<void, String>((
  ref,
  notificationId,
) async {
  final supabase = ref.watch(supabaseServiceProvider);
  await supabase.notifications
      .update({'is_read': true})
      .eq('id', notificationId);
  ref.invalidate(notificationsProvider);
  ref.invalidate(unreadCountProvider);
});

final markAllNotificationsReadProvider = FutureProvider<void>((ref) async {
  final auth = ref.watch(authServiceProvider);
  final supabase = ref.watch(supabaseServiceProvider);
  await supabase.notifications
      .update({'is_read': true})
      .eq('user_id', auth.userId)
      .eq('is_read', false);
  ref.invalidate(notificationsProvider);
  ref.invalidate(unreadCountProvider);
});

final clearAllNotificationsProvider = FutureProvider<void>((ref) async {
  final auth = ref.watch(authServiceProvider);
  final supabase = ref.watch(supabaseServiceProvider);
  await supabase.notifications.delete().eq('user_id', auth.userId);
  ref.invalidate(notificationsProvider);
  ref.invalidate(unreadCountProvider);
});
