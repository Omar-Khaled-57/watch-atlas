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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
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
            _section(theme, l10n.acceptanceOfTerms, l10n.acceptanceOfTermsBody),
            _section(theme, l10n.descriptionOfService, l10n.descriptionOfServiceBody),
            _section(theme, l10n.userAccounts, l10n.userAccountsBody),
            _section(theme, l10n.userConduct, l10n.userConductBody),
            _section(theme, l10n.intellectualProperty, l10n.intellectualPropertyBody),
            _section(theme, l10n.limitationOfLiability, l10n.limitationOfLiabilityBody),
            _section(theme, l10n.termination, l10n.terminationBody),
            _section(theme, l10n.changesToTerms, l10n.changesToTermsBody),
            _section(theme, l10n.contactSection, l10n.contactLegal),
          ],
        ),
      ),
    );
  }

  Widget _section(ThemeData theme, String title, String body) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
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
