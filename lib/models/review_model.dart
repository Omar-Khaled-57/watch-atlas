import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    required String id,
    required int mediaId,
    required String userId,
    required String content,
    double? rating,
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    @Default(false) bool containsSpoilers,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);
}
