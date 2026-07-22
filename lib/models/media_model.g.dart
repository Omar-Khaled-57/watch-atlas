// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaModel _$MediaModelFromJson(Map<String, dynamic> json) => _MediaModel(
  id: (json['id'] as num).toInt(),
  mediaType: $enumDecode(_$MediaTypeEnumMap, json['mediaType']),
  title: json['title'] as String,
  originalTitle: json['originalTitle'] as String?,
  nativeTitle: json['nativeTitle'] as String?,
  romanizedTitle: json['romanizedTitle'] as String?,
  overview: json['overview'] as String?,
  posterPath: json['posterPath'] as String?,
  backdropPath: json['backdropPath'] as String?,
  trailerUrl: json['trailerUrl'] as String?,
  voteAverage: (json['voteAverage'] as num?)?.toDouble(),
  voteCount: (json['voteCount'] as num?)?.toInt(),
  popularity: (json['popularity'] as num?)?.toDouble() ?? 0,
  releaseDate: json['releaseDate'] == null
      ? null
      : DateTime.parse(json['releaseDate'] as String),
  runtime: (json['runtime'] as num?)?.toInt(),
  genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
  countries: (json['countries'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  status: json['status'] as String?,
  language: json['language'] as String?,
  adult: json['adult'] as bool?,
  isCustom: json['isCustom'] as bool? ?? false,
  totalEpisodes: (json['totalEpisodes'] as num?)?.toInt() ?? 0,
  totalSeasons: (json['totalSeasons'] as num?)?.toInt() ?? 0,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$MediaModelToJson(_MediaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mediaType': _$MediaTypeEnumMap[instance.mediaType]!,
      'title': instance.title,
      'originalTitle': instance.originalTitle,
      'nativeTitle': instance.nativeTitle,
      'romanizedTitle': instance.romanizedTitle,
      'overview': instance.overview,
      'posterPath': instance.posterPath,
      'backdropPath': instance.backdropPath,
      'trailerUrl': instance.trailerUrl,
      'voteAverage': instance.voteAverage,
      'voteCount': instance.voteCount,
      'popularity': instance.popularity,
      'releaseDate': instance.releaseDate?.toIso8601String(),
      'runtime': instance.runtime,
      'genres': instance.genres,
      'countries': instance.countries,
      'status': instance.status,
      'language': instance.language,
      'adult': instance.adult,
      'isCustom': instance.isCustom,
      'totalEpisodes': instance.totalEpisodes,
      'totalSeasons': instance.totalSeasons,
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
