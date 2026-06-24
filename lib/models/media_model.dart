import 'package:isar/isar.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../core/models/media_enums.dart';

part 'media_model.freezed.dart';
part 'media_model.g.dart';

@freezed
class MediaModel with _$MediaModel {
  const factory MediaModel({
    required int id,
    required MediaType mediaType,
    required String title,
    String? originalTitle,
    String? nativeTitle,
    String? romanizedTitle,
    String? overview,
    String? posterPath,
    String? backdropPath,
    String? trailerUrl,
    double? voteAverage,
    int? voteCount,
    @Default(0) double popularity,
    DateTime? releaseDate,
    int? runtime,
    List<String>? genres,
    List<String>? countries,
    String? status,
    String? language,
    bool? adult,
    @Default(false) bool isCustom,
    @Default(0) int totalEpisodes,
    @Default(0) int totalSeasons,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MediaModel;

  factory MediaModel.fromJson(Map<String, dynamic> json) => _$MediaModelFromJson(json);
}
