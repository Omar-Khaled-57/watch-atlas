import 'package:freezed_annotation/freezed_annotation.dart';
import '../core/models/media_enums.dart';

part 'user_media_model.freezed.dart';
part 'user_media_model.g.dart';

@freezed
abstract class UserMediaModel with _$UserMediaModel {
  const factory UserMediaModel({
    required String id,
    @JsonKey(name: 'media_id') required int mediaId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'media_type') required MediaType mediaType,
    required WatchStatus status,
    @JsonKey(name: 'season_progress') @Default(0) int seasonProgress,
    @JsonKey(name: 'episode_progress') @Default(0) int episodeProgress,
    @JsonKey(name: 'total_episodes') @Default(0) int totalEpisodes,
    @JsonKey(name: 'rewatch_count') @Default(0) int rewatchCount,
    @JsonKey(name: 'user_rating') double? userRating,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserMediaModel;

  factory UserMediaModel.fromJson(Map<String, dynamic> json) => _$UserMediaModelFromJson(json);
}
