import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/media_enums.dart';
import '../../../core/models/recommendation_models.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/tmdb_service.dart';
import '../../../core/shared/media_card.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/media_model.dart';

/// Displays a single recommendation result as a [MediaCard] with an optional
/// explanation label beneath it.
class RecommendationCard extends ConsumerWidget {
  const RecommendationCard({
    super.key,
    required this.scoredMedia,
    required this.onTap,
  });

  final ScoredMedia scoredMedia;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaAsync = ref.watch(_mediaByIdProvider(scoredMedia.mediaId));
    final l10n = context.l10n;
    final localizedReason = _localizedReason(scoredMedia.reason, l10n);

    return SizedBox(
      width: 150,
      child: mediaAsync.when(
        data: (media) {
          if (media == null) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MediaCard(
                id: media.id,
                title: media.title,
                posterUrl: media.posterPath != null
                    ? 'https://image.tmdb.org/t/p/w342${media.posterPath}'
                    : null,
                voteAverage: media.voteAverage,
                mediaType: media.mediaType,
                width: 150,
                onTap: onTap,
              ),
              if (scoredMedia.reason != null)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Semantics(
                      label: context.l10n.recommendationReason(localizedReason),
                      child: Text(
                        localizedReason,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        error: (_, _) => const SizedBox.shrink(),
      ),
    );
  }
}

String _localizedReason(String? reason, AppLocalizations l10n) {
  if (reason == null) return '';
  if (reason.startsWith('Because you enjoy ')) {
    final genre = reason.replaceFirst('Because you enjoy ', '');
    return l10n.becauseYouEnjoyGenre(genre);
  }
  switch (reason) {
    case 'Popular trending':
      return l10n.popularTrending;
    case 'Similar to what you\'ve saved':
      return l10n.similarToSaved;
    case 'Similar to your favorites':
      return l10n.similarToFavorites;
    case 'Users with similar taste enjoyed this':
      return l10n.usersLikeYouEnjoyed;
    case 'Recently released':
      return l10n.recentlyReleased;
    case 'Top rated':
      return l10n.topRated;
    case 'Hidden gem — highly rated but undiscovered':
      return l10n.hiddenGem;
    case 'Critically acclaimed':
      return l10n.criticallyAcclaimed;
    default:
      return reason;
  }
}

/// Fetches a [MediaModel] by its integer ID via Supabase or TMDB API.
/// Falls back to TMDB when Supabase media table is unavailable.
final _mediaByIdProvider = FutureProvider.family<MediaModel?, int>((ref, id) async {
  final supabase = ref.watch(supabaseServiceProvider);
  final tmdb = TmdbService.instance;
  try {
    final Map<String, dynamic> data = await supabase.media
        .select('id, title, poster_path, vote_average, media_type')
        .eq('id', id)
        .single();
    return MediaModel(
      id: data['id'] as int,
      title: data['title'] as String? ?? '',
      posterPath: data['poster_path'] as String?,
      voteAverage: (data['vote_average'] as num?)?.toDouble(),
      mediaType: _parseMediaType(data['media_type'] as String?),
    );
  } catch (e) {
    try {
      final Map<String, dynamic> data = await tmdb.movieDetails(id);
      return MediaModel(
        id: data['id'] as int,
        title: data['title'] as String? ?? '',
        posterPath: data['poster_path'] as String?,
        voteAverage: (data['vote_average'] as num?)?.toDouble(),
        mediaType: MediaType.movie,
      );
    } catch (movieError) {
      try {
        final Map<String, dynamic> data = await tmdb.tvDetails(id);
        return MediaModel(
          id: data['id'] as int,
          title: data['name'] as String? ?? '',
          posterPath: data['poster_path'] as String?,
          voteAverage: (data['vote_average'] as num?)?.toDouble(),
          mediaType: MediaType.tv,
        );
      } catch (tmdbError) {
        debugPrint('Failed to fetch media $id from both Supabase and TMDB: $tmdbError');
        return null;
      }
    }
  }
});

MediaType _parseMediaType(String? raw) {
  if (raw == null) return MediaType.movie;
  if (raw == 'tv' || raw == 'TV') return MediaType.tv;
  return MediaType.movie;
}