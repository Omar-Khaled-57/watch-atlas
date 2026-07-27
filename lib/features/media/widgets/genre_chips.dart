import 'package:flutter/material.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/extensions/context_extensions.dart';

/// Horizontal wrap of genre chips for media details.
class GenreChips extends StatelessWidget {
  final List<String> genres;

  const GenreChips({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Genres: ${genres.join(", ")}',
      child: Wrap(
        spacing: Spacing.sm,
        runSpacing: Spacing.xs,
        children: genres.map((genre) {
          return Chip(
            label: Text(genre, style: context.textTheme.labelSmall),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsetsDirectional.zero,
            labelPadding: EdgeInsetsDirectional.symmetric(
              horizontal: Spacing.sm,
            ),
          );
        }).toList(),
      ),
    );
  }
}
