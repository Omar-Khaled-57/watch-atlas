// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserMediaModel _$UserMediaModelFromJson(Map<String, dynamic> json) =>
    _UserMediaModel(
      id: json['id'] as String,
      mediaId: (json['media_id'] as num).toInt(),
      userId: json['user_id'] as String,
      mediaType: $enumDecode(_$MediaTypeEnumMap, json['media_type']),
      status: $enumDecode(_$WatchStatusEnumMap, json['status']),
      seasonProgress: (json['season_progress'] as num?)?.toInt() ?? 0,
      episodeProgress: (json['episode_progress'] as num?)?.toInt() ?? 0,
      totalEpisodes: (json['total_episodes'] as num?)?.toInt() ?? 0,
      rewatchCount: (json['rewatch_count'] as num?)?.toInt() ?? 0,
      userRating: (json['user_rating'] as num?)?.toDouble(),
      startedAt: json['started_at'] == null
          ? null
          : DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserMediaModelToJson(_UserMediaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_id': instance.mediaId,
      'user_id': instance.userId,
      'media_type': _$MediaTypeEnumMap[instance.mediaType]!,
      'status': _$WatchStatusEnumMap[instance.status]!,
      'season_progress': instance.seasonProgress,
      'episode_progress': instance.episodeProgress,
      'total_episodes': instance.totalEpisodes,
      'rewatch_count': instance.rewatchCount,
      'user_rating': instance.userRating,
      'started_at': instance.startedAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$MediaTypeEnumMap = {
  MediaType.movie: 'movie',
  MediaType.tv: 'tv',
  MediaType.anime: 'anime',
  MediaType.kdrama: 'kdrama',
  MediaType.cdrama: 'cdrama',
  MediaType.jdrama: 'jdrama',
  MediaType.thaiDrama: 'thaiDrama',
  MediaType.asianDrama: 'asianDrama',
  MediaType.egyptianMovie: 'egyptianMovie',
  MediaType.egyptianSeries: 'egyptianSeries',
  MediaType.arabicMovie: 'arabicMovie',
  MediaType.arabicSeries: 'arabicSeries',
  MediaType.documentary: 'documentary',
  MediaType.webSeries: 'webSeries',
  MediaType.custom: 'custom',
};

const _$WatchStatusEnumMap = {
  WatchStatus.watching: 'watching',
  WatchStatus.completed: 'completed',
  WatchStatus.onHold: 'on_hold',
  WatchStatus.dropped: 'dropped',
  WatchStatus.planToWatch: 'plan_to_watch',
  WatchStatus.rewatching: 'rewatching',
};
