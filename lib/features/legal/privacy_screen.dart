import 'package:flutter/material.dart';
import '../../l10n/l10n.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyPolicy)),
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.privacyPolicy, style: theme.textTheme.headlineSmall),
            SizedBox(height: 8),
            Text(
              l10n.lastUpdated,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24),
            _section(
              context,
              theme,
              l10n.informationWeCollect,
              l10n.informationWeCollectBody,
            ),
            _section(
              context,
              theme,
              l10n.automaticallyCollectedData,
              l10n.automaticallyCollectedDataBody,
            ),
            _section(context, theme, l10n.howWeUseInfo, l10n.howWeUseInfoBody),
            _section(context, theme, l10n.dataStorage, l10n.dataStorageBody),
            _section(
              context,
              theme,
              l10n.thirdPartyServicesPrivacy,
              l10n.thirdPartyServicesPrivacyBody,
            ),
            _section(
              context,
              theme,
              l10n.cookiesLocalStorage,
              l10n.cookiesLocalStorageBody,
            ),
            _section(
              context,
              theme,
              l10n.dataRetention,
              l10n.dataRetentionBody,
            ),
            _section(context, theme, l10n.yourRights, l10n.yourRightsBody),
            _section(
              context,
              theme,
              l10n.childrensPrivacy,
              l10n.childrensPrivacyBody,
            ),
            _section(
              context,
              theme,
              l10n.policyUpdates,
              l10n.policyUpdatesBody,
            ),
            _section(context, theme, l10n.contactSection, l10n.contactPrivacy),
          ],
        ),
      ),
    );
  }

  Widget _section(
    BuildContext context,
    ThemeData theme,
    String title,
    String body,
  ) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(body, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}
