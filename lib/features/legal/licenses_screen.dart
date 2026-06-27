import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/l10n.dart';

class LicensesScreen extends StatelessWidget {
  const LicensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.licenses),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.licenses, style: theme.textTheme.headlineSmall),
            SizedBox(height: 8),
            Text(
              l10n.lastUpdated,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24),
            _section(context, theme, l10n.openSourceNotice, l10n.openSourceNoticeBody),
            _section(context, theme, l10n.thirdPartyLibraries, l10n.thirdPartyLibrariesBody),
            _section(context, theme, l10n.mediaOwnership, l10n.mediaOwnershipBody),
            _section(context, theme, l10n.aiGeneratedLogo, l10n.aiGeneratedLogoBody),
            _section(context, theme, l10n.trademarks, l10n.trademarksBody),
          ],
        ),
      ),
    );
  }

  Widget _section(BuildContext context, ThemeData theme, String title, String body) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Text(body, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}
