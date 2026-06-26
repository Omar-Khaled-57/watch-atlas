import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/app_constants.dart';
import '../constants/api_endpoints.dart';

class TmdbService {
  static final TmdbService instance = TmdbService._();
  TmdbService._();

  late final Dio _dio;

  void init() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.tmdbBaseUrl,
      queryParameters: {
        'api_key': dotenv.env[AppConstants.tmdbApiKey] ?? '',
        'language': 'en-US',
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    _dio.interceptors.add(LogInterceptor(requestBody: false, responseBody: false));
  }

  String imageUrl(String? path, {String size = 'w500'}) {
    if (path == null) return '';
    return '${AppConstants.tmdbImageBaseUrl}/$size$path';
  }

  String backdropUrl(String? path) => imageUrl(path, size: 'w1280');
  String posterUrl(String? path) => imageUrl(path, size: 'w500');
  String profileUrl(String? path) => imageUrl(path, size: 'w185');

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, dynamic>? params}) async {
    final response = await _dio.get(endpoint, queryParameters: params);
    return response.data;
  }

  Future<List<dynamic>> getList(String endpoint, {Map<String, dynamic>? params}) async {
    final data = await get(endpoint, params: params);
    return data['results'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> trendingMovies() async =>
      get(ApiEndpoints.trendingMovies);

  Future<Map<String, dynamic>> trendingTv() async =>
      get(ApiEndpoints.trendingTv);

  Future<Map<String, dynamic>> popularMovies({int page = 1}) async =>
      get(ApiEndpoints.popularMovies, params: {'page': page});

  Future<Map<String, dynamic>> popularTv({int page = 1}) async =>
      get(ApiEndpoints.popularTv, params: {'page': page});

  Future<Map<String, dynamic>> nowPlaying({int page = 1}) async =>
      get(ApiEndpoints.nowPlaying, params: {'page': page});

  Future<Map<String, dynamic>> upcoming({int page = 1}) async =>
      get(ApiEndpoints.upcoming, params: {'page': page});

  Future<Map<String, dynamic>> movieDetails(int id) async =>
      get(ApiEndpoints.movieDetails.replaceFirst('{id}', id.toString()),
          params: {'append_to_response': 'credits,videos,recommendations,similar'});

  Future<Map<String, dynamic>> tvDetails(int id) async =>
      get(ApiEndpoints.tvDetails.replaceFirst('{id}', id.toString()),
          params: {'append_to_response': 'credits,videos,recommendations,similar'});

  Future<List<dynamic>> search(String query, {int page = 1}) async {
    final data = await get(ApiEndpoints.searchMulti, params: {'query': query, 'page': page});
    return data['results'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> discoverMovie({Map<String, dynamic>? filters}) async =>
      get(ApiEndpoints.discoverMovie, params: filters);

  Future<Map<String, dynamic>> discoverTv({Map<String, dynamic>? filters}) async =>
      get(ApiEndpoints.discoverTv, params: filters);

  Future<Map<String, dynamic>> searchMovie(String query, {int page = 1}) async =>
      get(ApiEndpoints.searchMovie, params: {'query': query, 'page': page});

  Future<Map<String, dynamic>> searchTv(String query, {int page = 1}) async =>
      get(ApiEndpoints.searchTv, params: {'query': query, 'page': page});

  Future<Map<String, dynamic>> personDetails(int id) async =>
      get(ApiEndpoints.personDetails.replaceFirst('{id}', id.toString()),
          params: {'append_to_response': 'movie_credits,tv_credits'});

  Future<List<dynamic>> genres() async {
    final data = await get(ApiEndpoints.genres);
    return data['genres'] as List<dynamic>;
  }

  Future<List<dynamic>> tvGenres() async {
    final data = await get(ApiEndpoints.tvGenres);
    return data['genres'] as List<dynamic>;
  }

  Future<List<dynamic>> movieVideos(int id) async {
    final data = await get(ApiEndpoints.movieVideos.replaceFirst('{id}', id.toString()));
    return data['results'] as List<dynamic>;
  }

  Future<List<dynamic>> tvVideos(int id) async {
    final data = await get(ApiEndpoints.tvVideos.replaceFirst('{id}', id.toString()));
    return data['results'] as List<dynamic>;
  }
}
