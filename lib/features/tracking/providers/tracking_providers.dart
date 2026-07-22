import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postgrest/postgrest.dart';
import '../../../core/models/media_enums.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/supabase_service.dart';

import '../../../models/user_media_model.dart';
import '../../../models/media_model.dart';

class _TrackingStatusFilterNotifier extends Notifier<WatchStatus> {
  @override
  WatchStatus build() => WatchStatus.watching;
}

final trackingStatusFilterProvider = NotifierProvider<_TrackingStatusFilterNotifier, WatchStatus>(_TrackingStatusFilterNotifier.new);

class UserMediaNotifier extends Notifier<AsyncValue<List<UserMediaModel>>> {
  late final SupabaseService _supabase;
  late final String _userId;

  @override
  AsyncValue<List<UserMediaModel>> build() {
    _supabase = ref.read(supabaseServiceProvider);
    _userId = ref.read(authServiceProvider).userId;
    _load();
    return const AsyncValue.loading();
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
    WatchStatus status = WatchStatus.planToWatch,
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
    final previousState = List<UserMediaModel>.from(list);
    state = AsyncValue.data(list.where((m) => m.id != media.id).toList());
    try {
      await _supabase.userMedia.delete().eq('id', media.id);
    } catch (e) {
      debugPrint('Failed to delete user media: $e');
      state = AsyncValue.data(previousState);
    }
  }

  Future<void> _save(UserMediaModel media, {bool retried = false}) async {
    final list = state.value ?? [];
    final previousState = List<UserMediaModel>.from(list);
    final index = list.indexWhere((m) => m.id == media.id);
    if (index >= 0) {
      list[index] = media;
    } else {
      list.add(media);
    }
    state = AsyncValue.data(List.from(list));
    try {
      await _supabase.userMedia.upsert(media.toJson());
    } catch (e) {
      if (!retried) {
        debugPrint('Upsert failed, trying insert: $e');
        try {
          await _supabase.userMedia.insert(media.toJson());
        } catch (_) {}
      }
      if (e is PostgrestException && e.code == '42501') {
        debugPrint('Permission denied, rolling back: $e');
        state = AsyncValue.data(previousState);
      } else {
        debugPrint('Sync failed, keeping local state: $e');
      }
    }
  }
}

final userMediaProvider = NotifierProvider<UserMediaNotifier, AsyncValue<List<UserMediaModel>>>(UserMediaNotifier.new);

final userMediaByStatusProvider = Provider.family<List<UserMediaModel>, WatchStatus>((ref, status) {
  final mediaAsync = ref.watch(userMediaProvider);
  return mediaAsync.when(
    data: (list) => list.where((m) => m.status == status).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

final trackingStatsProvider = Provider<Map<String, int>>((ref) {
  final mediaAsync = ref.watch(userMediaProvider);
  return mediaAsync.when(
    data: (list) {
      final watched = list.where((m) =>
          m.status == WatchStatus.completed || m.status == WatchStatus.watching).toList();
      final totalWatched = watched.where((m) => m.status == WatchStatus.completed).length;
      final totalEpisodes = watched.fold<int>(0, (sum, m) => sum + m.episodeProgress);
      return {
        'totalWatched': totalWatched,
        'totalEpisodes': totalEpisodes,
        'totalHours': totalEpisodes ~/ 2,
      };
    },
    loading: () => const {'totalWatched': 0, 'totalEpisodes': 0, 'totalHours': 0},
    error: (_, __) => const {'totalWatched': 0, 'totalEpisodes': 0, 'totalHours': 0},
  );
});

final recentlyUpdatedProvider = Provider<List<UserMediaModel>>((ref) {
  final mediaAsync = ref.watch(userMediaProvider);
  return mediaAsync.when(
    data: (list) {
      final sorted = List<UserMediaModel>.from(list);
      sorted.sort((a, b) {
        final aTime = a.updatedAt ?? a.createdAt ?? DateTime(2000);
        final bTime = b.updatedAt ?? b.createdAt ?? DateTime(2000);
        return bTime.compareTo(aTime);
      });
      return sorted.take(10).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
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
