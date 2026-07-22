import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../l10n/l10n.dart';
import 'providers/notification_preferences_provider.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final prefsAsync = ref.watch(notificationPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.notificationPreferences),
      ),
      body: prefsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: cs.error),
              const SizedBox(height: Spacing.sm),
              Text(context.l10n.failedToLoadPreferences, style: tt.bodyLarge),
              const SizedBox(height: Spacing.sm),
              TextButton(
                onPressed: () => ref.invalidate(notificationPreferencesProvider),
                child: Text(context.l10n.retry),
              ),
            ],
          ),
        ),
        data: (prefs) => ListView(
          padding: const EdgeInsetsDirectional.all(Spacing.lg),
          children: [
            Text(
              context.l10n.pushNotifications,
              style: tt.titleSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: Spacing.sm),
            Card(
              child: Column(
                children: [
                  _PreferenceSwitch(
                    title: context.l10n.newFollowers,
                    subtitle: context.l10n.newFollowersDescription,
                    value: prefs.newFollowers,
                    onChanged: (value) => ref.read(
                      updateNotificationPreferenceProvider(('new_followers', value)),
                    ),
                  ),
                  Divider(height: 1, indent: 56, color: cs.outline.withValues(alpha: 0.2)),
                  _PreferenceSwitch(
                    title: context.l10n.activityUpdates,
                    subtitle: context.l10n.activityUpdatesDescription,
                    value: prefs.activityUpdates,
                    onChanged: (value) => ref.read(
                      updateNotificationPreferenceProvider(('activity_updates', value)),
                    ),
                  ),
                  Divider(height: 1, indent: 56, color: cs.outline.withValues(alpha: 0.2)),
                  _PreferenceSwitch(
                    title: context.l10n.recommendations,
                    subtitle: context.l10n.recommendationsDescription,
                    value: prefs.recommendations,
                    onChanged: (value) => ref.read(
                      updateNotificationPreferenceProvider(('recommendations', value)),
                    ),
                  ),
                  Divider(height: 1, indent: 56, color: cs.outline.withValues(alpha: 0.2)),
                  _PreferenceSwitch(
                    title: context.l10n.listUpdates,
                    subtitle: context.l10n.listUpdatesDescription,
                    value: prefs.listUpdates,
                    onChanged: (value) => ref.read(
                      updateNotificationPreferenceProvider(('list_updates', value)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.xl),
            Text(
              context.l10n.emailNotifications,
              style: tt.titleSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: Spacing.sm),
            Card(
              child: Column(
                children: [
                  _PreferenceSwitch(
                    title: context.l10n.weeklyDigest,
                    subtitle: context.l10n.weeklyDigestDescription,
                    value: prefs.weeklyDigest,
                    onChanged: (value) => ref.read(
                      updateNotificationPreferenceProvider(('weekly_digest', value)),
                    ),
                  ),
                  Divider(height: 1, indent: 56, color: cs.outline.withValues(alpha: 0.2)),
                  _PreferenceSwitch(
                    title: context.l10n.marketingEmails,
                    subtitle: context.l10n.marketingEmailsDescription,
                    value: prefs.marketingEmails,
                    onChanged: (value) => ref.read(
                      updateNotificationPreferenceProvider(('marketing_emails', value)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreferenceSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PreferenceSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SwitchListTile(
      title: Text(title, style: tt.bodyMedium),
      subtitle: Text(
        subtitle,
        style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
      ),
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
    );
  }
}
