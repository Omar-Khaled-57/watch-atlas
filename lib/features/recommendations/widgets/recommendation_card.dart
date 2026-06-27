import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/media_enums.dart';
import '../../../core/models/recommendation_models.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/shared/media_card.dart';
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
                      label: context.l10n.recommendationReason(scoredMedia.reason),
                      child: Text(
                        scoredMedia.reason!,
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

/// Fetches a [MediaModel] by its integer ID via Supabase (cached per ID).
final _mediaByIdProvider = FutureProvider.family<MediaModel?, int>((ref, id) async {
  final supabase = ref.watch(supabaseServiceProvider);
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
    debugPrint('Failed to fetch media $id: $e');
    return null;
  }
});

MediaType _parseMediaType(String? raw) {
  if (raw == null) return MediaType.movie;
  if (raw == 'tv' || raw == 'TV') return MediaType.tv;
  return MediaType.movie;
}