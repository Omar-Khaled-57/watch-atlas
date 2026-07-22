import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class AnilistService {
  static final AnilistService instance = AnilistService._();
  AnilistService._();

  late final Dio _dio;

  void init() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.anilistGraphqlUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
  }

  Future<Map<String, dynamic>> query(String query, {Map<String, dynamic>? variables}) async {
    final response = await _dio.post('', data: {
      'query': query,
      'variables': variables ?? {},
    });
    return response.data;
  }

  Future<List<dynamic>> searchAnime(String search, {int page = 1, int perPage = 20}) async {
    const gql = '''
      query (\$search: String, \$page: Int, \$perPage: Int) {
        Page(page: \$page, perPage: \$perPage) {
          media(search: \$search, type: ANIME) {
            id
            title { romaji english native }
            description
            coverImage { large extraLarge }
            bannerImage
            genres
            episodes
            duration
            status
            season
            seasonYear
            averageScore
            popularity
            studios { nodes { name } }
            startDate { year month day }
            endDate { year month day }
            recommendations { nodes { mediaRecommendation { id title { romaji } } } }
          }
        }
      }
    ''';
    final data = await query(gql, variables: {'search': search, 'page': page, 'perPage': perPage});
    return data['data']['Page']['media'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> animeDetails(int id) async {
    const gql = '''
      query (\$id: Int) {
        Media(id: \$id, type: ANIME) {
          id
          title { romaji english native }
          description
          coverImage { large extraLarge }
          bannerImage
          genres
          tags { name }
          episodes
          duration
          status
          season
          seasonYear
          averageScore
          popularity
          meanScore
          source
          studios { nodes { name } }
          staff { edges { node { name { full } } role } }
          startDate { year month day }
          endDate { year month day }
          nextAiringEpisode { episode airingAt }
          recommendations { nodes { mediaRecommendation { id title { romaji } } } }
          relations { nodes { id title { romaji } relationType } }
        }
      }
    ''';
    final data = await query(gql, variables: {'id': id});
    return data['data']['Media'] as Map<String, dynamic>;
  }
}
