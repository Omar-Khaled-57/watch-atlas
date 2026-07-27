import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/models/media_enums.dart';
import '../../../models/media_model.dart';
import '../widgets/detail_section_header.dart';
import '../../../core/shared/horizontal_carousel.dart';

/// Horizontal carousel of recommended or similar media items.
class MediaRowSection extends StatelessWidget {
  final String title;
  final List items;

  const MediaRowSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
          child: DetailSectionHeader(title: title),
        ),
        SizedBox(height: Spacing.md),
        HorizontalCarousel(
          height: 210,
          itemCount: items.length,
          separatorWidth: Spacing.sm,
          padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
          itemBuilder: (context, index) {
            final item = items[index] as MediaModel;
            final mediaTypeStr = item.mediaType == MediaType.tv
                ? 'tv'
                : 'movie';
            return SizedBox(
              width: AppConstants.posterWidth,
              child: Semantics(
                button: true,
                label: item.title,
                child: GestureDetector(
                  onTap: () =>
                      context.navigateToMedia(mediaTypeStr, item.id.toString()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadiusDirectional.all(
                            Radius.circular(Spacing.cardRadiusSm),
                          ),
                          child: item.posterPath != null
                              ? CachedNetworkImage(
                                  imageUrl:
                                      '${AppConstants.tmdbImageBaseUrl}/w342${item.posterPath}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  placeholder: (_, _) =>
                                      _itemPlaceholder(context),
                                  errorWidget: (_, _, _) =>
                                      _itemPlaceholder(context),
                                )
                              : _itemPlaceholder(context),
                        ),
                      ),
                      SizedBox(height: Spacing.xs),
                      Text(
                        item.title,
                        style: context.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _itemPlaceholder(BuildContext context) {
    return Container(
      color: context.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.movie_outlined,
        size: 32,
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
