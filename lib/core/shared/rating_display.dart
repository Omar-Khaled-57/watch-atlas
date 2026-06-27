import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../../l10n/l10n.dart';

class RatingDisplay extends StatelessWidget {
  final double rating;
  final int? voteCount;
  final bool tappable;
  final double starSize;
  final bool showPercentage;

  const RatingDisplay({
    super.key,
    required this.rating,
    this.voteCount,
    this.tappable = false,
    this.starSize = 16,
    this.showPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (showPercentage) {
      return _PercentageScore(
        rating: rating,
        voteCount: voteCount,
        colorScheme: colorScheme,
        textTheme: textTheme,
      );
    }

    return _StarRating(
      rating: rating,
      voteCount: voteCount,
      tappable: tappable,
      starSize: starSize,
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
  }
}

class _StarRating extends StatelessWidget {
  final double rating;
  final int? voteCount;
  final bool tappable;
  final double starSize;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _StarRating({
    required this.rating,
    this.voteCount,
    required this.tappable,
    required this.starSize,
    required this.colorScheme,
    required this.textTheme,
  });

  int get _fullStars => rating.floor();
  bool get _hasHalfStar => rating - _fullStars >= 0.25 && rating - _fullStars < 0.75;
  bool get _hasFullerHalf => rating - _fullStars >= 0.75;

  @override
  Widget build(BuildContext context) {
    final effectiveStars = tappable ? 5 : (_hasFullerHalf ? _fullStars + 1 : _fullStars);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!tappable)
          ...List.generate(5, (index) {
            if (index < _fullStars) {
              return Icon(Icons.star_rounded, color: Colors.amber, size: starSize);
            } else if (index == _fullStars && _hasHalfStar) {
              return Icon(Icons.star_half_rounded, color: Colors.amber, size: starSize);
            }
            return Icon(Icons.star_outline_rounded, color: Colors.amber.withValues(alpha: 0.4), size: starSize);
          }),
        if (tappable)
          ...List.generate(5, (index) {
            return GestureDetector(
              onTap: () => _onStarTap(context, index + 1),
              child: Icon(
                index < _fullStars
                    ? Icons.star_rounded
                    : index == _fullStars && _hasHalfStar
                        ? Icons.star_half_rounded
                        : Icons.star_outline_rounded,
                color: Colors.amber,
                size: starSize + 8,
              ),
            );
          }),
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        if (voteCount != null) ...[
          const SizedBox(width: Spacing.xs),
          Text(
            '($voteCount)',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  void _onStarTap(BuildContext context, int stars) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.ratedStars(stars.toDouble())),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class _PercentageScore extends StatelessWidget {
  final double rating;
  final int? voteCount;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _PercentageScore({
    required this.rating,
    this.voteCount,
    required this.colorScheme,
    required this.textTheme,
  });

  Color get _scoreColor {
    if (rating >= 7) return const Color(0xFF21D07A);
    if (rating >= 5) return const Color(0xFFD2D531);
    return const Color(0xFFDB2360);
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (rating / 10 * 100).round();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 44,
          height: 44,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              CircularProgressIndicator(
                value: rating / 10,
                strokeWidth: 3,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(_scoreColor),
              ),
              Text(
                '$percentage%',
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        if (voteCount != null) ...[
          const SizedBox(width: 6),
          Text(
            '${_formatVoteCount(voteCount!)} votes',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  String _formatVoteCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

class TappableStarRating extends StatefulWidget {
  final double initialRating;
  final ValueChanged<double>? onRatingChanged;
  final double starSize;

  const TappableStarRating({
    super.key,
    this.initialRating = 0,
    this.onRatingChanged,
    this.starSize = 32,
  });

  @override
  State<TappableStarRating> createState() => _TappableStarRatingState();
}

class _TappableStarRatingState extends State<TappableStarRating> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() => _rating = starValue.toDouble());
            widget.onRatingChanged?.call(starValue.toDouble());
          },
          child: Icon(
            starValue <= _rating ? Icons.star_rounded : Icons.star_outline_rounded,
            color: Colors.amber,
            size: widget.starSize,
          ),
        );
      }),
    );
  }
}
