import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/providers/app_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/user_model.dart';
import '../../auth/providers/auth_providers.dart';
import '../../social/providers/social_providers.dart';

/// Shows a report dialog for the given [user].
Future<void> showReportDialog(
  BuildContext context,
  WidgetRef ref,
  UserModel user,
) async {
  final l10n = AppLocalizations.of(context)!;
  final reasonController = TextEditingController();
  String selectedReason = 'spam';

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text(l10n.reportUser),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.report} @${user.username}'),
            const SizedBox(height: Spacing.lg),
            DropdownButtonFormField<String>(
              initialValue: selectedReason,
              decoration: InputDecoration(labelText: l10n.reason),
              items: [
                DropdownMenuItem(value: 'spam', child: Text(l10n.spam)),
                DropdownMenuItem(
                  value: 'inappropriate',
                  child: Text(l10n.inappropriate),
                ),
                DropdownMenuItem(
                  value: 'harassment',
                  child: Text(l10n.harassment),
                ),
                DropdownMenuItem(value: 'other', child: Text(l10n.other)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => selectedReason = value);
              },
            ),
            const SizedBox(height: Spacing.md),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: l10n.additionalDetails,
                hintText: l10n.optional,
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              await ref.read(
                reportUserProvider((
                  userId: user.id,
                  reason: selectedReason,
                  description: reasonController.text.trim(),
                )).future,
              );
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.reportSubmitted)));
              }
            },
            child: Text(l10n.submit),
          ),
        ],
      ),
    ),
  );
  reasonController.dispose();
}

/// Shows a block confirmation dialog for the given [user].
void showBlockDialog(BuildContext context, WidgetRef ref, UserModel user) {
  final l10n = AppLocalizations.of(context)!;
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.blockUser),
      content: Text(l10n.confirmBlockUser),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () async {
            await ref.read(blockUserProvider(user.id).future);
            if (ctx.mounted) Navigator.pop(ctx);
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.userBlocked)));
            }
          },
          child: Text(l10n.block),
        ),
      ],
    ),
  );
}

/// Shows a theme mode picker bottom sheet.
void showThemePicker(BuildContext context, WidgetRef ref) {
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
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Text(
                l10n.chooseTheme,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings_suggest_rounded),
              title: Text(l10n.systemMode),
              subtitle: Text(l10n.followSystem),
              trailing: current == ThemeMode.system
                  ? Icon(Icons.check, color: Theme.of(ctx).colorScheme.primary)
                  : null,
              onTap: () {
                ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(ThemeMode.system);
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
                ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(ThemeMode.light);
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
                ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(ThemeMode.dark);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    ),
  );
}

/// Shows a language picker bottom sheet.
void showLanguagePicker(BuildContext context, WidgetRef ref) {
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
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Text(
                l10n.chooseLanguage,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
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

/// Shows a sign-out confirmation dialog.
void showSignOutDialog(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.logout),
      content: Text(l10n.signOutConfirmation),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(l10n.cancel),
        ),
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

/// Shows a delete-account confirmation dialog.
void showDeleteAccountDialog(BuildContext parentContext, WidgetRef ref) {
  final l10n = AppLocalizations.of(parentContext)!;
  showDialog(
    context: parentContext,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.deleteAccount),
      content: Text(l10n.deleteAccountWarning),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(dialogContext).colorScheme.error,
          ),
          onPressed: () async {
            Navigator.pop(dialogContext);
            try {
              await ref.read(authServiceProvider).deleteAccount();
            } catch (e) {
              if (parentContext.mounted) {
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  SnackBar(content: Text(l10n.errorWithDetails(e.toString()))),
                );
              }
              return;
            }
            if (!parentContext.mounted) return;
            ScaffoldMessenger.of(
              parentContext,
            ).showSnackBar(SnackBar(content: Text(l10n.deleteAccount)));
            ref.read(authNotifierProvider.notifier).forceUnauthenticated();
          },
          child: Text(l10n.delete),
        ),
      ],
    ),
  );
}

/// Shows a change-password dialog that sends a reset link via email.
Future<void> showChangePasswordDialog(
  BuildContext parentContext,
  WidgetRef ref,
) async {
  final l10n = AppLocalizations.of(parentContext)!;
  final emailController = TextEditingController();
  await showDialog(
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
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () async {
            final email = emailController.text.trim();
            if (email.isEmpty) return;
            Navigator.pop(dialogContext);
            try {
              await ref
                  .read(authNotifierProvider.notifier)
                  .resetPassword(email);
              if (parentContext.mounted) {
                ScaffoldMessenger.of(
                  parentContext,
                ).showSnackBar(SnackBar(content: Text(l10n.sendResetLink)));
              }
            } catch (e) {
              if (parentContext.mounted) {
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  SnackBar(content: Text(l10n.errorWithDetails(e.toString()))),
                );
              }
            }
          },
          child: Text(l10n.sendResetLink),
        ),
      ],
    ),
  );
  emailController.dispose();
}

/// Shows the app version / about dialog.
void showVersionDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showAboutDialog(
    context: context,
    applicationName: l10n.appName,
    applicationVersion: AppConstants.appVersion,
    applicationLegalese: '© 2026 ${l10n.appName}',
    children: [
      const SizedBox(height: Spacing.lg),
      Text(l10n.aboutAppDescription),
    ],
  );
}

/// Navigates to the terms screen.
void showTerms(BuildContext context) => context.pushNamed('terms');

/// Navigates to the privacy screen.
void showPrivacy(BuildContext context) => context.pushNamed('privacy');

/// Navigates to the licenses screen.
void showLicenses(BuildContext context) => context.pushNamed('licenses');

/// Navigates to the attribution screen.
void showAttribution(BuildContext context) => context.pushNamed('attribution');
