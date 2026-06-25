import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/media_enums.dart';
import '../../models/sync_queue_model.dart';
import 'connectivity_service.dart';
import 'supabase_service.dart';

class SyncService {
  static final SyncService instance = SyncService._();
  SyncService._();

  Timer? _syncTimer;
  bool _isSyncing = false;
  List<SyncQueueModel> _queue = [];

  List<SyncQueueModel> get queue => List.unmodifiable(_queue);

  void init() {
    _loadQueue();
    ConnectivityService.instance.onConnectivityChanged.listen((online) {
      if (online) syncNow();
    });
    _syncTimer = Timer.periodic(AppConstants.syncInterval, (_) => syncNow());
  }

  Future<void> _loadQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('sync_queue');
      if (data != null) {
        final list = jsonDecode(data) as List<dynamic>;
        _queue = list.map((e) => SyncQueueModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('Failed to load sync queue: $e');
    }
  }

  Future<void> _saveQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonEncode(_queue.map((e) => e.toJson()).toList());
      await prefs.setString('sync_queue', data);
    } catch (e) {
      debugPrint('Failed to save sync queue: $e');
    }
  }

  Future<void> syncNow() async {
    if (_isSyncing) return;
    if (!ConnectivityService.instance.isOnline) return;

    _isSyncing = true;
    try {
      final items = List<SyncQueueModel>.from(_queue);
      for (final item in items) {
        try {
          await _processSyncItem(item);
          _queue.removeWhere((q) => q.id == item.id);
        } catch (e) {
          final index = _queue.indexWhere((q) => q.id == item.id);
          if (index != -1) {
            _queue[index] = SyncQueueModel(
              id: item.id,
              tableName: item.tableName,
              recordId: item.recordId,
              operation: item.operation,
              data: item.data,
              retryCount: item.retryCount + 1,
              errorMessage: e.toString(),
            );
            if (_queue[index].retryCount >= AppConstants.maxRetries) {
              _queue.removeAt(index);
            }
          }
        }
      }
      await _saveQueue();
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
    final item = SyncQueueModel(
      id: '${tableName}_${recordId}_${DateTime.now().millisecondsSinceEpoch}',
      tableName: tableName,
      recordId: recordId,
      operation: operation,
      data: data,
    );
    _queue.add(item);
    await _saveQueue();
    if (ConnectivityService.instance.isOnline) {
      syncNow();
    }
  }

  void dispose() {
    _syncTimer?.cancel();
  }
}
