import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../l10n/l10n.dart';
import '../widgets/detail_section_header.dart';
import '../../../core/shared/horizontal_carousel.dart';

/// Horizontal carousel of YouTube trailer thumbnails.
class TrailersSection extends StatelessWidget {
  final List<Map<String, dynamic>> trailers;

  const TrailersSection({super.key, required this.trailers});

  @override
  Widget build(BuildContext context) {
    if (trailers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
          child: DetailSectionHeader(title: context.l10n.trailers),
        ),
        SizedBox(height: Spacing.md),
        HorizontalCarousel(
          height: 200,
          itemCount: trailers.length,
          separatorWidth: Spacing.md,
          padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
          itemBuilder: (context, index) {
            final trailer = trailers[index];
            final key = trailer['key'] as String? ?? '';
            return Semantics(
              button: true,
              label: 'Play trailer ${index + 1}',
              child: GestureDetector(
                onTap: () => launchUrl(
                  Uri.parse('https://www.youtube.com/watch?v=$key'),
                ),
                child: Container(
                  width: 320,
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadiusDirectional.all(
                      Radius.circular(Spacing.cardRadiusMd),
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        'https://img.youtube.com/vi/$key/maxresdefault.jpg',
                      ),
                      fit: BoxFit.cover,
                      onError: (_, _) {},
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: EdgeInsetsDirectional.all(Spacing.lg),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
