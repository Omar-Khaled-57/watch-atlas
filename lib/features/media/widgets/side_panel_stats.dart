import 'package:flutter/material.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../l10n/l10n.dart';
import '../../../models/media_model.dart';

/// Compact stats list for the desktop side panel.
class SidePanelStats extends StatelessWidget {
  final MediaModel media;

  const SidePanelStats({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final stats = <Map<String, String>>[];

    if (media.runtime != null) {
      stats.add({
        'label': l10n.runtime,
        'value': media.runtime!.toRuntimeString(),
      });
    }
    if (media.releaseDate != null) {
      stats.add({
        'label': l10n.releaseDate,
        'value':
            '${media.releaseDate!.year}-${media.releaseDate!.month.toString().padLeft(2, '0')}-${media.releaseDate!.day.toString().padLeft(2, '0')}',
      });
    }
    if (media.countries != null && media.countries!.isNotEmpty) {
      stats.add({'label': l10n.country, 'value': media.countries!.join(', ')});
    }
    if (media.language != null) {
      stats.add({'label': l10n.language, 'value': media.language!});
    }
    if (media.status != null) {
      stats.add({'label': l10n.status, 'value': media.status!});
    }

    if (stats.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.detailsLabel,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: Spacing.md),
        ...stats.map(
          (stat) => Padding(
            padding: EdgeInsetsDirectional.only(bottom: Spacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat['label']!,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(width: Spacing.sm),
                Expanded(
                  child: Text(
                    stat['value']!,
                    textAlign: TextAlign.end,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
