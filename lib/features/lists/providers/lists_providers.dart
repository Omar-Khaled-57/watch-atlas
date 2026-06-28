import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/media_enums.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/supabase_service.dart';
import '../../../models/media_model.dart';
import '../../../models/user_list_model.dart';

class UserListsNotifier extends Notifier<AsyncValue<List<UserListModel>>> {
  late final SupabaseService _supabase;
  late final String _userId;

  @override
  AsyncValue<List<UserListModel>> build() {
    _supabase = ref.read(supabaseServiceProvider);
    _userId = ref.read(authServiceProvider).userId;
    _load();
    return const AsyncValue.loading();
  }

  Future<void> _load() async {
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
              debugPrint('Skipping invalid list row: $e');
              return null;
            }
          })
          .whereType<UserListModel>()
          .toList();
      state = AsyncValue.data(list);
    } catch (e) {
      debugPrint('Failed to load lists: $e');
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
    } catch (e) {
      debugPrint('Failed to create list in DB: $e');
    }
  }

  Future<void> updateList(UserListModel updated) async {
    final current = state.value ?? [];
    final index = current.indexWhere((l) => l.id == updated.id);
    if (index >= 0) {
      current[index] = updated;
      state = AsyncValue.data(List.from(current));
    }
    try {
      await _supabase.userLists.upsert({
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
      }).eq('id', updated.id);
    } catch (_) {}
  }

  Future<void> togglePin(UserListModel list) async {
    await updateList(list.copyWith(isPinned: !list.isPinned, updatedAt: DateTime.now()));
  }

  Future<void> deleteList(UserListModel list) async {
    final current = state.value ?? [];
    state = AsyncValue.data(current.where((l) => l.id != list.id).toList());
    try {
      await _supabase.userLists.delete().eq('id', list.id);
      await _supabase.listItems.delete().eq('list_id', list.id);
    } catch (_) {}
  }

  Future<void> _syncItemCount(String listId) async {
    try {
      final current = state.value ?? [];
      final idx = current.indexWhere((l) => l.id == listId);
      if (idx < 0) return;
      await _supabase.userLists
          .update({'item_count': current[idx].itemCount, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', listId);
    } catch (_) {}
  }

  Future<void> addItemToList(String listId, MediaModel media, {String? note}) async {
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
      } catch (e) {
        debugPrint('Media upsert failed (may already exist), continuing: $e');
      }
      await _supabase.listItems.insert({
        'list_id': listId,
        'media_id': media.id,
        'note': note,
        'sort_order': 0,
      });
      final current = state.value ?? [];
      final index = current.indexWhere((l) => l.id == listId);
      if (index >= 0) {
        final updated = current[index].copyWith(
          itemCount: current[index].itemCount + 1,
          updatedAt: DateTime.now(),
        );
        current[index] = updated;
        state = AsyncValue.data(List.from(current));
      }
      ref.invalidate(mediaListMembershipProvider(media.id));
      _syncItemCount(listId);
    } catch (e) {
      debugPrint('Failed to add item to list: $e');
    }
  }

  Future<void> removeItemFromList(String listId, int mediaId) async {
    try {
      await _supabase.listItems.delete().eq('list_id', listId).eq('media_id', mediaId);
      final current = state.value ?? [];
      final index = current.indexWhere((l) => l.id == listId);
      if (index >= 0) {
        final updated = current[index].copyWith(
          itemCount: (current[index].itemCount - 1).clamp(0, 999999),
          updatedAt: DateTime.now(),
        );
        current[index] = updated;
        state = AsyncValue.data(List.from(current));
      }
      ref.invalidate(mediaListMembershipProvider(mediaId));
      _syncItemCount(listId);
    } catch (_) {}
  }

  Future<void> moveItemToList(String fromListId, String toListId, int mediaId, {String? note}) async {
    try {
      await _supabase.listItems.insert({
        'list_id': toListId,
        'media_id': mediaId,
        'note': note,
        'sort_order': 0,
      });
      await _supabase.listItems.delete().eq('list_id', fromListId).eq('media_id', mediaId);
      final current = state.value ?? [];
      final fromIdx = current.indexWhere((l) => l.id == fromListId);
      final toIdx = current.indexWhere((l) => l.id == toListId);
      if (fromIdx >= 0) {
        current[fromIdx] = current[fromIdx].copyWith(
          itemCount: (current[fromIdx].itemCount - 1).clamp(0, 999999),
          updatedAt: DateTime.now(),
        );
      }
      if (toIdx >= 0) {
        current[toIdx] = current[toIdx].copyWith(
          itemCount: current[toIdx].itemCount + 1,
          updatedAt: DateTime.now(),
        );
      }
      state = AsyncValue.data(List.from(current));
      ref.invalidate(mediaListMembershipProvider(mediaId));
      _syncItemCount(fromListId);
      _syncItemCount(toListId);
    } catch (e) {
      debugPrint('Failed to move item: $e');
    }
  }

  Future<void> copyItemToList(String toListId, int mediaId, {String? note}) async {
    try {
      await _supabase.listItems.insert({
        'list_id': toListId,
        'media_id': mediaId,
        'note': note,
        'sort_order': 0,
      });
      final current = state.value ?? [];
      final toIdx = current.indexWhere((l) => l.id == toListId);
      if (toIdx >= 0) {
        current[toIdx] = current[toIdx].copyWith(
          itemCount: current[toIdx].itemCount + 1,
          updatedAt: DateTime.now(),
        );
      }
      state = AsyncValue.data(List.from(current));
      ref.invalidate(mediaListMembershipProvider(mediaId));
      _syncItemCount(toListId);
    } catch (e) {
      debugPrint('Failed to copy item: $e');
    }
  }

  Future<void> reorderItems(String listId, List<int> mediaIds) async {
    try {
      for (var i = 0; i < mediaIds.length; i++) {
        await _supabase.listItems
            .update({'sort_order': i})
            .eq('list_id', listId)
            .eq('media_id', mediaIds[i]);
      }
    } catch (_) {}
  }

  Future<void> likeList(String listId) async {
    final current = state.value ?? [];
    final index = current.indexWhere((l) => l.id == listId);
    if (index >= 0) {
      final updated = current[index].copyWith(
        likesCount: current[index].likesCount + 1,
        updatedAt: DateTime.now(),
      );
      current[index] = updated;
      state = AsyncValue.data(List.from(current));
    }
    try {
      await _supabase.userLists
          .update({'likes_count': (state.value?.firstWhere((l) => l.id == listId).likesCount ?? 0)})
          .eq('id', listId);
    } catch (_) {}
  }
}

final userListsProvider = NotifierProvider<UserListsNotifier, AsyncValue<List<UserListModel>>>(UserListsNotifier.new);

final pinnedListsProvider = Provider<List<UserListModel>>((ref) {
  final notifier = ref.watch(userListsProvider.notifier);
  return notifier.pinnedLists;
});

final listItemsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, listId) async {
  final supabase = ref.watch(supabaseServiceProvider);
  try {
    final response = await supabase.listItems
        .select('*, media(id, title, poster_path, media_type)')
        .eq('list_id', listId)
        .order('sort_order', ascending: true);
    return (response as List<dynamic>).cast<Map<String, dynamic>>();
  } catch (_) {
    return [];
  }
});

class _ListsSearchNotifier extends Notifier<String> {
  @override
  String build() => '';
}

final listsSearchProvider = NotifierProvider<_ListsSearchNotifier, String>(_ListsSearchNotifier.new);

final allListItemsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.watch(supabaseServiceProvider);
  final userId = ref.watch(authServiceProvider).userId;
  try {
    final listIdsResponse = await supabase.userLists
        .select('id')
        .eq('user_id', userId);
    final listIds = (listIdsResponse as List<dynamic>).map((j) => j['id'] as String).toList();
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
  } catch (_) {
    return [];
  }
});

final totalTitlesProvider = Provider<int>((ref) {
  final lists = ref.watch(userListsProvider).value ?? [];
  return lists.fold(0, (sum, l) => sum + l.itemCount);
});

final listCategoriesProvider = FutureProvider.family<List<String>, String>((ref, listId) async {
  final items = await ref.watch(listItemsProvider(listId).future);
  final categories = items.map((item) {
    final mediaData = item['media'] as Map<String, dynamic>?;
    return mediaData?['media_type'] as String? ?? item['media_type'] as String? ?? 'unknown';
  }).toSet();
  final ordered = <String>[];
  if (categories.contains('tv')) ordered.add('TV Shows');
  if (categories.contains('movie')) ordered.add('Movies');
  if (categories.contains('anime')) ordered.add('Anime');
  ordered.addAll(categories.where((c) => c != 'tv' && c != 'movie' && c != 'anime').map((c) => c[0].toUpperCase() + c.substring(1)));
  return ordered;
});

final mediaListMembershipProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, mediaId) async {
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
      final matchingList = userLists.where((l) => l['id'] == listId).firstOrNull;
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
