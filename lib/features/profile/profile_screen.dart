import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/providers/app_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../core/models/gender.dart';
import '../../core/services/behavior_service.dart';
import '../../models/user_model.dart';
import '../auth/providers/auth_providers.dart';
import '../moderation/providers/moderation_providers.dart';
import '../recommendations/providers/recommendation_providers.dart';
import 'providers/profile_providers.dart';

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
      appBar: AppBar(
        title: Text(isOwn ? l10n.navProfile : l10n.userProfile),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: colorScheme.error),
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
                  Icon(Icons.person_off_rounded, size: 48, color: colorScheme.onSurfaceVariant),
                  const SizedBox(height: Spacing.sm),
                  Text(l10n.profileNotFound, style: textTheme.bodyLarge),
                  const SizedBox(height: Spacing.md),
                  Text(
                    'Make sure the database grants have been applied.\n'
                    'Run supabase/grants.sql in your Supabase SQL editor.',
                    style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
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
                        padding: EdgeInsetsDirectional.symmetric(horizontal: hp, vertical: Spacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfileHeader(context, profile, isOwn, colorScheme, textTheme),
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
                        padding: EdgeInsetsDirectional.only(end: hp, top: Spacing.xl, bottom: Spacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildSettingsSections(context, profile, isOwn, colorScheme, textTheme, isModerator, ref),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return ListView(
                padding: EdgeInsetsDirectional.symmetric(horizontal: hp, vertical: Spacing.md),
                children: [
                  _buildProfileHeader(context, profile, isOwn, colorScheme, textTheme),
                  ..._buildSettingsSections(context, profile, isOwn, colorScheme, textTheme, isModerator, ref),
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
            _SettingsTile(
              icon: Icons.palette_rounded,
              title: l10n.theme,
              subtitle: switch (ref.watch(themeModeProvider)) {
                ThemeMode.light => l10n.lightMode,
                ThemeMode.dark => l10n.darkMode,
                _ => l10n.systemMode,
              },
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => _showThemePicker(context),
            ),
            _SettingsTile(
              icon: Icons.language_rounded,
              title: l10n.language,
              subtitle: switch (ref.watch(localeProvider).languageCode) {
                'ar' => 'العربية',
                _ => 'English',
              },
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => _showLanguagePicker(context),
            ),
          ],
          colorScheme,
          textTheme,
        ),
        _buildSection(
          l10n.account,
          [
            _SettingsTile(
              icon: Icons.person_rounded,
              title: l10n.editProfile,
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.pushNamed('editProfile'),
            ),
            _SettingsTile(
              icon: Icons.lock_rounded,
              title: l10n.changePassword,
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => _showChangePasswordDialog(context, ref),
            ),
            if (isModerator)
              _SettingsTile(
                icon: Icons.shield_rounded,
                title: l10n.moderation,
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/moderation'),
              ),
            _SettingsTile(
              icon: Icons.delete_forever_rounded,
              title: l10n.deleteAccount,
              titleColor: colorScheme.error,
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.error,
              ),
              onTap: () => _showDeleteAccountDialog(context, ref),
            ),
          ],
          colorScheme,
          textTheme,
        ),
        _buildSection(
          l10n.recommendationsAndPrivacy,
          [
            _SettingsTile(
              icon: Icons.auto_awesome_rounded,
              title: l10n.personalizedRecommendations,
              subtitle: 'Let your activity improve suggestions',
              trailing: Consumer(builder: (context, ref, _) {
                return Switch(
                  value: ref.watch(recsEnabledProvider),
                  onChanged: (enabled) async {
                    if (enabled) {
                      await BehaviorService.instance.enableRecommendations();
                    } else {
                      await BehaviorService.instance.disableRecommendations();
                    }
                    ref.read(recsEnabledProvider.notifier).state = enabled;
                  },
                );
              }),
            ),
            _SettingsTile(
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
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
                      FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.delete)),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await BehaviorService.instance.clearAllEvents();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.clearHistory)),
                    );
                  }
                }
              },
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
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: l10n.appVersion,
            subtitle: '0.7.3',
            onTap: () => _showVersionDialog(context),
          ),
          _SettingsTile(
            icon: Icons.description_rounded,
            title: l10n.termsOfService,
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _showTerms(context),
          ),
          _SettingsTile(
            icon: Icons.shield_rounded,
            title: l10n.privacyPolicy,
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _showPrivacy(context),
          ),
          _SettingsTile(
            icon: Icons.code_rounded,
            title: l10n.licenses,
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'WatchAtlas',
              applicationVersion: '0.7.3',
            ),
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
                      errorWidget: (_, __, ___) => Text(initials, style: textTheme.headlineMedium),
                    ),
                  )
                : profile.defaultAvatar != null
                    ? ClipOval(
                        child: Image.asset(
                          profile.defaultAvatar!,
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Text(initials, style: textTheme.headlineMedium),
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
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ),
        const SizedBox(height: Spacing.md),
        Card(
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Column(
            children: [
              _InfoRow(
                icon: Icons.person_rounded,
                label: l10n.displayName,
                value: profile.displayName ?? profile.username,
              ),
              Divider(height: 1, indent: 56, color: colorScheme.outline.withValues(alpha: 0.2)),
              _InfoRow(
                icon: Icons.alternate_email_rounded,
                label: l10n.username,
                value: profile.username,
              ),
              Divider(height: 1, indent: 56, color: colorScheme.outline.withValues(alpha: 0.2)),
              _InfoRow(
                icon: Icons.email_rounded,
                label: l10n.email,
                value: profile.email,
              ),
              if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                Divider(height: 1, indent: 56, color: colorScheme.outline.withValues(alpha: 0.2)),
                _InfoRow(
                  icon: Icons.info_outline_rounded,
                  label: l10n.bio,
                  value: profile.bio!,
                ),
              ],
              if (profile.gender != null) ...[
                Divider(height: 1, indent: 56, color: colorScheme.outline.withValues(alpha: 0.2)),
                _InfoRow(
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
                Divider(height: 1, indent: 56, color: colorScheme.outline.withValues(alpha: 0.2)),
                _InfoRow(
                  icon: Icons.cake_rounded,
                  label: l10n.age,
                  value: '${_calculateAge(profile.dateOfBirth!)} (${profile.dateOfBirth!.month}/${profile.dateOfBirth!.day}/${profile.dateOfBirth!.year})',
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
              ],
            ),
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
          padding: const EdgeInsetsDirectional.fromSTEB(Spacing.lg, Spacing.lg, Spacing.lg, Spacing.sm),
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

  void _showThemePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final current = ref.read(themeModeProvider);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
                child: Text(l10n.chooseTheme, style: Theme.of(ctx).textTheme.titleMedium),
              ),
              ListTile(
                leading: const Icon(Icons.settings_suggest_rounded),
                title: Text(l10n.systemMode),
                subtitle: Text(l10n.followSystem),
                trailing: current == ThemeMode.system
                    ? Icon(Icons.check, color: Theme.of(ctx).colorScheme.primary)
                    : null,
                onTap: () {
                  ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.light_mode_rounded),
                title: Text(l10n.lightMode),
                trailing: current == ThemeMode.light
                    ? Icon(Icons.check, color: Theme.of(ctx).colorScheme.primary)
                    : null,
                onTap: () {
                  ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode_rounded),
                title: Text(l10n.darkMode),
                trailing: current == ThemeMode.dark
                    ? Icon(Icons.check, color: Theme.of(ctx).colorScheme.primary)
                    : null,
                onTap: () {
                  ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final current = ref.read(localeProvider);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
                child: Text(l10n.chooseLanguage, style: Theme.of(ctx).textTheme.titleMedium),
              ),
              ListTile(
                leading: const Icon(Icons.language_rounded),
                title: Text(l10n.englishLanguage),
                trailing: current.languageCode == 'en'
                    ? Icon(Icons.check, color: Theme.of(ctx).colorScheme.primary)
                    : null,
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language_rounded),
                title: Text(l10n.arabicLanguage),
                trailing: current.languageCode == 'ar'
                    ? Icon(Icons.check, color: Theme.of(ctx).colorScheme.primary)
                    : null,
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(const Locale('ar'));
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context, WidgetRef ref, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: OutlinedButton.icon(
        onPressed: () => _showSignOutDialog(context, ref),
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

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.signOutConfirmation),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) context.go('/auth');
            },
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext parentContext, WidgetRef ref) {
    final l10n = AppLocalizations.of(parentContext)!;
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteAccount),
        content: Text(l10n.deleteAccountWarning),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(dialogContext).colorScheme.error),
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref.read(authServiceProvider).deleteAccount();
                if (parentContext.mounted) {
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    SnackBar(content: Text(l10n.deleteAccount)),
                  );
                  ref.read(authNotifierProvider.notifier).signOut();
                }
              } catch (e) {
                if (parentContext.mounted) {
                  ScaffoldMessenger.of(parentContext).showSnackBar(SnackBar(content: Text(l10n.errorWithDetails(e.toString()))));
                }
              }
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext parentContext, WidgetRef ref) {
    final l10n = AppLocalizations.of(parentContext)!;
    final emailController = TextEditingController();
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.changePassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.enterEmailForReset),
            const SizedBox(height: Spacing.lg),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: l10n.email,
                prefixIcon: const Icon(Icons.email_rounded),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isEmpty) return;
              Navigator.pop(dialogContext);
              try {
                await ref.read(authNotifierProvider.notifier).resetPassword(email);
                if (parentContext.mounted) {
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    SnackBar(content: Text(l10n.sendResetLink)),
                  );
                }
              } catch (e) {
                if (parentContext.mounted) {
                  ScaffoldMessenger.of(parentContext).showSnackBar(SnackBar(content: Text(l10n.errorWithDetails(e.toString()))));
                }
              }
            },
            child: Text(l10n.sendResetLink),
          ),
        ],
      ),
    );
  }

  void _showVersionDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showAboutDialog(
      context: context,
      applicationName: 'WatchAtlas',
      applicationVersion: '0.7.3',
      applicationLegalese: '© 2026 WatchAtlas',
      children: [
        const SizedBox(height: Spacing.lg),
        Text(l10n.aboutAppDescription),
      ],
    );
  }

  void _showTerms(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.termsOfServiceTitle),
        content: SingleChildScrollView(
          child: Text(l10n.termsOfServiceBody),
        ),
        actions: [
          FilledButton(onPressed: () => Navigator.pop(context), child: Text(l10n.close)),
        ],
      ),
    );
  }

  void _showPrivacy(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.privacyPolicy),
        content: SingleChildScrollView(
          child: Text(l10n.privacyPolicyBody),
        ),
        actions: [
          FilledButton(onPressed: () => Navigator.pop(context), child: Text(l10n.close)),
        ],
      ),
    );
  }
}

int _calculateAge(DateTime dateOfBirth) {
  final now = DateTime.now();
  int age = now.year - dateOfBirth.year;
  if (now.isBefore(DateTime(dateOfBirth.year, dateOfBirth.month, dateOfBirth.day))) {
    age--;
  }
  return age;
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? titleColor;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.titleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.onSurfaceVariant, size: 22),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: titleColor ?? colorScheme.onSurface,
            ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: Spacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                const SizedBox(height: 2),
                Text(value, maxLines: 3, overflow: TextOverflow.ellipsis, style: textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}