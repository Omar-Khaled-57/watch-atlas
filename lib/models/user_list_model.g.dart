// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserListModel _$UserListModelFromJson(Map<String, dynamic> json) =>
    _UserListModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      listType:
          $enumDecodeNullable(_$MediaListTypeEnumMap, json['listType']) ??
          MediaListType.public,
      isPinned: json['isPinned'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$UserListModelToJson(_UserListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'listType': _$MediaListTypeEnumMap[instance.listType]!,
      'isPinned': instance.isPinned,
      'tags': instance.tags,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'itemCount': instance.itemCount,
      'likesCount': instance.likesCount,
    };

const _$MediaListTypeEnumMap = {
  MediaListType.public: 'public',
  MediaListType.private: 'private',
  MediaListType.collaborative: 'collaborative',
};
