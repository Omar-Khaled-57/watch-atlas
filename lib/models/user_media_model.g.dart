// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserMediaModel _$UserMediaModelFromJson(Map<String, dynamic> json) =>
    _UserMediaModel(
      id: json['id'] as String,
      mediaId: (json['mediaId'] as num).toInt(),
      userId: json['userId'] as String,
      mediaType: $enumDecode(_$MediaTypeEnumMap, json['mediaType']),
      status: $enumDecode(_$WatchStatusEnumMap, json['status']),
      seasonProgress: (json['seasonProgress'] as num?)?.toInt() ?? 0,
      episodeProgress: (json['episodeProgress'] as num?)?.toInt() ?? 0,
      totalEpisodes: (json['totalEpisodes'] as num?)?.toInt() ?? 0,
      rewatchCount: (json['rewatchCount'] as num?)?.toInt() ?? 0,
      userRating: (json['userRating'] as num?)?.toDouble(),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserMediaModelToJson(_UserMediaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mediaId': instance.mediaId,
      'userId': instance.userId,
      'mediaType': _$MediaTypeEnumMap[instance.mediaType]!,
      'status': _$WatchStatusEnumMap[instance.status]!,
      'seasonProgress': instance.seasonProgress,
      'episodeProgress': instance.episodeProgress,
      'totalEpisodes': instance.totalEpisodes,
      'rewatchCount': instance.rewatchCount,
      'userRating': instance.userRating,
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
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
  WatchStatus.onHold: 'onHold',
  WatchStatus.dropped: 'dropped',
  WatchStatus.planToWatch: 'planToWatch',
  WatchStatus.rewatching: 'rewatching',
};
