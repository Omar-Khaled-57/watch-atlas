import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../models/media_model.dart';

/// Star rating row with percentage badge for media details.
class RatingRow extends StatelessWidget {
  final MediaModel media;

  const RatingRow({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    if (media.voteAverage == null) return const SizedBox.shrink();
    final percentage = (media.voteAverage! / 10 * 100).toPercentage();

    return Semantics(
      label:
          'Rating: ${media.voteAverage!.toStringAsFixed(1)} out of 10, $percentage',
      child: Row(
        children: [
          ...List.generate(5, (i) {
            final filled = media.voteAverage! / 2 >= i + 1;
            final half = !filled && media.voteAverage! / 2 >= i + 0.5;
            return Icon(
              filled
                  ? Icons.star_rounded
                  : half
                  ? Icons.star_half_rounded
                  : Icons.star_outline_rounded,
              color: AppColors.star,
              size: 22,
            );
          }),
          SizedBox(width: Spacing.sm),
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: Spacing.sm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: context.colorScheme.secondaryContainer,
              borderRadius: BorderRadiusDirectional.all(
                Radius.circular(Spacing.chipRadius),
              ),
            ),
            child: Text(
              percentage,
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
