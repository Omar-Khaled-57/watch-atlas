import 'package:freezed_annotation/freezed_annotation.dart';
import '../core/models/media_enums.dart';

part 'user_list_model.freezed.dart';
part 'user_list_model.g.dart';

@freezed
class UserListModel with _$UserListModel {
  const factory UserListModel({
    required String id,
    required String userId,
    required String title,
    String? description,
    @Default(MediaListType.public) MediaListType listType,
    @Default(false) bool isPinned,
    @Default([]) List<String> tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int itemCount,
    @Default(0) int likesCount,
  }) = _UserListModel;

  factory UserListModel.fromJson(Map<String, dynamic> json) => _$UserListModelFromJson(json);
}
