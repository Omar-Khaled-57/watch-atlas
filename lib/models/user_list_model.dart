import 'package:freezed_annotation/freezed_annotation.dart';
import '../core/models/media_enums.dart';

part 'user_list_model.freezed.dart';
part 'user_list_model.g.dart';

@freezed
abstract class UserListModel with _$UserListModel {
  const factory UserListModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    String? description,
    @JsonKey(name: 'list_type') @Default(MediaListType.public) MediaListType listType,
    @JsonKey(name: 'is_pinned') @Default(false) bool isPinned,
    @Default([]) List<String> tags,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'item_count') @Default(0) int itemCount,
    @JsonKey(name: 'likes_count') @Default(0) int likesCount,
  }) = _UserListModel;

  factory UserListModel.fromJson(Map<String, dynamic> json) => _$UserListModelFromJson(json);
}
