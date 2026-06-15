import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/constants/api_constants.dart';

class TmdbService {
  final Dio _dio;

  TmdbService()
      : _dio = Dio(BaseOptions(
          baseUrl: ApiConstants.tmdbBaseUrl,
          headers: {
            'Authorization': 'Bearer ${dotenv.env['TMDB_ACCESS_TOKEN']}',
            'Content-Type': 'application/json',
          },
        ));

  Future<Response> getPopular({int page = 1}) async {
    return _dio.get('/movie/popular', queryParameters: {'page': page});
  }

  Future<Response> getTrending({int page = 1}) async {
    return _dio.get('/trending/all/week', queryParameters: {'page': page});
  }

  Future<Response> search(String query, {int page = 1}) async {
    return _dio.get('/search/multi', queryParameters: {
      'query': query,
      'page': page,
    });
  }
}
