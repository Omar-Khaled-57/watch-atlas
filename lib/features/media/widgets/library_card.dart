import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/models/media_enums.dart';
import '../../../l10n/l10n.dart';
import '../../../models/media_model.dart';
import '../../tracking/providers/tracking_providers.dart';

/// Displays which user lists this media item belongs to.
class LibraryCard extends ConsumerWidget {
  final MediaModel media;

  const LibraryCard({super.key, required this.media});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMediaList = ref.watch(userMediaProvider).value ?? [];
    final trackingEntry = userMediaList
        .where((m) => m.mediaId == media.id)
        .firstOrNull;

    return Container(
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
                Icons.bookmark_rounded,
                size: 18,
                color: context.colorScheme.primary,
              ),
              SizedBox(width: Spacing.sm),
              Text(
                context.l10n.inYourList,
                style: context.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: Spacing.md),
          Text(
            trackingEntry != null
                ? _statusLabel(context, trackingEntry.status)
                : context.l10n.notTracked,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
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
