// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  displayName: json['display_name'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  bannerUrl: json['banner_url'] as String?,
  bio: json['bio'] as String?,
  gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
  dateOfBirth: json['dob'] == null
      ? null
      : DateTime.parse(json['dob'] as String),
  defaultAvatar: json['default_avatar'] as String?,
  role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.user,
  isVerified: json['is_verified'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  followersCount: (json['followers_count'] as num?)?.toInt() ?? 0,
  followingCount: (json['following_count'] as num?)?.toInt() ?? 0,
  listsCount: (json['lists_count'] as num?)?.toInt() ?? 0,
  reviewsCount: (json['reviews_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'display_name': instance.displayName,
      'avatar_url': instance.avatarUrl,
      'banner_url': instance.bannerUrl,
      'bio': instance.bio,
      'gender': _$GenderEnumMap[instance.gender],
      'dob': instance.dateOfBirth?.toIso8601String(),
      'default_avatar': instance.defaultAvatar,
      'role': _$UserRoleEnumMap[instance.role]!,
      'is_verified': instance.isVerified,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'followers_count': instance.followersCount,
      'following_count': instance.followingCount,
      'lists_count': instance.listsCount,
      'reviews_count': instance.reviewsCount,
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.ratherNotSay: 'ratherNotSay',
};

const _$UserRoleEnumMap = {
  UserRole.user: 'user',
  UserRole.moderator: 'moderator',
  UserRole.admin: 'admin',
};
