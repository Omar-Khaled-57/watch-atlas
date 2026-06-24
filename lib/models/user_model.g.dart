// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  displayName: json['displayName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  bannerUrl: json['bannerUrl'] as String?,
  bio: json['bio'] as String?,
  role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.user,
  isVerified: json['isVerified'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  followersCount: (json['followersCount'] as num?)?.toInt() ?? 0,
  followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
  listsCount: (json['listsCount'] as num?)?.toInt() ?? 0,
  reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'bannerUrl': instance.bannerUrl,
      'bio': instance.bio,
      'role': _$UserRoleEnumMap[instance.role]!,
      'isVerified': instance.isVerified,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'followersCount': instance.followersCount,
      'followingCount': instance.followingCount,
      'listsCount': instance.listsCount,
      'reviewsCount': instance.reviewsCount,
    };

const _$UserRoleEnumMap = {
  UserRole.user: 'user',
  UserRole.moderator: 'moderator',
  UserRole.admin: 'admin',
};
