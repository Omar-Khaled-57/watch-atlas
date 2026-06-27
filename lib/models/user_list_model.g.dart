// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserListModel _$UserListModelFromJson(Map<String, dynamic> json) =>
    _UserListModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      listType:
          $enumDecodeNullable(_$MediaListTypeEnumMap, json['list_type']) ??
          MediaListType.public,
      isPinned: json['is_pinned'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$UserListModelToJson(_UserListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'list_type': _$MediaListTypeEnumMap[instance.listType]!,
      'is_pinned': instance.isPinned,
      'tags': instance.tags,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'item_count': instance.itemCount,
      'likes_count': instance.likesCount,
    };

const _$MediaListTypeEnumMap = {
  MediaListType.public: 'public',
  MediaListType.private: 'private',
  MediaListType.collaborative: 'collaborative',
};
