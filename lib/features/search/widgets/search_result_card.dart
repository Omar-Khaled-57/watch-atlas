import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/string_extensions.dart';
import '../../../models/media_model.dart';

class SearchResultCard extends ConsumerWidget {
  final MediaModel media;
  final VoidCallback? onTap;

  const SearchResultCard({
    super.key,
    required this.media,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posterUrl = media.posterPath != null
        ? '${AppConstants.tmdbImageBaseUrl}/w342${media.posterPath}'
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: posterUrl != null
                  ? CachedNetworkImage(
                      imageUrl: posterUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: context.colorScheme.surfaceContainerHighest,
                        highlightColor: context.colorScheme.surface,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (_, __, ___) => Center(
                        child: Icon(
                          Icons.movie_outlined,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.movie_outlined,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    media.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      if (media.voteAverage != null) ...[
                        Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 2),
                        Text(
                          media.voteAverage!.toStringAsFixed(1),
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                      Text(
                        media.mediaType.name.capitalize(),
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
