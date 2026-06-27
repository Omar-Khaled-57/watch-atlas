import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/l10n.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.termsOfService),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.termsOfService, style: theme.textTheme.headlineSmall),
            SizedBox(height: 8),
            Text(
              l10n.lastUpdated,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24),
            _section(context, theme, l10n.acceptanceOfTerms, l10n.acceptanceOfTermsBody),
            _section(context, theme, l10n.descriptionOfService, l10n.descriptionOfServiceBody),
            _section(context, theme, l10n.userAccounts, l10n.userAccountsBody),
            _section(context, theme, l10n.userResponsibilities, l10n.userResponsibilitiesBody),
            _section(context, theme, l10n.acceptableUse, l10n.acceptableUseBody),
            _section(context, theme, l10n.userGeneratedContent, l10n.userGeneratedContentBody),
            _section(context, theme, l10n.intellectualProperty, l10n.intellectualPropertyBody),
            _section(context, theme, l10n.thirdPartyServicesTerms, l10n.thirdPartyServicesTermsBody),
            _section(context, theme, l10n.externalLinks, l10n.externalLinksBody),
            _section(context, theme, l10n.availabilityOfService, l10n.availabilityOfServiceBody),
            _section(context, theme, l10n.changesToFeatures, l10n.changesToFeaturesBody),
            _section(context, theme, l10n.accountSuspension, l10n.accountSuspensionBody),
            _section(context, theme, l10n.disclaimers, l10n.disclaimersBody),
            _section(context, theme, l10n.privacyReference, l10n.privacyReferenceBody),
            _section(context, theme, l10n.changesToTerms, l10n.changesToTermsBody),
            _section(context, theme, l10n.contactSection, l10n.contactLegal),
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
