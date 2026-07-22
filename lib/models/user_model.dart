import 'package:freezed_annotation/freezed_annotation.dart';
import '../core/models/gender.dart';
import '../core/models/media_enums.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String username,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'banner_url') String? bannerUrl,
    String? bio,
    Gender? gender,
    @JsonKey(name: 'dob') DateTime? dateOfBirth,
    @JsonKey(name: 'default_avatar') String? defaultAvatar,
    @Default(UserRole.user) UserRole role,
    @Default(false) @JsonKey(name: 'is_verified') bool isVerified,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @Default(0) @JsonKey(name: 'followers_count') int followersCount,
    @Default(0) @JsonKey(name: 'following_count') int followingCount,
    @Default(0) @JsonKey(name: 'lists_count') int listsCount,
    @Default(0) @JsonKey(name: 'reviews_count') int reviewsCount,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
