import 'package:flutter/material.dart';

import '../../core/models/media_enums.dart';
import '../constants/dimensions.dart';
import 'horizontal_carousel.dart';
import 'media_card.dart';
import 'section_header.dart';

class MediaRow extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final List<MediaRowItem> items;
  final bool featured;

  const MediaRow({
    super.key,
    required this.title,
    this.onSeeAll,
    required this.items,
    this.featured = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = featured ? Spacing.posterWidthLg : Spacing.posterWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: Spacing.lg, end: Spacing.lg, bottom: Spacing.md),
          child: SectionHeader(
            title: title,
            actionLabel: onSeeAll != null ? 'See All' : null,
            onAction: onSeeAll,
          ),
        ),
        HorizontalCarousel(
          height: cardWidth * 1.5 + Spacing.xxl,
          padding: EdgeInsetsDirectional.only(start: Spacing.md, end: Spacing.md),
          itemExtent: cardWidth + Spacing.sm,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Padding(
              padding: EdgeInsetsDirectional.only(start: Spacing.xs, end: Spacing.xs),
              child: MediaCard(
                id: item.id,
                title: item.title,
                posterUrl: item.posterUrl,
                voteAverage: item.voteAverage,
                mediaType: item.mediaType,
                onTap: item.onTap,
                width: cardWidth,
                heroTag: item.heroTag,
              ),
            );
          },
        ),
      ],
    );
  }
}

class MediaRowItem {
  final int id;
  final String title;
  final String? posterUrl;
  final double? voteAverage;
  final MediaType? mediaType;
  final VoidCallback? onTap;
  final String? heroTag;

  const MediaRowItem({
    required this.id,
    required this.title,
    this.posterUrl,
    this.voteAverage,
    this.mediaType,
    this.onTap,
    this.heroTag,
  });
}
