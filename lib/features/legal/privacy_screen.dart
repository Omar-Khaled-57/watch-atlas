import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
            Text('Privacy Policy', style: theme.textTheme.headlineSmall),
            SizedBox(height: 8),
            Text(
              'Last updated: June 26, 2026',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24),
            _section(theme, '1. Information We Collect',
                'When you sign in with Google OAuth, we collect your email address and display name. '
                    'We also store media you track (movies, TV shows, anime) along with your watch status, '
                    'ratings, and reviews. Profile avatars and display names are stored via Supabase storage.'),
            _section(theme, '2. How We Use Your Information',
                'Your information is used to provide and improve the service: personalize your experience, '
                    'maintain your watch lists and reviews, generate analytics based on your tracked media, '
                    'and communicate service updates if necessary.'),
            _section(theme, '3. Data Storage & Security',
                'Your data is stored securely on Supabase (PostgreSQL) and Google Cloud infrastructure. '
                    'We use Row Level Security to ensure you can only access your own data. '
                    'Passwords are never stored — authentication is handled entirely by Google OAuth.'),
            _section(theme, '4. Third-Party Services',
                'We use TMDB (The Movie Database) to fetch media metadata. '
                    'Your searches and viewed media IDs are sent to TMDB\'s API. '
                    'We also use AniList for anime metadata. '
                    'Google OAuth is used for authentication.'),
            _section(theme, '5. Data Retention',
                'Your data is retained for as long as your account is active. '
                    'You may delete your account and associated data at any time by contacting us.'),
            _section(theme, '6. Your Rights',
                'You may request a copy of your data, correction of inaccurate data, '
                    'or deletion of your account and associated data. Contact us at the email below.'),
            _section(theme, '7. Contact',
                'For privacy-related inquiries, contact: privacy@watchatlas.app'),
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
