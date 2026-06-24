import 'dart:async';
import 'package:isar/isar.dart';
import '../constants/isar_constants.dart';
import '../constants/app_constants.dart';
import '../../models/sync_queue_model.dart';
import 'connectivity_service.dart';
import 'supabase_service.dart';
import 'isar_service.dart';

class SyncService {
  static final SyncService instance = SyncService._();
  SyncService._();

  Timer? _syncTimer;
  bool _isSyncing = false;

  void init() {
    ConnectivityService.instance.onConnectivityChanged.listen((online) {
      if (online) syncNow();
    });
    _syncTimer = Timer.periodic(AppConstants.syncInterval, (_) => syncNow());
  }

  Future<void> syncNow() async {
    if (_isSyncing) return;
    if (!ConnectivityService.instance.isOnline) return;

    _isSyncing = true;
    try {
      final isar = IsarService.instance.db;
      final queue = await isar.syncQueues.where().findAll();
      for (final item in queue) {
        try {
          await _processSyncItem(item);
          await isar.writeTxn(() => isar.syncQueues.delete(item.id));
        } catch (e) {
          await isar.writeTxn(() {
            item.retryCount++;
            item.errorMessage = e.toString();
            isar.syncQueues.put(item);
          });
          if (item.retryCount >= AppConstants.maxRetries) {
            await isar.writeTxn(() => isar.syncQueues.delete(item.id));
          }
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _processSyncItem(SyncQueueModel item) async {
    final supabase = SupabaseService.instance;
    switch (item.operation) {
      case SyncOperation.create:
        await supabase.client.from(item.tableName).insert(item.data);
      case SyncOperation.update:
        await supabase.client.from(item.tableName).update(item.data).eq('id', item.recordId);
      case SyncOperation.delete:
        await supabase.client.from(item.tableName).delete().eq('id', item.recordId);
    }
  }

  Future<void> enqueue({
    required String tableName,
    required String recordId,
    required SyncOperation operation,
    required Map<String, dynamic> data,
  }) async {
    final isar = IsarService.instance.db;
    final item = SyncQueueModel(
      id: '${tableName}_${recordId}_${DateTime.now().millisecondsSinceEpoch}',
      tableName: tableName,
      recordId: recordId,
      operation: operation,
      data: data,
    );
    await isar.writeTxn(() => isar.syncQueues.put(item));
    if (ConnectivityService.instance.isOnline) {
      syncNow();
    }
  }

  void dispose() {
    _syncTimer?.cancel();
  }
}
