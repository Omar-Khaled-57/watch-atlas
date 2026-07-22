import 'isar_collections.dart';

/// In-memory cache service.
///
/// Previously backed by Isar, but isar_generator conflicts with
/// riverpod_generator via incompatible source_gen versions.
/// Migrate to drift or sqflite once Isar is fully removed.
class IsarService {
  static final IsarService instance = IsarService._();
  IsarService._();

  bool get isInitialized => true;

  Future<void> init() async {}

  // ── User Media ──

  final Map<String, List<CachedUserMedia>> _userMediaCache = {};

  Future<List<CachedUserMedia>> getCachedUserMedia(String userId) async {
    return List.unmodifiable(_userMediaCache[userId] ?? []);
  }

  Future<void> cacheUserMedia(CachedUserMedia item) async {
    final list = _userMediaCache[item.userId] ??= [];
    final idx = list.indexWhere((e) => e.remoteId == item.remoteId);
    if (idx >= 0) {
      list[idx] = item;
    } else {
      list.add(item);
    }
  }

  Future<void> cacheAllUserMedia(List<CachedUserMedia> items) async {
    if (items.isEmpty) return;
    final userId = items.first.userId;
    _userMediaCache[userId] = List.from(items);
  }

  Future<void> deleteCachedUserMedia(String remoteId, String userId) async {
    _userMediaCache[userId]?.removeWhere((e) => e.remoteId == remoteId);
  }

  // ── Media ──

  final Map<int, CachedMedia> _mediaCache = {};

  Future<CachedMedia?> getCachedMedia(int remoteId) async {
    return _mediaCache[remoteId];
  }

  Future<void> cacheMedia(CachedMedia item) async {
    _mediaCache[item.remoteId] = item;
  }

  Future<void> cacheAllMedia(List<CachedMedia> items) async {
    for (final item in items) {
      _mediaCache[item.remoteId] = item;
    }
  }

  // ── User Lists ──

  final Map<String, List<CachedUserList>> _userListsCache = {};

  Future<List<CachedUserList>> getCachedUserLists(String userId) async {
    return List.unmodifiable(_userListsCache[userId] ?? []);
  }

  Future<void> cacheUserList(CachedUserList item) async {
    final list = _userListsCache[item.userId] ??= [];
    final idx = list.indexWhere((e) => e.remoteId == item.remoteId);
    if (idx >= 0) {
      list[idx] = item;
    } else {
      list.add(item);
    }
  }

  Future<void> cacheAllUserLists(List<CachedUserList> items) async {
    if (items.isEmpty) return;
    final userId = items.first.userId;
    _userListsCache[userId] = List.from(items);
  }

  Future<void> deleteCachedUserList(String remoteId, String userId) async {
    _userListsCache[userId]?.removeWhere((e) => e.remoteId == remoteId);
  }

  // ── Cleanup ──

  Future<void> clearAll() async {
    _userMediaCache.clear();
    _mediaCache.clear();
    _userListsCache.clear();
  }

  void dispose() {
    clearAll();
  }
}
