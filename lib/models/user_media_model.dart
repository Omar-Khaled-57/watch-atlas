import 'package:freezed_annotation/freezed_annotation.dart';
import '../core/models/media_enums.dart';

part 'user_media_model.freezed.dart';
part 'user_media_model.g.dart';

@freezed
abstract class UserMediaModel with _$UserMediaModel {
  const factory UserMediaModel({
    required String id,
    required int mediaId,
    required String userId,
    required MediaType mediaType,
    required WatchStatus status,
    @Default(0) int seasonProgress,
    @Default(0) int episodeProgress,
    @Default(0) int totalEpisodes,
    @Default(0) int rewatchCount,
    double? userRating,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserMediaModel;

  factory UserMediaModel.fromJson(Map<String, dynamic> json) => _$UserMediaModelFromJson(json);
}
