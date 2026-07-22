import 'package:flutter/material.dart';

import '../../../core/constants/dimensions.dart';
import '../../../l10n/l10n.dart';

Future<String?> showGoogleAccountPicker({
  required BuildContext context,
  required List<String> accounts,
}) {
  return showDialog<String>(
    context: context,
    builder: (ctx) => _GoogleAccountPicker(accounts: accounts),
  );
}

class _GoogleAccountPicker extends StatelessWidget {
  final List<String> accounts;

  const _GoogleAccountPicker({required this.accounts});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(16),
      ),
      title: Row(
        children: [
          Image(
            image: const AssetImage('assets/images/icons/google.png'),
            width: 24, height: 24,
          ),
          const SizedBox(width: Spacing.md),
          Text(l10n.chooseAccount,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AccountTile(
            icon: Icons.logo_dev,
            label: l10n.continueWithGoogle,
            subtitle: l10n.signInToGoogle,
            onTap: () => Navigator.pop(context, '__continue__'),
          ),
          if (accounts.isNotEmpty) ...[
            const Divider(height: 4),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 8, top: 8, bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.history, size: 16, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(l10n.previouslyUsed,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            for (final email in accounts) ...[
              _AccountTile(
                email: email,
                label: l10n.signInTo,
                subtitle: email,
                onTap: () => Navigator.pop(context, email),
              ),
            ],
          ],
          const Divider(height: 4),
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 4),
            child: _AccountTile(
              icon: Icons.person_add_outlined,
              label: l10n.tryAnotherAccount,
              subtitle: l10n.useDifferentGoogleAccount,
              onTap: () => Navigator.pop(context, '__other__'),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel, style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
        ),
      ],
    );
  }
}

class _AccountTile extends StatelessWidget {
  final IconData? icon;
  final String? email;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _AccountTile({
    this.icon,
    this.email,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 4, vertical: 10,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade200,
              child: icon != null
                  ? Icon(icon, size: 20, color: isDark ? Colors.white70 : Colors.black54)
                  : Text(
                      (email![0]).toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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
