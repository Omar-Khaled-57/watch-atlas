import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/media_enums.dart';
import '../../../core/providers/app_providers.dart';
import '../../../models/media_model.dart';
import '../../../models/user_media_model.dart';

final allUserMediaProvider = FutureProvider<List<UserMediaModel>>((ref) async {
  final supabase = ref.watch(supabaseServiceProvider);
  final auth = ref.watch(authServiceProvider);
  if (auth.userId.isEmpty) return [];
  final response = await supabase.userMedia
      .select()
      .eq('user_id', auth.userId)
      .order('updated_at', ascending: false);
  return (response as List<dynamic>)
      .map((json) => UserMediaModel.fromJson(json as Map<String, dynamic>))
      .toList();
});

final allMediaProvider = FutureProvider<List<MediaModel>>((ref) async {
  final supabase = ref.watch(supabaseServiceProvider);
  final response = await supabase.media.select().limit(100);
  return (response as List<dynamic>)
      .map((json) => MediaModel.fromJson(json as Map<String, dynamic>))
      .toList();
});

final watchStatisticsProvider = FutureProvider<WatchStatistics>((ref) async {
  final userMedia = await ref.watch(allUserMediaProvider.future);
  final mediaList = await ref.watch(allMediaProvider.future);
  return WatchStatistics.compute(userMedia, mediaList);
});

final genreDistributionProvider = FutureProvider<List<DistributionItem>>((ref) async {
  final mediaList = await ref.watch(allMediaProvider.future);
  final userMedia = await ref.watch(allUserMediaProvider.future);
  final watchedIds = userMedia
      .where((u) => u.status == WatchStatus.completed || u.status == WatchStatus.watching)
      .map((u) => u.mediaId)
      .toSet();
  final watchedMedia = mediaList.where((m) => watchedIds.contains(m.id)).toList();
  final counts = <String, int>{};
  for (final media in watchedMedia) {
    if (media.genres != null) {
      for (final genre in media.genres!) {
        counts[genre] = (counts[genre] ?? 0) + 1;
      }
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
  final mediaList = await ref.watch(allMediaProvider.future);
  final userMedia = await ref.watch(allUserMediaProvider.future);
  final watchedIds = userMedia
      .where((u) => u.status == WatchStatus.completed || u.status == WatchStatus.watching)
      .map((u) => u.mediaId)
      .toSet();
  final watchedMedia = mediaList.where((m) => watchedIds.contains(m.id)).toList();
  final counts = <String, int>{};
  for (final media in watchedMedia) {
    if (media.countries != null) {
      for (final country in media.countries!) {
        counts[country] = (counts[country] ?? 0) + 1;
      }
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
  final mediaList = await ref.watch(allMediaProvider.future);
  final userMedia = await ref.watch(allUserMediaProvider.future);
  final watchedIds = userMedia
      .where((u) => u.status == WatchStatus.completed)
      .map((u) => u.mediaId)
      .toSet();
  final watchedMedia = mediaList.where((m) => watchedIds.contains(m.id)).toList();
  final decadeCounts = <String, int>{};
  for (final media in watchedMedia) {
    if (media.releaseDate != null) {
      final decade = '${(media.releaseDate!.year ~/ 10) * 10}s';
      decadeCounts[decade] = (decadeCounts[decade] ?? 0) + 1;
    }
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

  factory WatchStatistics.compute(List<UserMediaModel> userMedia, List<MediaModel> mediaList) {
    final watched = userMedia.where((u) =>
        u.status == WatchStatus.completed || u.status == WatchStatus.watching).toList();
    final mediaById = {for (final m in mediaList) m.id: m};

    int totalEpisodes = 0;
    int totalMinutes = 0;
    double totalRating = 0;
    int ratedCount = 0;

    for (final um in watched) {
      totalEpisodes += um.episodeProgress;
      final media = mediaById[um.mediaId];
      if (media?.runtime != null && um.episodeProgress > 0) {
        totalMinutes += (media!.runtime! * um.episodeProgress) ~/ (media.totalEpisodes > 0 ? media.totalEpisodes : 1);
      }
      if (um.userRating != null) {
        totalRating += um.userRating!;
        ratedCount++;
      }
    }

    return WatchStatistics(
      totalWatched: watched.length,
      totalEpisodes: totalEpisodes,
      totalHours: totalMinutes ~/ 60,
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
