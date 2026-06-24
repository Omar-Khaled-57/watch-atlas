import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/media_enums.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/supabase_service.dart';
import '../../../models/user_list_model.dart';

class UserListsNotifier extends StateNotifier<AsyncValue<List<UserListModel>>> {
  final SupabaseService _supabase;
  final String _userId;

  UserListsNotifier(this._supabase, this._userId) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final response = await _supabase.userLists
          .select()
          .eq('user_id', _userId)
          .order('created_at', ascending: false);
      final list = (response as List<dynamic>)
          .map((json) => UserListModel.fromJson(json as Map<String, dynamic>))
          .toList();
      state = AsyncValue.data(list);
    } catch (e) {
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
      await _supabase.userLists.insert(list.toJson());
    } catch (_) {}
  }

  Future<void> updateList(UserListModel updated) async {
    final current = state.value ?? [];
    final index = current.indexWhere((l) => l.id == updated.id);
    if (index >= 0) {
      current[index] = updated;
      state = AsyncValue.data(List.from(current));
    }
    try {
      await _supabase.userLists.upsert(updated.toJson()).eq('id', updated.id);
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

  Future<void> addItemToList(String listId, int mediaId, MediaType mediaType, {String? note}) async {
    try {
      await _supabase.listItems.insert({
        'list_id': listId,
        'media_id': mediaId,
        'media_type': mediaType.name,
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
    } catch (_) {}
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
    } catch (_) {}
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

final userListsProvider = StateNotifierProvider<UserListsNotifier, AsyncValue<List<UserListModel>>>((ref) {
  final supabase = ref.watch(supabaseServiceProvider);
  final userId = ref.watch(authServiceProvider).userId;
  return UserListsNotifier(supabase, userId);
});

final pinnedListsProvider = Provider<List<UserListModel>>((ref) {
  final notifier = ref.watch(userListsProvider.notifier);
  return notifier.pinnedLists;
});

final listItemsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, listId) async {
  final supabase = ref.watch(supabaseServiceProvider);
  try {
    final response = await supabase.listItems
        .select()
        .eq('list_id', listId)
        .order('sort_order', ascending: true);
    return (response as List<dynamic>).cast<Map<String, dynamic>>();
  } catch (_) {
    return [];
  }
});
