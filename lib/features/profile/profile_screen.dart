import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/providers/app_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../core/models/gender.dart';
import '../../l10n/l10n.dart';
import '../../models/user_model.dart';
import '../moderation/providers/moderation_providers.dart';
import '../recommendations/providers/recommendation_providers.dart';
import '../social/providers/social_providers.dart';
import 'providers/profile_providers.dart';
import 'providers/privacy_provider.dart';
import 'widgets/profile_dialogs.dart';
import 'widgets/profile_widgets.dart';

/// User profile screen showing avatar, stats, activity, and settings.
///
/// When [userId] is null, shows the current user's own profile with full
/// settings (theme, language, sign out, delete account). When [userId] is
/// provided, shows another user's profile with follow/report/block actions.
class ProfileScreen extends ConsumerStatefulWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final isOwn = widget.userId == null;
    final uid = widget.userId ?? ref.watch(authServiceProvider).userId;
    final isModerator = ref.watch(isModeratorProvider);

    final profileAsync = ref.watch(
      isOwn ? currentUserProfileProvider : userProfileProvider(uid),
    );

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(isOwn ? l10n.navProfile : l10n.userProfile)),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: colorScheme.error,
              ),
              const SizedBox(height: Spacing.sm),
              Text(l10n.failedToLoadProfile, style: textTheme.bodyLarge),
              const SizedBox(height: Spacing.sm),
              TextButton(
                onPressed: () => ref.invalidate(currentUserProfileProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (profile) {
          if (profile == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_off_rounded,
                    size: 48,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(l10n.profileNotFound, style: textTheme.bodyLarge),
                  const SizedBox(height: Spacing.md),
                  Text(
                    context.l10n.profileDatabaseError,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Spacing.lg),
                  TextButton.icon(
                    onPressed: () => ref.invalidate(currentUserProfileProvider),
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final isLandscape = constraints.maxWidth > constraints.maxHeight;
              const portraitPadding = Spacing.lg;
              final hp = isLandscape ? Spacing.xxl : portraitPadding;

              if (isLandscape) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 360,
                      child: SingleChildScrollView(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: hp,
                          vertical: Spacing.xl,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfileHeader(
                              context,
                              profile,
                              isOwn,
                              colorScheme,
                              textTheme,
                            ),
                            if (isOwn) ...[
                              const SizedBox(height: Spacing.lg),
                              _buildSignOutButton(context, ref, colorScheme),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: Spacing.xl),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsetsDirectional.only(
                          end: hp,
                          top: Spacing.xl,
                          bottom: Spacing.xl,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildSettingsSections(
                            context,
                            profile,
                            isOwn,
                            colorScheme,
                            textTheme,
                            isModerator,
                            ref,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return ListView(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: hp,
                  vertical: Spacing.md,
                ),
                children: [
                  _buildProfileHeader(
                    context,
                    profile,
                    isOwn,
                    colorScheme,
                    textTheme,
                  ),
                  ..._buildSettingsSections(
                    context,
                    profile,
                    isOwn,
                    colorScheme,
                    textTheme,
                    isModerator,
                    ref,
                  ),
                  if (isOwn) ...[
                    const SizedBox(height: Spacing.sm),
                    _buildSignOutButton(context, ref, colorScheme),
                  ],
                  const SizedBox(height: Spacing.xxl),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildSettingsSections(
    BuildContext context,
    UserModel profile,
    bool isOwn,
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isModerator,
    WidgetRef ref,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final sections = <Widget>[];

    if (isOwn) {
      sections.addAll([
        const SizedBox(height: Spacing.md),
        _buildSection(
          l10n.appearance,
          [
            SettingsTile(
              icon: Icons.palette_rounded,
              title: l10n.theme,
              subtitle: switch (ref.watch(themeModeProvider)) {
                ThemeMode.light => l10n.lightMode,
                ThemeMode.dark => l10n.darkMode,
                _ => l10n.systemMode,
              },
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => showThemePicker(context, ref),
            ),
            SettingsTile(
              icon: Icons.language_rounded,
              title: l10n.language,
              subtitle: switch (ref.watch(localeProvider).languageCode) {
                'ar' => context.l10n.arabicLanguage,
                _ => context.l10n.englishLanguage,
              },
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => showLanguagePicker(context, ref),
            ),
          ],
          colorScheme,
          textTheme,
        ),
        _buildSection(
          l10n.account,
          [
            SettingsTile(
              icon: Icons.person_rounded,
              title: l10n.editProfile,
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.pushNamed('editProfile'),
            ),
            SettingsTile(
              icon: Icons.lock_rounded,
              title: l10n.changePassword,
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => showChangePasswordDialog(context, ref),
            ),
            if (isModerator)
              SettingsTile(
                icon: Icons.shield_rounded,
                title: l10n.moderation,
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/moderation'),
              ),
            SettingsTile(
              icon: Icons.delete_forever_rounded,
              title: l10n.deleteAccount,
              titleColor: colorScheme.error,
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.error,
              ),
              onTap: () => showDeleteAccountDialog(context, ref),
            ),
          ],
          colorScheme,
          textTheme,
        ),
        _buildSection(
          l10n.recommendationsAndPrivacy,
          [
            SettingsTile(
              icon: Icons.auto_awesome_rounded,
              title: l10n.personalizedRecommendations,
              subtitle: context.l10n.activityImprovesSuggestions,
              trailing: Consumer(
                builder: (context, ref, _) {
                  final recsAsync = ref.watch(recsEnabledProvider);
                  return recsAsync.when(
                    loading: () => const SizedBox(
                      width: 48,
                      height: 28,
                      child: Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    error: (_, __) => const SizedBox(width: 48, height: 28),
                    data: (enabled) => Semantics(
                      toggled: enabled,
                      label: l10n.personalizedRecommendations,
                      child: Switch(
                        value: enabled,
                        onChanged: (value) => ref
                            .read(recsEnabledActionsProvider)
                            .setEnabled(value),
                      ),
                    ),
                  );
                },
              ),
            ),
            SettingsTile(
              icon: Icons.delete_sweep_rounded,
              title: l10n.clearRecommendationHistory,
              subtitle: l10n.removeAllBehavioralData,
              onTap: () async {
                final l10n = AppLocalizations.of(context)!;
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.clearHistory),
                    content: Text(l10n.clearActivityWarning),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(l10n.cancel),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(l10n.delete),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await ref.read(behaviorServiceProvider).clearAllEvents();
                  ref.invalidate(recommendationsProvider);
                  ref.invalidate(recsEnabledProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(l10n.clearHistory)));
                  }
                }
              },
            ),
          ],
          colorScheme,
          textTheme,
        ),
        _buildSection(
          l10n.privacySettings,
          [
            SettingsTile(
              icon: Icons.public_rounded,
              title: l10n.publicProfile,
              subtitle: l10n.publicProfileDesc,
              trailing: Consumer(
                builder: (context, ref, _) {
                  final settings = ref.watch(privacySettingsProvider);
                  return Semantics(
                    toggled: settings.publicProfile,
                    label: l10n.publicProfile,
                    child: Switch(
                      value: settings.publicProfile,
                      onChanged: (value) => ref
                          .read(privacySettingsProvider.notifier)
                          .setPublicProfile(value),
                    ),
                  );
                },
              ),
            ),
            SettingsTile(
              icon: Icons.visibility_rounded,
              title: l10n.showActivity,
              subtitle: l10n.showActivityDesc,
              trailing: Consumer(
                builder: (context, ref, _) {
                  final settings = ref.watch(privacySettingsProvider);
                  return Semantics(
                    toggled: settings.showActivity,
                    label: l10n.showActivity,
                    child: Switch(
                      value: settings.showActivity,
                      onChanged: (value) => ref
                          .read(privacySettingsProvider.notifier)
                          .setShowActivity(value),
                    ),
                  );
                },
              ),
            ),
          ],
          colorScheme,
          textTheme,
        ),
      ]);
    }

    sections.addAll([
      _buildSection(
        l10n.about,
        [
          SettingsTile(
            icon: Icons.info_outline_rounded,
            title: l10n.appVersion,
            subtitle: AppConstants.appVersion,
            onTap: () => showVersionDialog(context),
          ),
          SettingsTile(
            icon: Icons.description_rounded,
            title: l10n.termsOfService,
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => showTerms(context),
          ),
          SettingsTile(
            icon: Icons.shield_rounded,
            title: l10n.privacyPolicy,
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => showPrivacy(context),
          ),
          SettingsTile(
            icon: Icons.code_rounded,
            title: l10n.licenses,
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => showLicenses(context),
          ),
          SettingsTile(
            icon: Icons.attribution_rounded,
            title: l10n.contentAndAttribution,
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => showAttribution(context),
          ),
        ],
        colorScheme,
        textTheme,
      ),
    ]);

    return sections;
  }

  Widget _buildProfileHeader(
    BuildContext context,
    UserModel profile,
    bool isOwn,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final initials = (profile.displayName ?? profile.username)[0].toUpperCase();

    return Column(
      children: [
        const SizedBox(height: Spacing.sm),
        Center(
          child: CircleAvatar(
            radius: 48,
            backgroundColor: colorScheme.surfaceContainerHighest,
            child: profile.avatarUrl != null
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: profile.avatarUrl!,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          Text(initials, style: textTheme.headlineMedium),
                    ),
                  )
                : profile.defaultAvatar != null
                ? ClipOval(
                    child: Image.asset(
                      profile.defaultAvatar!,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Text(initials, style: textTheme.headlineMedium),
                    ),
                  )
                : Text(initials, style: textTheme.headlineMedium),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Center(
          child: Text(
            profile.displayName ?? profile.username,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Center(
          child: Text(
            '@${profile.username}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: Spacing.md),
        Card(
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Column(
            children: [
              InfoRow(
                icon: Icons.person_rounded,
                label: l10n.displayName,
                value: profile.displayName ?? profile.username,
              ),
              Divider(
                height: 1,
                indent: 56,
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
              InfoRow(
                icon: Icons.alternate_email_rounded,
                label: l10n.username,
                value: profile.username,
              ),
              Divider(
                height: 1,
                indent: 56,
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
              InfoRow(
                icon: Icons.email_rounded,
                label: l10n.email,
                value: profile.email,
              ),
              if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                Divider(
                  height: 1,
                  indent: 56,
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
                InfoRow(
                  icon: Icons.info_outline_rounded,
                  label: l10n.bio,
                  value: profile.bio!,
                ),
              ],
              if (profile.gender != null) ...[
                Divider(
                  height: 1,
                  indent: 56,
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
                InfoRow(
                  icon: Icons.wc_rounded,
                  label: l10n.gender,
                  value: switch (profile.gender!) {
                    Gender.male => l10n.male,
                    Gender.female => l10n.female,
                    Gender.ratherNotSay => l10n.ratherNotSay,
                  },
                ),
              ],
              if (profile.dateOfBirth != null) ...[
                Divider(
                  height: 1,
                  indent: 56,
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
                InfoRow(
                  icon: Icons.cake_rounded,
                  label: l10n.age,
                  value:
                      '${_calculateAge(profile.dateOfBirth!)} (${profile.dateOfBirth!.month}/${profile.dateOfBirth!.day}/${profile.dateOfBirth!.year})',
                ),
              ],
            ],
          ),
        ),
        if (isOwn) ...[
          const SizedBox(height: Spacing.md),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: Column(
              children: [
                FilledButton.icon(
                  onPressed: () => context.pushNamed('editProfile'),
                  icon: const Icon(Icons.edit_rounded),
                  label: Text(l10n.editProfile),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                OutlinedButton.icon(
                  onPressed: () => context.push('/tracking'),
                  icon: const Icon(Icons.timeline_rounded),
                  label: Text(l10n.viewTracking),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                OutlinedButton.icon(
                  onPressed: () => context.push('/analytics'),
                  icon: const Icon(Icons.analytics_rounded),
                  label: Text(l10n.viewAnalytics),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                OutlinedButton.icon(
                  onPressed: () => context.push('/social'),
                  icon: const Icon(Icons.people_rounded),
                  label: Text(l10n.community),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (!isOwn) ...[
          const SizedBox(height: Spacing.md),
          _buildBlockReportSection(
            context,
            ref,
            profile,
            colorScheme,
            textTheme,
          ),
        ],
      ],
    );
  }

  Widget _buildSection(
    String title,
    List<Widget> tiles,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            Spacing.lg,
            Spacing.lg,
            Spacing.lg,
            Spacing.sm,
          ),
          child: Text(
            title,
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Column(
            children: List.generate(tiles.length, (index) {
              final isLast = index == tiles.length - 1;
              return Column(
                children: [
                  tiles[index],
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 56,
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildBlockReportSection(
    BuildContext context,
    WidgetRef ref,
    UserModel profile,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final isBlockedAsync = ref.watch(isBlockedProvider(profile.id));

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: isBlockedAsync.when(
        data: (isBlocked) => Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => showReportDialog(context, ref, profile),
                icon: const Icon(Icons.flag_rounded, size: 18),
                label: Text(l10n.report),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: isBlocked
                  ? FilledButton.icon(
                      onPressed: () =>
                          ref.read(unblockUserProvider(profile.id)),
                      icon: const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 18,
                      ),
                      label: Text(l10n.unblock),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    )
                  : OutlinedButton.icon(
                      onPressed: () => showBlockDialog(context, ref, profile),
                      icon: const Icon(Icons.block_rounded, size: 18),
                      label: Text(l10n.block),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        foregroundColor: colorScheme.error,
                        side: BorderSide(
                          color: colorScheme.error.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
            ),
          ],
        ),
        loading: () => const SizedBox(height: 48),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildSignOutButton(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: OutlinedButton.icon(
        onPressed: () => showSignOutDialog(context, ref),
        icon: const Icon(Icons.logout_rounded),
        label: Text(l10n.signOut),
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.error,
          side: BorderSide(color: colorScheme.error.withValues(alpha: 0.5)),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    );
  }
}

int _calculateAge(DateTime dateOfBirth) {
  final now = DateTime.now();
  int age = now.year - dateOfBirth.year;
  if (now.isBefore(
    DateTime(dateOfBirth.year, dateOfBirth.month, dateOfBirth.day),
  )) {
    age--;
  }
  return age;
}
