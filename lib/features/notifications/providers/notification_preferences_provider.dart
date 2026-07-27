import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/providers/app_providers.dart';

class NotificationPreferences {
  final bool newFollowers;
  final bool activityUpdates;
  final bool recommendations;
  final bool listUpdates;
  final bool weeklyDigest;
  final bool marketingEmails;

  NotificationPreferences({
    this.newFollowers = true,
    this.activityUpdates = true,
    this.recommendations = true,
    this.listUpdates = true,
    this.weeklyDigest = true,
    this.marketingEmails = false,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      newFollowers: json['new_followers'] as bool? ?? true,
      activityUpdates: json['activity_updates'] as bool? ?? true,
      recommendations: json['recommendations'] as bool? ?? true,
      listUpdates: json['list_updates'] as bool? ?? true,
      weeklyDigest: json['weekly_digest'] as bool? ?? true,
      marketingEmails: json['marketing_emails'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'new_followers': newFollowers,
    'activity_updates': activityUpdates,
    'recommendations': recommendations,
    'list_updates': listUpdates,
    'weekly_digest': weeklyDigest,
    'marketing_emails': marketingEmails,
  };
}

final notificationPreferencesProvider = FutureProvider<NotificationPreferences>(
  (ref) async {
    final authService = ref.read(authServiceProvider);
    final supabase = ref.read(supabaseServiceProvider);
    if (!authService.isAuthenticated) return NotificationPreferences();
    try {
      final response = await supabase.profiles
          .select('notification_preferences')
          .eq('id', authService.userId)
          .maybeSingle();
      if (response == null || response['notification_preferences'] == null) {
        return NotificationPreferences();
      }
      return NotificationPreferences.fromJson(
        response['notification_preferences'] as Map<String, dynamic>,
      );
    } catch (e) {
      return NotificationPreferences();
    }
  },
);

final updateNotificationPreferenceProvider =
    FutureProvider.family<void, (String key, bool value)>((ref, params) async {
      final (key, value) = params;
      final authService = ref.read(authServiceProvider);
      final supabase = ref.read(supabaseServiceProvider);
      if (!authService.isAuthenticated) return;

      final currentPrefs = await ref.read(
        notificationPreferencesProvider.future,
      );
      final updatedMap = currentPrefs.toJson();
      updatedMap[key] = value;

      await supabase.profiles
          .update({
            'notification_preferences': updatedMap,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', authService.userId);

      ref.invalidate(notificationPreferencesProvider);
    });
