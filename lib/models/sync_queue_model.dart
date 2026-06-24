import 'package:freezed_annotation/freezed_annotation.dart';
import '../core/models/media_enums.dart';

part 'sync_queue_model.freezed.dart';
part 'sync_queue_model.g.dart';

@freezed
class SyncQueueModel with _$SyncQueueModel {
  const factory SyncQueueModel({
    required String id,
    required String tableName,
    required String recordId,
    required SyncOperation operation,
    required Map<String, dynamic> data,
    @Default(0) int retryCount,
    String? errorMessage,
    DateTime? createdAt,
  }) = _SyncQueueModel;

  factory SyncQueueModel.fromJson(Map<String, dynamic> json) => _$SyncQueueModelFromJson(json);
}
