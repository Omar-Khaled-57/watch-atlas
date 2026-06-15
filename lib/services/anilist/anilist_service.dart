import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';

class AnilistService {
  final Dio _dio;

  AnilistService()
      : _dio = Dio(BaseOptions(
          baseUrl: ApiConstants.anilistBaseUrl,
          contentType: 'application/json',
        ));

  Future<Response> query(String graphqlQuery,
      {Map<String, dynamic>? variables}) async {
    return _dio.post('', data: {
      'query': graphqlQuery,
      'variables': variables ?? {},
    });
  }
}
