import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/media_enums.dart';
import '../../../core/providers/app_providers.dart';
import '../../../models/media_model.dart';
import '../../../models/user_media_model.dart';

final allUserMediaProvider = FutureProvider<List<UserMediaModel>>((ref) async {
  final supabase = ref.watch(supabaseServiceProvider);
  final auth = ref.watch(authServiceProvider);
  if (auth.userId.isEmpty) return [];
  try {
    final response = await supabase.userMedia
        .select()
        .eq('user_id', auth.userId)
        .order('updated_at', ascending: false);
    return (response as List<dynamic>)
        .map((json) => UserMediaModel.fromJson(json as Map<String, dynamic>))
        .toList();
  } catch (e) {
    debugPrint('allUserMediaProvider: $e');
    return [];
  }
});

final watchedMediaDetailsProvider = FutureProvider<Map<int, MediaModel>>((ref) async {
  final userMedia = await ref.watch(allUserMediaProvider.future);
  final tmdb = ref.watch(tmdbServiceProvider);
  final result = <int, MediaModel>{};
  for (final um in userMedia) {
    if (result.containsKey(um.mediaId)) continue;
    try {
      final Map<String, dynamic> data;
      if (um.mediaType == MediaType.movie) {
        data = await tmdb.movieDetails(um.mediaId);
      } else {
        data = await tmdb.tvDetails(um.mediaId);
      }
      final genres = (data['genres'] as List<dynamic>?)
          ?.map((g) => g['name'] as String)
          .toList();
      result[um.mediaId] = MediaModel(
        id: data['id'] as int,
        mediaType: um.mediaType,
        title: data['title'] as String? ?? data['name'] as String? ?? '',
        genres: genres,
        countries: data['origin_country'] as List<String>?,
        releaseDate: _parseDate(data['release_date'] as String? ?? data['first_air_date'] as String?),
      );
    } catch (e) {
      debugPrint('Failed to fetch media ${um.mediaId} for analytics: $e');
    }
  }
  return result;
});

DateTime? _parseDate(String? dateStr) {
  if (dateStr == null) return null;
  return DateTime.tryParse(dateStr);
}

final genreDistributionProvider = FutureProvider<List<DistributionItem>>((ref) async {
  final mediaMap = await ref.watch(watchedMediaDetailsProvider.future);
  final userMedia = await ref.watch(allUserMediaProvider.future);
  final counts = <String, int>{};
  for (final um in userMedia) {
    if (um.status != WatchStatus.completed && um.status != WatchStatus.watching) continue;
    final genres = mediaMap[um.mediaId]?.genres;
    if (genres == null) continue;
    for (final genre in genres) {
      counts[genre] = (counts[genre] ?? 0) + 1;
    }
  }
  final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  final total = sorted.fold(0, (sum, e) => sum + e.value);
  return sorted.map((e) => DistributionItem(
    label: e.key,
    count: e.value,
    percentage: total > 0 ? e.value / total : 0.0,
  )).toList();
});

final countryDistributionProvider = FutureProvider<List<DistributionItem>>((ref) async {
  final mediaMap = await ref.watch(watchedMediaDetailsProvider.future);
  final userMedia = await ref.watch(allUserMediaProvider.future);
  final counts = <String, int>{};
  for (final um in userMedia) {
    if (um.status != WatchStatus.completed && um.status != WatchStatus.watching) continue;
    final countries = mediaMap[um.mediaId]?.countries;
    if (countries == null) continue;
    for (final country in countries) {
      counts[country] = (counts[country] ?? 0) + 1;
    }
  }
  final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  final total = sorted.fold(0, (sum, e) => sum + e.value);
  return sorted.map((e) => DistributionItem(
    label: e.key,
    count: e.value,
    percentage: total > 0 ? e.value / total : 0.0,
  )).toList();
});

final watchStatisticsProvider = FutureProvider<WatchStatistics>((ref) async {
  final userMedia = await ref.watch(allUserMediaProvider.future);
  return WatchStatistics.compute(userMedia);
});

final weeklyActivityProvider = FutureProvider<List<ActivityDay>>((ref) async {
  final userMedia = await ref.watch(allUserMediaProvider.future);
  final now = DateTime.now();
  final weekAgo = now.subtract(const Duration(days: 6));
  final dayCounts = <String, int>{};
  for (int i = 0; i < 7; i++) {
    final day = weekAgo.add(Duration(days: i));
    final key = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    dayCounts[key] = 0;
  }
  for (final um in userMedia) {
    if (um.completedAt != null && um.completedAt!.isAfter(weekAgo.subtract(const Duration(days: 1)))) {
      final key = '${um.completedAt!.year}-${um.completedAt!.month.toString().padLeft(2, '0')}-${um.completedAt!.day.toString().padLeft(2, '0')}';
      if (dayCounts.containsKey(key)) {
        dayCounts[key] = (dayCounts[key] ?? 0) + 1;
      }
    }
    if (um.updatedAt != null && um.updatedAt!.isAfter(weekAgo.subtract(const Duration(days: 1)))) {
      final key = '${um.updatedAt!.year}-${um.updatedAt!.month.toString().padLeft(2, '0')}-${um.updatedAt!.day.toString().padLeft(2, '0')}';
      if (dayCounts.containsKey(key)) {
        dayCounts[key] = (dayCounts[key] ?? 0) + 1;
      }
    }
  }
  return dayCounts.entries.map((e) => ActivityDay(date: e.key, count: e.value)).toList();
});

final monthlyActivityProvider = FutureProvider<List<ActivityMonth>>((ref) async {
  final userMedia = await ref.watch(allUserMediaProvider.future);
  final now = DateTime.now();
  final monthCounts = <String, int>{};
  for (int i = 5; i >= 0; i--) {
    final month = DateTime(now.year, now.month - i, 1);
    final key = '${month.year}-${month.month.toString().padLeft(2, '0')}';
    monthCounts[key] = 0;
  }
  for (final um in userMedia) {
    if (um.completedAt != null) {
      final key = '${um.completedAt!.year}-${um.completedAt!.month.toString().padLeft(2, '0')}';
      if (monthCounts.containsKey(key)) {
        monthCounts[key] = (monthCounts[key] ?? 0) + 1;
      }
    }
  }
  return monthCounts.entries.map((e) => ActivityMonth(month: e.key, count: e.value)).toList();
});

final yearlyActivityProvider = FutureProvider<List<ActivityYear>>((ref) async {
  final userMedia = await ref.watch(allUserMediaProvider.future);
  final yearCounts = <int, int>{};
  for (final um in userMedia) {
    if (um.completedAt != null) {
      yearCounts[um.completedAt!.year] = (yearCounts[um.completedAt!.year] ?? 0) + 1;
    }
  }
  final sorted = yearCounts.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  return sorted.map((e) => ActivityYear(year: e.key, count: e.value)).toList();
});

final favoriteGenreProvider = FutureProvider<DistributionItem?>((ref) async {
  final genres = await ref.watch(genreDistributionProvider.future);
  if (genres.isEmpty) return null;
  return genres.first;
});

final favoriteCountryProvider = FutureProvider<DistributionItem?>((ref) async {
  final countries = await ref.watch(countryDistributionProvider.future);
  if (countries.isEmpty) return null;
  return countries.first;
});

final mostWatchedDecadeProvider = FutureProvider<String?>((ref) async {
  final mediaMap = await ref.watch(watchedMediaDetailsProvider.future);
  final userMedia = await ref.watch(allUserMediaProvider.future);
  final decadeCounts = <String, int>{};
  for (final um in userMedia) {
    if (um.status != WatchStatus.completed) continue;
    final media = mediaMap[um.mediaId];
    final releaseDate = media?.releaseDate;
    if (releaseDate == null) continue;
    final decade = '${(releaseDate.year ~/ 10) * 10}s';
    decadeCounts[decade] = (decadeCounts[decade] ?? 0) + 1;
  }
  if (decadeCounts.isEmpty) return null;
  return decadeCounts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
});

final ratingDistributionProvider = FutureProvider<List<RatingBucket>>((ref) async {
  final userMedia = await ref.watch(allUserMediaProvider.future);
  final rated = userMedia.where((u) => u.userRating != null).toList();
  final buckets = <String, List<double>>{
    '1-2': [],
    '3-4': [],
    '5-6': [],
    '7-8': [],
    '9-10': [],
  };
  for (final um in rated) {
    final r = um.userRating!;
    if (r <= 2) buckets['1-2']!.add(r);
    else if (r <= 4) buckets['3-4']!.add(r);
    else if (r <= 6) buckets['5-6']!.add(r);
    else if (r <= 8) buckets['7-8']!.add(r);
    else buckets['9-10']!.add(r);
  }
  return buckets.entries.map((e) => RatingBucket(
    label: e.key,
    count: e.value.length,
    total: rated.length,
  )).toList();
});

class WatchStatistics {
  final int totalWatched;
  final int totalEpisodes;
  final int totalHours;
  final double averageRating;

  WatchStatistics({
    required this.totalWatched,
    required this.totalEpisodes,
    required this.totalHours,
    required this.averageRating,
  });

  factory WatchStatistics.compute(List<UserMediaModel> userMedia) {
    final watched = userMedia.where((u) =>
        u.status == WatchStatus.completed || u.status == WatchStatus.watching).toList();

    int totalEpisodes = 0;
    double totalRating = 0;
    int ratedCount = 0;

    for (final um in watched) {
      totalEpisodes += um.episodeProgress;
      if (um.userRating != null) {
        totalRating += um.userRating!;
        ratedCount++;
      }
    }

    return WatchStatistics(
      totalWatched: watched.length,
      totalEpisodes: totalEpisodes,
      totalHours: totalEpisodes ~/ 2,
      averageRating: ratedCount > 0 ? totalRating / ratedCount : 0.0,
    );
  }
}

class DistributionItem {
  final String label;
  final int count;
  final double percentage;

  DistributionItem({
    required this.label,
    required this.count,
    required this.percentage,
  });
}

class ActivityDay {
  final String date;
  final int count;

  ActivityDay({required this.date, required this.count});
}

class ActivityMonth {
  final String month;
  final int count;

  ActivityMonth({required this.month, required this.count});
}

class ActivityYear {
  final int year;
  final int count;

  ActivityYear({required this.year, required this.count});
}

class RatingBucket {
  final String label;
  final int count;
  final int total;

  RatingBucket({required this.label, required this.count, required this.total});
}
