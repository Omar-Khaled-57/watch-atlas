import 'package:freezed_annotation/freezed_annotation.dart';
import '../core/models/media_enums.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String username,
    String? displayName,
    String? avatarUrl,
    String? bannerUrl,
    String? bio,
    @Default(UserRole.user) UserRole role,
    @Default(false) bool isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int followersCount,
    @Default(0) int followingCount,
    @Default(0) int listsCount,
    @Default(0) int reviewsCount,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
