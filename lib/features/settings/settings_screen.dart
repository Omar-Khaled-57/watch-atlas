import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/providers/app_providers.dart';
import '../auth/providers/auth_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
        children: [
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
          if (isAuthenticated) ...[
            _buildSection(
              'Notifications',
              [
                _SettingsTile(
                  icon: Icons.notifications_rounded,
                  title: 'Push Notifications',
                  trailing: Switch(value: true, onChanged: (_) {}),
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.new_releases_rounded,
                  title: 'New Episodes',
                  trailing: Switch(value: true, onChanged: (_) {}),
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.rate_review_rounded,
                  title: 'Reviews & Comments',
                  trailing: Switch(value: true, onChanged: (_) {}),
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.people_rounded,
                  title: 'Follow Activity',
                  trailing: Switch(value: true, onChanged: (_) {}),
                  onTap: () {},
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
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.delete_forever_rounded,
                  title: 'Delete Account',
                  titleColor: colorScheme.error,
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.error,
                  ),
                  onTap: () => _showDeleteAccountDialog(context),
                ),
              ],
              colorScheme,
              textTheme,
            ),
          ],
          _buildSection(
            'About',
            [
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'Version',
                subtitle: '1.0.0',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.description_rounded,
                title: 'Terms of Service',
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.shield_rounded,
                title: 'Privacy Policy',
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {},
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
          if (isAuthenticated)
            Padding(
              padding: const EdgeInsetsDirectional.all(16),
              child: OutlinedButton.icon(
                onPressed: () => _showSignOutDialog(context, ref),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Sign Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.error,
                  side: BorderSide(color: colorScheme.error.withValues(alpha: 0.5)),
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
                ),
              ),
            ),
          const SizedBox(height: 32),
        ],
      ),
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
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
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
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'Choose Theme',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
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
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'Choose Language',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
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

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authNotifierProvider.notifier).signOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action is permanent and cannot be undone. '
          'All your data will be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
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
