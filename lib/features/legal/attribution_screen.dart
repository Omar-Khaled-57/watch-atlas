import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/l10n.dart';

class AttributionScreen extends StatelessWidget {
  const AttributionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.contentAndAttribution),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.contentAndAttribution, style: theme.textTheme.headlineSmall),
            SizedBox(height: 8),
            Text(
              l10n.lastUpdated,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24),
            _section(context, theme, l10n.metadataAttribution, l10n.metadataAttributionBody),
            _section(context, theme, l10n.imagesAttribution, l10n.imagesAttributionBody),
            _section(context, theme, l10n.recommendationSystemInfo, l10n.recommendationSystemInfoBody),
            _section(context, theme, l10n.userContentOwnership, l10n.userContentOwnershipBody),
            _section(context, theme, l10n.accuracyDisclaimer, l10n.accuracyDisclaimerBody),
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
