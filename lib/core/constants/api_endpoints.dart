class ApiEndpoints {
  ApiEndpoints._();

  static const String trendingMovies = '/trending/movie/week';
  static const String trendingTv = '/trending/tv/week';
  static const String popularMovies = '/movie/popular';
  static const String popularTv = '/tv/popular';
  static const String nowPlaying = '/movie/now_playing';
  static const String topRated = '/movie/top_rated';
  static const String upcoming = '/movie/upcoming';
  static const String airingToday = '/tv/airing_today';
  static const String onTheAir = '/tv/on_the_air';
  static const String movieDetails = '/movie/{id}';
  static const String tvDetails = '/tv/{id}';
  static const String movieCredits = '/movie/{id}/credits';
  static const String tvCredits = '/tv/{id}/credits';
  static const String movieRecommendations = '/movie/{id}/recommendations';
  static const String tvRecommendations = '/tv/{id}/recommendations';
  static const String similarMovies = '/movie/{id}/similar';
  static const String similarTv = '/tv/{id}/similar';
  static const String searchMulti = '/search/multi';
  static const String searchMovie = '/search/movie';
  static const String searchTv = '/search/tv';
  static const String searchPerson = '/search/person';
  static const String discoverMovie = '/discover/movie';
  static const String discoverTv = '/discover/tv';
  static const String movieVideos = '/movie/{id}/videos';
  static const String tvVideos = '/tv/{id}/videos';
  static const String personDetails = '/person/{id}';
  static const String genres = '/genre/movie/list';
  static const String tvGenres = '/genre/tv/list';
  static const String collections = '/collection/{id}';
}
