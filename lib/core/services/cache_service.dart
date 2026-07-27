import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'cache_models.dart';

/// Persistent cache service backed by SQLite via sqflite_common_ffi.
///
/// Provides lightweight caching of user media, media metadata, and user lists.
/// Data survives app restarts for offline-first loading.
class CacheService {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await databaseFactoryFfi.openDatabase(
      'watch_atlas_cache.db',
      options: OpenDatabaseOptions(version: 1, onCreate: _onCreate),
    );
    return _db!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_media (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        remote_id TEXT UNIQUE NOT NULL,
        media_id INTEGER NOT NULL,
        user_id TEXT NOT NULL,
        media_type TEXT NOT NULL,
        status TEXT NOT NULL,
        season_progress INTEGER DEFAULT 0,
        episode_progress INTEGER DEFAULT 0,
        total_episodes INTEGER DEFAULT 0,
        rewatch_count INTEGER DEFAULT 0,
        user_rating REAL,
        started_at TEXT,
        completed_at TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE media (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        remote_id INTEGER UNIQUE NOT NULL,
        media_type TEXT NOT NULL,
        title TEXT NOT NULL,
        original_title TEXT,
        overview TEXT,
        poster_path TEXT,
        backdrop_path TEXT,
        trailer_url TEXT,
        vote_average REAL,
        vote_count INTEGER,
        popularity REAL DEFAULT 0,
        release_date TEXT,
        runtime INTEGER,
        genres TEXT DEFAULT '',
        countries TEXT DEFAULT '',
        status TEXT,
        language TEXT,
        adult INTEGER DEFAULT 0,
        is_custom INTEGER DEFAULT 0,
        total_episodes INTEGER DEFAULT 0,
        total_seasons INTEGER DEFAULT 0,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE user_lists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        remote_id TEXT UNIQUE NOT NULL,
        user_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        list_type TEXT DEFAULT 'public',
        is_pinned INTEGER DEFAULT 0,
        tags TEXT DEFAULT '',
        created_at TEXT,
        updated_at TEXT,
        item_count INTEGER DEFAULT 0,
        likes_count INTEGER DEFAULT 0
      )
    ''');
  }

  // ── User Media ──

  Future<List<CachedUserMedia>> getCachedUserMedia(String userId) async {
    try {
      final db = await database;
      final rows = await db.query(
        'user_media',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'updated_at DESC',
      );
      return rows.map(CachedUserMedia.fromMap).toList();
    } catch (e) {
      debugPrint('[Cache] Failed to read user media: $e');
      return [];
    }
  }

  Future<void> cacheUserMedia(CachedUserMedia item) async {
    try {
      final db = await database;
      await db.insert(
        'user_media',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('[Cache] Failed to cache user media: $e');
    }
  }

  Future<void> cacheAllUserMedia(List<CachedUserMedia> items) async {
    if (items.isEmpty) return;
    try {
      final db = await database;
      final batch = db.batch();
      for (final item in items) {
        batch.insert(
          'user_media',
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      debugPrint('[Cache] Failed to batch cache user media: $e');
    }
  }

  Future<void> deleteCachedUserMedia(String remoteId) async {
    try {
      final db = await database;
      await db.delete(
        'user_media',
        where: 'remote_id = ?',
        whereArgs: [remoteId],
      );
    } catch (e) {
      debugPrint('[Cache] Failed to delete user media: $e');
    }
  }

  // ── Media ──

  Future<CachedMedia?> getCachedMedia(int remoteId) async {
    try {
      final db = await database;
      final rows = await db.query(
        'media',
        where: 'remote_id = ?',
        whereArgs: [remoteId],
        limit: 1,
      );
      if (rows.isEmpty) return null;
      return CachedMedia.fromMap(rows.first);
    } catch (e) {
      debugPrint('[Cache] Failed to read media: $e');
      return null;
    }
  }

  Future<void> cacheMedia(CachedMedia item) async {
    try {
      final db = await database;
      await db.insert(
        'media',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('[Cache] Failed to cache media: $e');
    }
  }

  Future<void> cacheAllMedia(List<CachedMedia> items) async {
    if (items.isEmpty) return;
    try {
      final db = await database;
      final batch = db.batch();
      for (final item in items) {
        batch.insert(
          'media',
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      debugPrint('[Cache] Failed to batch cache media: $e');
    }
  }

  // ── User Lists ──

  Future<List<CachedUserList>> getCachedUserLists(String userId) async {
    try {
      final db = await database;
      final rows = await db.query(
        'user_lists',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'updated_at DESC',
      );
      return rows.map(CachedUserList.fromMap).toList();
    } catch (e) {
      debugPrint('[Cache] Failed to read user lists: $e');
      return [];
    }
  }

  Future<void> cacheUserList(CachedUserList item) async {
    try {
      final db = await database;
      await db.insert(
        'user_lists',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('[Cache] Failed to cache user list: $e');
    }
  }

  Future<void> cacheAllUserLists(List<CachedUserList> items) async {
    if (items.isEmpty) return;
    try {
      final db = await database;
      final batch = db.batch();
      for (final item in items) {
        batch.insert(
          'user_lists',
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      debugPrint('[Cache] Failed to batch cache user lists: $e');
    }
  }

  Future<void> deleteCachedUserList(String remoteId) async {
    try {
      final db = await database;
      await db.delete(
        'user_lists',
        where: 'remote_id = ?',
        whereArgs: [remoteId],
      );
    } catch (e) {
      debugPrint('[Cache] Failed to delete user list: $e');
    }
  }

  // ── Cleanup ──

  Future<void> clearAll() async {
    try {
      final db = await database;
      await db.delete('user_media');
      await db.delete('media');
      await db.delete('user_lists');
    } catch (e) {
      debugPrint('[Cache] Failed to clear cache: $e');
    }
  }

  Future<void> dispose() async {
    final db = _db;
    _db = null;
    if (db != null) {
      await db.close();
    }
  }
}
