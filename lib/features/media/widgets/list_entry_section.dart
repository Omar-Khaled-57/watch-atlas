import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/models/media_enums.dart';
import '../../../l10n/l10n.dart';
import '../../../models/media_model.dart';
import '../../tracking/providers/tracking_providers.dart';

/// Shows the user's tracking entry details for this media item.
class ListEntrySection extends ConsumerWidget {
  final MediaModel media;

  const ListEntrySection({super.key, required this.media});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final userMediaList = ref.watch(userMediaProvider).value ?? [];
    final entry = userMediaList.where((m) => m.mediaId == media.id).firstOrNull;
    if (entry == null) return const SizedBox.shrink();

    final locale = Localizations.localeOf(context).languageCode;

    return Semantics(
      label:
          '${context.l10n.inYourLibrary}: ${_statusLabel(context, entry.status)}',
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.all(Spacing.lg),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadiusDirectional.all(
            Radius.circular(Spacing.cardRadiusMd),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.list_alt_rounded,
                  size: 18,
                  color: context.colorScheme.primary,
                ),
                SizedBox(width: Spacing.sm),
                Text(
                  context.l10n.inYourLibrary,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: Spacing.md),
            _entryRow(
              context,
              l10n.status,
              _statusLabel(context, entry.status),
            ),
            if (entry.userRating != null)
              _entryRow(
                context,
                l10n.ratings,
                '${entry.userRating!.toStringAsFixed(1)} / 10',
              ),
            if (entry.episodeProgress > 0 && entry.totalEpisodes > 0)
              _entryRow(
                context,
                l10n.progress,
                '${entry.episodeProgress} / ${entry.totalEpisodes} episodes',
              ),
            if (entry.createdAt != null)
              _entryRow(
                context,
                context.l10n.addedLabel,
                DateFormat.yMMMd(locale).format(entry.createdAt!),
              ),
            if (entry.updatedAt != null)
              _entryRow(
                context,
                context.l10n.updatedLabel,
                DateFormat.yMMMd(locale).format(entry.updatedAt!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _entryRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: Spacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(BuildContext context, WatchStatus status) {
    final l10n = context.l10n;
    switch (status) {
      case WatchStatus.watching:
        return l10n.watching;
      case WatchStatus.completed:
        return l10n.completed;
      case WatchStatus.onHold:
        return l10n.onHold;
      case WatchStatus.dropped:
        return l10n.dropped;
      case WatchStatus.planToWatch:
        return l10n.planToWatch;
      case WatchStatus.rewatching:
        return l10n.rewatching;
    }
  }
}
