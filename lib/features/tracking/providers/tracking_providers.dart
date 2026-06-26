import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/media_enums.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/supabase_service.dart';

import '../../../models/user_media_model.dart';
import '../../../models/media_model.dart';

final trackingStatusFilterProvider = StateProvider<WatchStatus>((ref) => WatchStatus.watching);

class UserMediaNotifier extends StateNotifier<AsyncValue<List<UserMediaModel>>> {
  final SupabaseService _supabase;
  final String _userId;

  UserMediaNotifier(this._supabase, this._userId)
    : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final response = await _supabase.userMedia
          .select()
          .eq('user_id', _userId)
          .order('updated_at', ascending: false);
      final list = (response as List<dynamic>)
          .map((json) => UserMediaModel.fromJson(json as Map<String, dynamic>))
          .toList();
      state = AsyncValue.data(list);
    } catch (e) {
      debugPrint('Failed to load user media: $e');
      state = AsyncValue.data([]);
    }
  }

  List<UserMediaModel> byStatus(WatchStatus status) {
    return state.value?.where((m) => m.status == status).toList() ?? [];
  }

  List<UserMediaModel> get recentlyUpdated {
    final all = List<UserMediaModel>.from(state.value ?? []);
    all.sort((a, b) {
      final aTime = a.updatedAt ?? a.createdAt ?? DateTime(2000);
      final bTime = b.updatedAt ?? b.createdAt ?? DateTime(2000);
      return bTime.compareTo(aTime);
    });
    return all.take(10).toList();
  }

  int get totalWatched {
    return state.value?.where((m) => m.status == WatchStatus.completed).length ?? 0;
  }

  int get totalEpisodesWatched {
    final list = state.value;
    if (list == null) return 0;
    return list.fold(0, (int sum, m) => sum + m.episodeProgress);
  }

  int get totalHours {
    final eps = totalEpisodesWatched;
    return eps ~/ 2;
  }

  Future<void> updateStatus(UserMediaModel media, WatchStatus newStatus) async {
    final updated = media.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
      startedAt: newStatus == WatchStatus.watching
          ? (media.startedAt ?? DateTime.now())
          : media.startedAt,
      completedAt: newStatus == WatchStatus.completed ? DateTime.now() : null,
    );
    await _save(updated);
  }

  Future<void> updateProgress(UserMediaModel media, {int? episodes, int? seasons}) async {
    final updated = media.copyWith(
      episodeProgress: episodes ?? media.episodeProgress,
      seasonProgress: seasons ?? media.seasonProgress,
      updatedAt: DateTime.now(),
      completedAt: media.totalEpisodes > 0 &&
              (episodes ?? media.episodeProgress) >= media.totalEpisodes
          ? DateTime.now()
          : media.completedAt,
    );
    await _save(updated);
  }

  Future<void> addRating(UserMediaModel media, double rating) async {
    final updated = media.copyWith(
      userRating: rating,
      updatedAt: DateTime.now(),
    );
    await _save(updated);
  }

  Future<void> addMedia({
    required int mediaId,
    required MediaType mediaType,
    required WatchStatus status,
    int totalEpisodes = 0,
  }) async {
    final now = DateTime.now();
    final userMedia = UserMediaModel(
      id: '${_userId}_$mediaId',
      mediaId: mediaId,
      userId: _userId,
      mediaType: mediaType,
      status: status,
      totalEpisodes: totalEpisodes,
      createdAt: now,
      updatedAt: now,
      startedAt: status == WatchStatus.watching ? now : null,
    );
    await _save(userMedia);
  }

  Future<void> removeMedia(UserMediaModel media) async {
    final list = state.value ?? [];
    state = AsyncValue.data(list.where((m) => m.id != media.id).toList());
    try {
      await _supabase.userMedia.delete().eq('id', media.id);
    } catch (e) {
      debugPrint('Failed to delete user media: $e');
    }
  }

  Future<void> _save(UserMediaModel media) async {
    final list = state.value ?? [];
    final index = list.indexWhere((m) => m.id == media.id);
    if (index >= 0) {
      list[index] = media;
    } else {
      list.add(media);
    }
    state = AsyncValue.data(List.from(list));
    try {
      await _supabase.userMedia.upsert(media.toJson()).eq('id', media.id);
    } catch (e) {
      debugPrint('Upsert failed, trying insert: $e');
      try {
        await _supabase.userMedia.insert(media.toJson());
      } catch (e2) {
        debugPrint('Insert also failed: $e2');
      }
    }
  }
}

final userMediaProvider = StateNotifierProvider<UserMediaNotifier, AsyncValue<List<UserMediaModel>>>((ref) {
  final supabase = ref.watch(supabaseServiceProvider);
  final userId = ref.watch(authServiceProvider).userId;
  return UserMediaNotifier(supabase, userId);
});

final userMediaByStatusProvider = Provider.family<List<UserMediaModel>, WatchStatus>((ref, status) {
  final notifier = ref.watch(userMediaProvider.notifier);
  return notifier.byStatus(status);
});

final trackingStatsProvider = Provider<Map<String, int>>((ref) {
  final notifier = ref.watch(userMediaProvider.notifier);
  return {
    'totalWatched': notifier.totalWatched,
    'totalEpisodes': notifier.totalEpisodesWatched,
    'totalHours': notifier.totalHours,
  };
});

final recentlyUpdatedProvider = Provider<List<UserMediaModel>>((ref) {
  final notifier = ref.watch(userMediaProvider.notifier);
  return notifier.recentlyUpdated;
});

final mediaByIdProvider = FutureProvider.family<MediaModel?, ({int mediaId, MediaType mediaType})>(
    (ref, params) async {
  final tmdb = ref.watch(tmdbServiceProvider);
  try {
    final Map<String, dynamic> data;
    if (params.mediaType == MediaType.movie) {
      data = await tmdb.movieDetails(params.mediaId);
    } else {
      data = await tmdb.tvDetails(params.mediaId);
    }
    return MediaModel(
      id: data['id'] as int,
      mediaType: params.mediaType,
      title: data['title'] as String? ?? data['name'] as String? ?? '',
      posterPath: data['poster_path'] as String?,
      voteAverage: (data['vote_average'] as num?)?.toDouble(),
      totalEpisodes: (data['number_of_episodes'] as num?)?.toInt() ?? 0,
      totalSeasons: (data['number_of_seasons'] as num?)?.toInt() ?? 0,
    );
  } catch (e) {
    debugPrint('Failed to fetch media ${params.mediaId}: $e');
    return null;
  }
});
