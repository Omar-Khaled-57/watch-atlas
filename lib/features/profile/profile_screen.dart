import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/providers/app_providers.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(isOwn ? 'Profile' : 'User Profile'),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: colorScheme.error),
              const SizedBox(height: Spacing.sm),
              Text('Failed to load profile', style: textTheme.bodyLarge),
              const SizedBox(height: Spacing.sm),
              TextButton(
                onPressed: () => ref.invalidate(currentUserProfileProvider),
                child: const Text('Retry'),
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
                  Text('Profile not found', style: textTheme.bodyLarge),
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
                    label: const Text('Retry'),
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
    final sections = <Widget>[];

    if (isOwn) {
      sections.addAll([
        const SizedBox(height: Spacing.md),
        _buildSection(
          'Appearance',
          [
            _SettingsTile(
              icon: Icons.palette_rounded,
              title: 'Theme',
              subtitle: 'Dark',
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => _showThemePicker(context),
            ),
            _SettingsTile(
              icon: Icons.language_rounded,
              title: 'Language',
              subtitle: 'English',
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => _showLanguagePicker(context),
            ),
          ],
          colorScheme,
          textTheme,
        ),
        _buildSection(
          'Account',
          [
            _SettingsTile(
              icon: Icons.person_rounded,
              title: 'Edit Profile',
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.pushNamed('editProfile'),
            ),
            _SettingsTile(
              icon: Icons.lock_rounded,
              title: 'Change Password',
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => _showChangePasswordDialog(context, ref),
            ),
            if (isModerator)
              _SettingsTile(
                icon: Icons.shield_rounded,
                title: 'Moderation',
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/moderation'),
              ),
            _SettingsTile(
              icon: Icons.delete_forever_rounded,
              title: 'Delete Account',
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
          'Recommendations & Privacy',
          [
            _SettingsTile(
              icon: Icons.auto_awesome_rounded,
              title: 'Personalized Recommendations',
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
              title: 'Clear Recommendation History',
              subtitle: 'Remove all behavioral data',
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear History'),
                    content: const Text('This will remove all your activity data used for recommendations. Continue?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                      FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Clear')),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await BehaviorService.instance.clearAllEvents();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Recommendation history cleared')),
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
        'About',
        [
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'Version',
            subtitle: '1.0.0',
            onTap: () => _showVersionDialog(context),
          ),
          _SettingsTile(
            icon: Icons.description_rounded,
            title: 'Terms of Service',
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _showTermsDialog(context),
          ),
          _SettingsTile(
            icon: Icons.shield_rounded,
            title: 'Privacy Policy',
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _showPrivacyDialog(context),
          ),
          _SettingsTile(
            icon: Icons.code_rounded,
            title: 'Open Source Licenses',
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'WatchAtlas',
              applicationVersion: '1.0.0',
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
                label: 'Display Name',
                value: profile.displayName ?? profile.username,
              ),
              Divider(height: 1, indent: 56, color: colorScheme.outline.withValues(alpha: 0.2)),
              _InfoRow(
                icon: Icons.alternate_email_rounded,
                label: 'Username',
                value: profile.username,
              ),
              Divider(height: 1, indent: 56, color: colorScheme.outline.withValues(alpha: 0.2)),
              _InfoRow(
                icon: Icons.email_rounded,
                label: 'Email',
                value: profile.email,
              ),
              if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                Divider(height: 1, indent: 56, color: colorScheme.outline.withValues(alpha: 0.2)),
                _InfoRow(
                  icon: Icons.info_outline_rounded,
                  label: 'Bio',
                  value: profile.bio!,
                ),
              ],
              if (profile.gender != null) ...[
                Divider(height: 1, indent: 56, color: colorScheme.outline.withValues(alpha: 0.2)),
                _InfoRow(
                  icon: Icons.wc_rounded,
                  label: 'Gender',
                  value: switch (profile.gender!) {
                    Gender.male => 'Male',
                    Gender.female => 'Female',
                    Gender.ratherNotSay => 'Rather not say',
                  },
                ),
              ],
              if (profile.dateOfBirth != null) ...[
                Divider(height: 1, indent: 56, color: colorScheme.outline.withValues(alpha: 0.2)),
                _InfoRow(
                  icon: Icons.cake_rounded,
                  label: 'Age',
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
                  label: const Text('Edit Profile'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                OutlinedButton.icon(
                  onPressed: () => context.push('/tracking'),
                  icon: const Icon(Icons.timeline_rounded),
                  label: const Text('View Tracking'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                OutlinedButton.icon(
                  onPressed: () => context.push('/analytics'),
                  icon: const Icon(Icons.analytics_rounded),
                  label: const Text('View Analytics'),
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
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
                child: Text('Choose Theme', style: Theme.of(context).textTheme.titleMedium),
              ),
              ListTile(
                leading: const Icon(Icons.settings_suggest_rounded),
                title: const Text('System'),
                subtitle: const Text('Follow system settings'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.light_mode_rounded),
                title: const Text('Light'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode_rounded),
                title: const Text('Dark'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
                child: Text('Choose Language', style: Theme.of(context).textTheme.titleMedium),
              ),
              ListTile(
                leading: const Icon(Icons.language_rounded),
                title: const Text('English'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.language_rounded),
                title: const Text('العربية'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context, WidgetRef ref, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: OutlinedButton.icon(
        onPressed: () => _showSignOutDialog(context, ref),
        icon: const Icon(Icons.logout_rounded),
        label: const Text('Sign Out'),
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.error,
          side: BorderSide(color: colorScheme.error.withValues(alpha: 0.5)),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) context.go('/auth');
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext parentContext, WidgetRef ref) {
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('This action is permanent and cannot be undone. All your data will be deleted.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(dialogContext).colorScheme.error),
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref.read(authServiceProvider).deleteAccount();
                if (parentContext.mounted) {
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    const SnackBar(content: Text('Account deleted successfully')),
                  );
                  ref.read(authNotifierProvider.notifier).signOut();
                }
              } catch (e) {
                if (parentContext.mounted) {
                  ScaffoldMessenger.of(parentContext).showSnackBar(SnackBar(content: Text('$e')));
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext parentContext, WidgetRef ref) {
    final emailController = TextEditingController();
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter your email address to receive a password reset link.'),
            const SizedBox(height: Spacing.lg),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_rounded),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isEmpty) return;
              Navigator.pop(dialogContext);
              try {
                await ref.read(authNotifierProvider.notifier).resetPassword(email);
                if (parentContext.mounted) {
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    const SnackBar(content: Text('Password reset link sent to your email')),
                  );
                }
              } catch (e) {
                if (parentContext.mounted) {
                  ScaffoldMessenger.of(parentContext).showSnackBar(SnackBar(content: Text('$e')));
                }
              }
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }

  void _showVersionDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'WatchAtlas',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2026 WatchAtlas',
      children: [
        const SizedBox(height: Spacing.lg),
        const Text('A modern media tracking platform to discover, track, and share your favorite movies, TV shows, and more.'),
      ],
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'By using WatchAtlas, you agree to these terms. Please read them carefully.\n\n'
            '1. You are responsible for your account and content.\n'
            '2. We reserve the right to modify or terminate the service.\n'
            '3. We do not claim ownership of your content.\n'
            '4. You may not use the service for any illegal purpose.\n\n'
            'Full terms will be available soon.',
          ),
        ),
        actions: [
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Your privacy matters to us.\n\n'
            '1. We collect minimal data needed to provide the service.\n'
            '2. Your data is stored securely.\n'
            '3. We do not sell your personal information.\n'
            '4. You can request data deletion at any time.\n\n'
            'Full privacy policy will be available soon.',
          ),
        ),
        actions: [
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
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