class AppConstants {
  AppConstants._();

  static const String appName = 'WatchAtlas';
  static const String appVersion = '1.0.0';
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';
  static const String anilistGraphqlUrl = 'https://graphql.anilist.co';
  static const String supabaseUrlKey = 'SUPABASE_URL';
  static const String supabaseAnonKey = 'SUPABASE_ANON_KEY';
  static const String tmdbApiKey = 'TMDB_API_KEY';

  static const Duration searchDebounce = Duration(milliseconds: 400);
  static const Duration cacheDuration = Duration(hours: 24);
  static const Duration syncInterval = Duration(minutes: 15);
  static const int pageSize = 20;
  static const int maxRetries = 3;

  static String? mediaImageUrl(String? path, {String size = 'w342'}) {
    if (path == null) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    return '$tmdbImageBaseUrl/$size$path';
  }

  static const double homeCarouselHeight = 480;
  static const double posterWidth = 150;
  static const double posterHeight = 225;
  static const double backdropHeight = 240;
  static const double avatarRadius = 32;
  static const double minTouchTarget = 48;
}
