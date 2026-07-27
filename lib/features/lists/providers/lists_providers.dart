import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/media_enums.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/supabase_service.dart';
import '../../../models/media_model.dart';
import '../../../models/user_list_model.dart';

const _tag = '\x1B[36m[Lists]\x1B[0m';
const _ok = '\x1B[32m✔\x1B[0m';
const _fail = '\x1B[31m✘\x1B[0m';
const _info = '\x1B[33m→\x1B[0m';

void _log(String msg) => debugPrint('$_tag $_info $msg');
void _okLog(String msg) => debugPrint('$_tag $_ok $msg');
void _errLog(String msg) => debugPrint('$_tag $_fail $msg');

class UserListsNotifier extends Notifier<AsyncValue<List<UserListModel>>> {
  late final SupabaseService _supabase;
  late final String _userId;

  @override
  AsyncValue<List<UserListModel>> build() {
    _supabase = ref.read(supabaseServiceProvider);
    _userId = ref.read(authServiceProvider).userId;
    _log('build() — loading lists for user=$_userId');
    _load();
    return const AsyncValue.loading();
  }

  Future<void> _load() async {
    _log('load() — fetching lists from DB…');
    try {
      final response = await _supabase.userLists
          .select()
          .eq('user_id', _userId)
          .order('created_at', ascending: false);
      final list = (response as List<dynamic>)
          .map((json) {
            try {
              return UserListModel.fromJson(json as Map<String, dynamic>);
            } catch (e) {
              _errLog('load() — skipping invalid list row: $e');
              return null;
            }
          })
          .whereType<UserListModel>()
          .toList();
      state = AsyncValue.data(list);
      _okLog('load() — loaded ${list.length} lists');
      for (final l in list) {
        _log('  • "${l.title}" (${l.id}) — itemCount=${l.itemCount}');
      }
    } catch (e) {
      _errLog('load() — failed: $e');
      state = AsyncValue.data([]);
    }
  }

  List<UserListModel> get pinnedLists {
    return state.value?.where((l) => l.isPinned).toList() ?? [];
  }

  List<UserListModel> get allLists {
    return state.value ?? [];
  }

  Future<void> createList({
    required String title,
    String? description,
    MediaListType listType = MediaListType.public,
    List<String> tags = const [],
  }) async {
    final now = DateTime.now();
    final list = UserListModel(
      id: '${_userId}_${now.millisecondsSinceEpoch}',
      userId: _userId,
      title: title,
      description: description,
      listType: listType,
      tags: tags,
      createdAt: now,
      updatedAt: now,
    );
    _log('createList() — title="$title" type=${listType.name} id=${list.id}');
    final current = state.value ?? [];
    state = AsyncValue.data([list, ...current]);
    try {
      await _supabase.userLists.insert({
        'id': list.id,
        'user_id': list.userId,
        'title': list.title,
        'description': list.description,
        'list_type': list.listType.name,
        'is_pinned': list.isPinned,
        'tags': list.tags,
        'created_at': list.createdAt?.toIso8601String(),
        'updated_at': list.updatedAt?.toIso8601String(),
        'item_count': list.itemCount,
        'likes_count': list.likesCount,
      });
      _okLog('createList() — "$title" created in DB');
    } catch (e) {
      _errLog('createList() — DB insert failed: $e');
    }
  }

  Future<void> updateList(UserListModel updated) async {
    _log('updateList() — id=${updated.id} title="${updated.title}"');
    final current = List<UserListModel>.from(state.value ?? []);
    final index = current.indexWhere((l) => l.id == updated.id);
    if (index >= 0) {
      current[index] = updated;
      state = AsyncValue.data(current);
    }
    try {
      await _supabase.userLists
          .upsert({
            'id': updated.id,
            'user_id': updated.userId,
            'title': updated.title,
            'description': updated.description,
            'list_type': updated.listType.name,
            'is_pinned': updated.isPinned,
            'tags': updated.tags,
            'created_at': updated.createdAt?.toIso8601String(),
            'updated_at': updated.updatedAt?.toIso8601String(),
            'item_count': updated.itemCount,
            'likes_count': updated.likesCount,
          })
          .eq('id', updated.id);
      _okLog('updateList() — "${updated.title}" saved');
    } catch (e) {
      _errLog('updateList() — DB update failed: $e');
    }
  }

  Future<void> togglePin(UserListModel list) async {
    _log('togglePin() — "${list.title}" isPinned=${list.isPinned}');
    await updateList(
      list.copyWith(isPinned: !list.isPinned, updatedAt: DateTime.now()),
    );
  }

  Future<void> deleteList(UserListModel list) async {
    _log('deleteList() — "${list.title}" (${list.id})');
    final current = state.value ?? [];
    state = AsyncValue.data(current.where((l) => l.id != list.id).toList());
    try {
      await _supabase.userLists.delete().eq('id', list.id);
      await _supabase.listItems.delete().eq('list_id', list.id);
      _okLog('deleteList() — "${list.title}" removed from DB');
    } catch (e) {
      _errLog('deleteList() — DB delete failed: $e');
    }
  }

  /// Count actual rows in list_items for [listId], update local state + DB.
  /// Returns the real count.
  Future<int> _syncItemCount(String listId) async {
    try {
      final rows = await _supabase.listItems.select('id').eq('list_id', listId);
      final realCount = (rows as List<dynamic>).length;
      _log('_syncItemCount() — listId=$listId realCount=$realCount');

      final current = List<UserListModel>.from(state.value ?? []);
      final idx = current.indexWhere((l) => l.id == listId);
      if (idx >= 0) {
        final oldCount = current[idx].itemCount;
        current[idx] = current[idx].copyWith(
          itemCount: realCount,
          updatedAt: DateTime.now(),
        );
        state = AsyncValue.data(List.from(current));
        if (oldCount != realCount) {
          _log(
            '_syncItemCount() — corrected count for "${current[idx].title}": $oldCount → $realCount',
          );
        }
      }

      await _supabase.userLists
          .update({
            'item_count': realCount,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', listId);
      return realCount;
    } catch (e) {
      _errLog('_syncItemCount() — failed for listId=$listId: $e');
      return -1;
    }
  }

  Future<void> refreshListCounts() async {
    _log('refreshListCounts() — recounting all lists…');
    final current = state.value ?? [];
    if (current.isEmpty) {
      _log('refreshListCounts() — no lists to refresh');
      return;
    }
    final updated = await Future.wait(
      current.map((list) async {
        try {
          final rows = await _supabase.listItems
              .select('id')
              .eq('list_id', list.id);
          final realCount = (rows as List<dynamic>).length;
          final oldCount = list.itemCount;
          if (oldCount != realCount) {
            _log(
              'refreshListCounts() — "${list.title}": $oldCount → $realCount',
            );
          }
          await _supabase.userLists
              .update({
                'item_count': realCount,
                'updated_at': DateTime.now().toIso8601String(),
              })
              .eq('id', list.id);
          return list.copyWith(itemCount: realCount);
        } catch (e) {
          _errLog('refreshListCounts() — failed for "${list.title}": $e');
          return list;
        }
      }),
    );
    state = AsyncValue.data(updated);
    _okLog('refreshListCounts() — done, ${updated.length} lists refreshed');
  }

  /// Full refresh: re-fetch lists from DB then reconcile all item counts.
  Future<void> refresh() async {
    _log('refresh() — full reload starting…');
    final listIds = state.value?.map((l) => l.id).toList() ?? [];
    await _load();
    await refreshListCounts();
    for (final lid in listIds) {
      ref.invalidate(listItemsProvider(lid));
    }
    ref.invalidate(allListItemsProvider);
    _okLog('refresh() — complete');
  }

  Future<void> addItemToList(
    String listId,
    MediaModel media, {
    String? note,
  }) async {
    _log(
      'addItemToList() — media="${media.title}" (id=${media.id}) → listId=$listId',
    );
    try {
      try {
        await _supabase.media.upsert({
          'id': media.id,
          'media_type': media.mediaType.name,
          'title': media.title,
          'original_title': media.originalTitle,
          'overview': media.overview,
          'poster_path': media.posterPath,
          'backdrop_path': media.backdropPath,
          'vote_average': media.voteAverage,
          'vote_count': media.voteCount,
          'popularity': media.popularity,
          'release_date': media.releaseDate?.toIso8601String(),
          'runtime': media.runtime,
          'genres': media.genres,
          'countries': media.countries,
          'status': media.status,
          'language': media.language,
          'adult': media.adult,
          'total_episodes': media.totalEpisodes,
          'total_seasons': media.totalSeasons,
          'updated_at': DateTime.now().toIso8601String(),
        });
        _log('addItemToList() — media upserted to DB');
      } catch (e) {
        _errLog(
          'addItemToList() — media upsert failed (may already exist): $e',
        );
      }

      final nextSortOrder = await _getNextSortOrder(listId);
      _log('addItemToList() — nextSortOrder=$nextSortOrder');

      await _supabase.listItems.insert({
        'list_id': listId,
        'media_id': media.id,
        'note': note,
        'sort_order': nextSortOrder,
      });
      _okLog('addItemToList() — "${media.title}" inserted into list_items');

      ref.invalidate(mediaListMembershipProvider(media.id));
      ref.invalidate(listItemsProvider(listId));
      final realCount = await _syncItemCount(listId);
      final listName =
          state.value?.where((l) => l.id == listId).firstOrNull?.title ??
          listId;
      _okLog(
        'addItemToList() — added "${media.title}" to "$listName" (items: $realCount)',
      );
    } catch (e) {
      _errLog(
        'addItemToList() — FAILED to add "${media.title}" to list $listId: $e',
      );
    }
  }

  Future<void> removeItemFromList(String listId, int mediaId) async {
    _log('removeItemFromList() — mediaId=$mediaId from listId=$listId');
    try {
      await _supabase.listItems
          .delete()
          .eq('list_id', listId)
          .eq('media_id', mediaId);
      _okLog('removeItemFromList() — deleted from DB');

      ref.invalidate(mediaListMembershipProvider(mediaId));
      ref.invalidate(listItemsProvider(listId));
      final realCount = await _syncItemCount(listId);
      final listName =
          state.value?.where((l) => l.id == listId).firstOrNull?.title ??
          listId;
      _okLog(
        'removeItemFromList() — removed media $mediaId from "$listName" (items: $realCount)',
      );
    } catch (e) {
      _errLog('removeItemFromList() — failed: $e');
    }
  }

  Future<void> moveItemToList(
    String fromListId,
    String toListId,
    int mediaId, {
    String? note,
  }) async {
    _log('moveItemToList() — mediaId=$mediaId from=$fromListId to=$toListId');
    try {
      final nextSortOrder = await _getNextSortOrder(toListId);
      await _supabase.listItems.insert({
        'list_id': toListId,
        'media_id': mediaId,
        'note': note,
        'sort_order': nextSortOrder,
      });
      await _supabase.listItems
          .delete()
          .eq('list_id', fromListId)
          .eq('media_id', mediaId);
      ref.invalidate(mediaListMembershipProvider(mediaId));
      ref.invalidate(listItemsProvider(fromListId));
      ref.invalidate(listItemsProvider(toListId));
      final fromCount = await _syncItemCount(fromListId);
      final toCount = await _syncItemCount(toListId);
      final fromName =
          state.value?.where((l) => l.id == fromListId).firstOrNull?.title ??
          fromListId;
      final toName =
          state.value?.where((l) => l.id == toListId).firstOrNull?.title ??
          toListId;
      _okLog(
        'moveItemToList() — moved media $mediaId from "$fromName" ($fromCount) → "$toName" ($toCount)',
      );
    } catch (e) {
      _errLog('moveItemToList() — FAILED: $e');
    }
  }

  Future<void> copyItemToList(
    String toListId,
    int mediaId, {
    String? note,
  }) async {
    _log('copyItemToList() — mediaId=$mediaId to listId=$toListId');
    try {
      final nextSortOrder = await _getNextSortOrder(toListId);
      await _supabase.listItems.insert({
        'list_id': toListId,
        'media_id': mediaId,
        'note': note,
        'sort_order': nextSortOrder,
      });
      ref.invalidate(mediaListMembershipProvider(mediaId));
      ref.invalidate(listItemsProvider(toListId));
      final realCount = await _syncItemCount(toListId);
      final listName =
          state.value?.where((l) => l.id == toListId).firstOrNull?.title ??
          toListId;
      _okLog(
        'copyItemToList() — copied media $mediaId to "$listName" (items: $realCount)',
      );
    } catch (e) {
      _errLog('copyItemToList() — FAILED: $e');
    }
  }

  Future<int> _getNextSortOrder(String listId) async {
    try {
      final response = await _supabase.listItems
          .select('sort_order')
          .eq('list_id', listId)
          .order('sort_order', ascending: false)
          .limit(1);
      final rows = response as List<dynamic>;
      if (rows.isEmpty) return 0;
      return (rows.first['sort_order'] as int) + 1;
    } catch (e) {
      _errLog('_getNextSortOrder() — failed: $e, defaulting to 0');
      return 0;
    }
  }

  Future<void> reorderItems(String listId, List<int> mediaIds) async {
    _log('reorderItems() — listId=$listId count=${mediaIds.length}');
    try {
      for (var i = 0; i < mediaIds.length; i++) {
        await _supabase.listItems
            .update({'sort_order': i})
            .eq('list_id', listId)
            .eq('media_id', mediaIds[i]);
      }
      ref.invalidate(listItemsProvider(listId));
      _okLog('reorderItems() — reordered ${mediaIds.length} items');
    } catch (e) {
      _errLog('reorderItems() — failed: $e');
    }
  }

  Future<void> likeList(String listId) async {
    _log('likeList() — listId=$listId');
    final current = state.value ?? [];
    final index = current.indexWhere((l) => l.id == listId);
    if (index < 0) return;
    final newLikesCount = current[index].likesCount + 1;
    final updated = current[index].copyWith(
      likesCount: newLikesCount,
      updatedAt: DateTime.now(),
    );
    current[index] = updated;
    state = AsyncValue.data(List.from(current));
    try {
      await _supabase.userLists
          .update({'likes_count': newLikesCount})
          .eq('id', listId);
      _okLog('likeList() — "${current[index].title}" likes=$newLikesCount');
    } catch (e) {
      _errLog('likeList() — failed: $e');
    }
  }
}

final userListsProvider =
    NotifierProvider<UserListsNotifier, AsyncValue<List<UserListModel>>>(
      UserListsNotifier.new,
    );

final pinnedListsProvider = Provider<List<UserListModel>>((ref) {
  final notifier = ref.watch(userListsProvider.notifier);
  return notifier.pinnedLists;
});

final listItemsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      listId,
    ) async {
      final supabase = ref.watch(supabaseServiceProvider);
      try {
        final response = await supabase.listItems
            .select('*, media(id, title, poster_path, media_type)')
            .eq('list_id', listId)
            .order('sort_order', ascending: true);
        return (response as List<dynamic>).cast<Map<String, dynamic>>();
      } catch (e) {
        debugPrint('listItemsProvider($listId): $e');
        return [];
      }
    });

class _ListsSearchNotifier extends Notifier<String> {
  @override
  String build() => '';
}

final listsSearchProvider = NotifierProvider<_ListsSearchNotifier, String>(
  _ListsSearchNotifier.new,
);

final allListItemsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final supabase = ref.watch(supabaseServiceProvider);
  final userId = ref.watch(authServiceProvider).userId;
  try {
    final listIdsResponse = await supabase.userLists
        .select('id')
        .eq('user_id', userId);
    final listIds = (listIdsResponse as List<dynamic>)
        .map((j) => j['id'] as String)
        .toList();
    if (listIds.isEmpty) return [];
    final allItems = <Map<String, dynamic>>[];
    for (final lid in listIds) {
      final response = await supabase.listItems
          .select('*, media(id, title, poster_path, media_type)')
          .eq('list_id', lid)
          .order('sort_order', ascending: true);
      allItems.addAll((response as List<dynamic>).cast<Map<String, dynamic>>());
    }
    return allItems;
  } catch (e) {
    debugPrint('allListItemsProvider: $e');
    return [];
  }
});

final totalTitlesProvider = Provider<int>((ref) {
  final lists = ref.watch(userListsProvider).value ?? [];
  return lists.fold(0, (sum, l) => sum + l.itemCount);
});

final listCategoriesProvider = FutureProvider.family<List<String>, String>((
  ref,
  listId,
) async {
  final items = await ref.watch(listItemsProvider(listId).future);
  final categories = items.map((item) {
    final mediaData = item['media'] as Map<String, dynamic>?;
    return mediaData?['media_type'] as String? ??
        item['media_type'] as String? ??
        'unknown';
  }).toSet();
  final ordered = <String>[];
  if (categories.contains('tv')) ordered.add('TV Shows');
  if (categories.contains('movie')) ordered.add('Movies');
  if (categories.contains('anime')) ordered.add('Anime');
  ordered.addAll(
    categories
        .where((c) => c != 'tv' && c != 'movie' && c != 'anime')
        .map((c) => c[0].toUpperCase() + c.substring(1)),
  );
  return ordered;
});

final mediaListMembershipProvider =
    FutureProvider.family<List<Map<String, dynamic>>, int>((
      ref,
      mediaId,
    ) async {
      final supabase = ref.watch(supabaseServiceProvider);
      final userId = ref.watch(authServiceProvider).userId;
      if (userId.isEmpty) return [];
      try {
        final lists = await supabase.userLists
            .select('id, title')
            .eq('user_id', userId);
        final userLists = (lists as List<dynamic>).cast<Map<String, dynamic>>();
        if (userLists.isEmpty) return [];
        final userListIds = userLists.map((l) => l['id'] as String).toList();

        final items = await supabase.listItems
            .select('list_id, added_at')
            .eq('media_id', mediaId)
            .or('list_id.in.(${userListIds.join(',')})');
        final listItems = (items as List<dynamic>).cast<Map<String, dynamic>>();

        final result = <Map<String, dynamic>>[];
        for (final item in listItems) {
          final listId = item['list_id'] as String;
          final matchingList = userLists
              .where((l) => l['id'] == listId)
              .firstOrNull;
          if (matchingList != null) {
            result.add({
              'list_id': listId,
              'list_title': matchingList['title'] as String,
              'added_at': item['added_at'] as String?,
            });
          }
        }
        return result;
      } catch (e) {
        debugPrint('Failed to load list membership: $e');
        return [];
      }
    });
