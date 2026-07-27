import 'package:flutter/material.dart';
import '../../../core/constants/dimensions.dart';
import '../../../l10n/l10n.dart';
import '../widgets/cast_card.dart';
import '../widgets/detail_section_header.dart';
import '../../../core/shared/horizontal_carousel.dart';

/// Horizontal carousel of cast members from TMDB credits.
class CastSection extends StatelessWidget {
  final Map<String, dynamic> credits;

  const CastSection({super.key, required this.credits});

  @override
  Widget build(BuildContext context) {
    final cast = credits['cast'] as List<dynamic>? ?? [];
    if (cast.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
          child: DetailSectionHeader(title: context.l10n.cast),
        ),
        SizedBox(height: Spacing.md),
        HorizontalCarousel(
          height: 150,
          itemCount: cast.length,
          separatorWidth: Spacing.md,
          padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
          itemBuilder: (context, index) {
            final person = cast[index] as Map<String, dynamic>;
            return CastCard(
              name: person['name'] as String? ?? '',
              character: person['character'] as String?,
              profilePath: person['profile_path'] as String?,
            );
          },
        ),
      ],
    );
  }
}
