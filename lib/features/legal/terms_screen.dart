import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
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
            Text('Terms of Service', style: theme.textTheme.headlineSmall),
            SizedBox(height: 8),
            Text(
              'Last updated: June 26, 2026',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24),
            _section(theme, '1. Acceptance of Terms',
                'By accessing or using Watch Atlas, you agree to be bound by these Terms of Service. '
                    'If you do not agree, do not use the service.'),
            _section(theme, '2. Description of Service',
                'Watch Atlas is a media tracking application that allows users to discover, track, '
                    'and organize movies, TV shows, and anime. Users can rate, review, and maintain '
                    'watch lists.'),
            _section(theme, '3. User Accounts',
                'You must sign in via Google OAuth to use the service. You are responsible for '
                    'maintaining the confidentiality of your account. You must be at least 13 years old '
                    'to use this service.'),
            _section(theme, '4. User Conduct',
                'You agree not to: post abusive, harassing, or inappropriate content; '
                    'impersonate others; attempt to circumvent security measures; '
                    'use the service for any illegal purpose.'),
            _section(theme, '5. Intellectual Property',
                'Media metadata and images are provided by TMDB and AniList under their respective licenses. '
                    'The Watch Atlas application and code are proprietary. '
                    'User-generated content (reviews, ratings) remains owned by you, '
                    'with a license granted to Watch Atlas to display it within the service.'),
            _section(theme, '6. Limitation of Liability',
                'Watch Atlas is provided "as is" without warranties of any kind. '
                    'We are not responsible for the accuracy of third-party metadata. '
                    'We reserve the right to modify or discontinue the service at any time.'),
            _section(theme, '7. Termination',
                'We reserve the right to suspend or terminate accounts that violate these terms. '
                    'You may delete your account at any time.'),
            _section(theme, '8. Changes to Terms',
                'We may update these terms at any time. Continued use after changes constitutes acceptance. '
                    'Users will be notified of material changes via email or in-app notification.'),
            _section(theme, '9. Contact',
                'For questions about these terms, contact: legal@watchatlas.app'),
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
