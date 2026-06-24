import 'package:flutter/material.dart';

import '../../core/models/media_enums.dart';
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
    final cardWidth = featured ? 200.0 : 140.0;
    final cardHeight = featured ? 300.0 : 210.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 16, end: 16, bottom: 12),
          child: SectionHeader(
            title: title,
            actionLabel: onSeeAll != null ? 'See All' : null,
            onAction: onSeeAll,
          ),
        ),
        SizedBox(
          height: cardHeight + 32,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsetsDirectional.only(start: 12, end: 12),
            itemCount: items.length,
            itemExtent: cardWidth + 8,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsetsDirectional.only(start: 4, end: 4),
                child: MediaCard(
                  id: item.id,
                  title: item.title,
                  posterUrl: item.posterUrl,
                  voteAverage: item.voteAverage,
                  mediaType: item.mediaType,
                  onTap: item.onTap,
                  width: cardWidth,
                  height: cardHeight,
                  heroTag: item.heroTag,
                ),
              );
            },
          ),
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
