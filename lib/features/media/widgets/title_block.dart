import 'package:flutter/material.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../models/media_model.dart';

/// Displays the media title and original title (if different).
class TitleBlock extends StatelessWidget {
  final MediaModel media;
  final bool hasPoster;

  const TitleBlock({super.key, required this.media, required this.hasPoster});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: Spacing.lg,
        start: hasPoster ? 116 : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            media.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (media.originalTitle != null && media.originalTitle != media.title)
            Padding(
              padding: EdgeInsetsDirectional.only(top: Spacing.xs),
              child: Text(
                media.originalTitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
