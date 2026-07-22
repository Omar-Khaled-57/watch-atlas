/// Compile-time secrets injected via `--dart-define`.
///
/// Usage:
///   flutter run --dart-define=SUPABASE_URL=https://... \
///              --dart-define=SUPABASE_ANON_KEY=...       \
///              --dart-define=TMDB_API_KEY=...            \
///              --dart-define=ANILIST_CLIENT_ID=...       \
///              --dart-define=ANILIST_CLIENT_SECRET=...
///
/// For CI/CD, pass a JSON file:
///   flutter build apk --dart-define-from-file=secrets.json
///
/// NEVER commit real values. Ship an `secrets.json.example` instead.
class Secrets {
  Secrets._();

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  static const String tmdbApiKey = String.fromEnvironment(
    'TMDB_API_KEY',
    defaultValue: '',
  );

  static const String tmdbAccessToken = String.fromEnvironment(
    'TMDB_ACCESS_TOKEN',
    defaultValue: '',
  );

  static const String anilistClientId = String.fromEnvironment(
    'ANILIST_CLIENT_ID',
    defaultValue: '',
  );

  static const String anilistClientSecret = String.fromEnvironment(
    'ANILIST_CLIENT_SECRET',
    defaultValue: '',
  );

  /// Whether all required secrets are present.
  static bool get isConfigured =>
      supabaseUrl.isNotEmpty &&
      supabaseAnonKey.isNotEmpty &&
      tmdbApiKey.isNotEmpty;
}
