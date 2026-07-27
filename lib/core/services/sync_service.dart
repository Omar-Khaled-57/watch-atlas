import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/media_enums.dart';
import '../../models/sync_queue_model.dart';
import 'connectivity_service.dart';
import 'supabase_service.dart';

/// Manages offline-to-online data synchronization with Supabase.
///
/// Changes made while offline are persisted to a local queue in
/// [SharedPreferences]. When connectivity is restored, or on a periodic
/// timer ([AppConstants.syncInterval]), the queue is drained and each
/// item is applied to Supabase (create / update / delete).
///
/// Use [instance] for quick access; inject configured instances for tests.
class SyncService {
  static final SyncService instance = SyncService();

  SyncService({ConnectivityService? connectivity, SupabaseService? supabase})
    : _connectivity = connectivity ?? ConnectivityService.instance,
      _supabase = supabase ?? SupabaseService.instance;

  final ConnectivityService _connectivity;
  final SupabaseService _supabase;

  Timer? _syncTimer;
  bool _isSyncing = false;
  List<SyncQueueModel> _queue = [];

  List<SyncQueueModel> get queue => List.unmodifiable(_queue);

  /// Loads the persisted sync queue from [SharedPreferences] and starts
  /// listening for connectivity changes and periodic sync triggers.
  void init() {
    _loadQueue();
    _connectivity.onConnectivityChanged.listen((online) {
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
        _queue = list
            .map((e) => SyncQueueModel.fromJson(e as Map<String, dynamic>))
            .toList();
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

  /// Processes all pending sync items sequentially.
  ///
  /// Each item is retried on failure; after [AppConstants.maxRetries]
  /// consecutive failures the item is dropped. Items that succeed are
  /// removed from the queue.
  Future<void> syncNow() async {
    if (_isSyncing) return;
    if (!_connectivity.isOnline) return;

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
            final newRetryCount = item.retryCount + 1;
            _queue[index] = SyncQueueModel(
              id: item.id,
              tableName: item.tableName,
              recordId: item.recordId,
              operation: item.operation,
              data: item.data,
              retryCount: newRetryCount,
              errorMessage: e.toString(),
            );
            if (newRetryCount >= AppConstants.maxRetries) {
              _queue.removeAt(index);
            } else {
              final delay = Duration(
                milliseconds: 500 * (1 << (newRetryCount - 1)),
              );
              await Future<void>.delayed(delay);
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
    switch (item.operation) {
      case SyncOperation.create:
        await _supabase.client.from(item.tableName).insert(item.data);
      case SyncOperation.update:
        await _supabase.client
            .from(item.tableName)
            .update(item.data)
            .eq('id', item.recordId);
      case SyncOperation.delete:
        await _supabase.client
            .from(item.tableName)
            .delete()
            .eq('id', item.recordId);
    }
  }

  /// Adds a change to the sync queue and triggers an immediate sync
  /// if the device is currently online.
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
    if (_connectivity.isOnline) {
      syncNow();
    }
  }

  void dispose() {
    _syncTimer?.cancel();
  }
}
