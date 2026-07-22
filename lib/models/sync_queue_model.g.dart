// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_queue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncQueueModel _$SyncQueueModelFromJson(Map<String, dynamic> json) =>
    _SyncQueueModel(
      id: json['id'] as String,
      tableName: json['tableName'] as String,
      recordId: json['recordId'] as String,
      operation: $enumDecode(_$SyncOperationEnumMap, json['operation']),
      data: json['data'] as Map<String, dynamic>,
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      errorMessage: json['errorMessage'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SyncQueueModelToJson(_SyncQueueModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableName': instance.tableName,
      'recordId': instance.recordId,
      'operation': _$SyncOperationEnumMap[instance.operation]!,
      'data': instance.data,
      'retryCount': instance.retryCount,
      'errorMessage': instance.errorMessage,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$SyncOperationEnumMap = {
  SyncOperation.create: 'create',
  SyncOperation.update: 'update',
  SyncOperation.delete: 'delete',
};
