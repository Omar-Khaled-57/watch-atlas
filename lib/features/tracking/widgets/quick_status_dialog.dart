import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/media_enums.dart';
import '../../../models/user_media_model.dart';
import '../providers/tracking_providers.dart';

class QuickStatusDialog extends ConsumerWidget {
  final UserMediaModel userMedia;

  const QuickStatusDialog({super.key, required this.userMedia});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Status',
              style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 20),
            ...WatchStatus.values.map((status) {
              final isSelected = userMedia.status == status;
              return Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(userMediaProvider.notifier).updateStatus(userMedia, status);
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isSelected ? colorScheme.primary.withValues(alpha: 0.1) : null,
                      side: BorderSide(
                        color: isSelected ? colorScheme.primary : colorScheme.outline,
                      ),
                      padding: const EdgeInsetsDirectional.symmetric(vertical: 14, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.all(Radius.circular(10)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _statusIcon(status),
                          size: 20,
                          color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _statusLabel(status),
                          style: textTheme.bodyMedium?.copyWith(
                            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Icon(Icons.check_rounded, size: 18, color: colorScheme.primary),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  ref.read(userMediaProvider.notifier).removeMedia(userMedia);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Remove from list',
                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _statusIcon(WatchStatus status) {
    switch (status) {
      case WatchStatus.watching: return Icons.play_circle_rounded;
      case WatchStatus.completed: return Icons.check_circle_rounded;
      case WatchStatus.onHold: return Icons.pause_circle_rounded;
      case WatchStatus.dropped: return Icons.cancel_rounded;
      case WatchStatus.planToWatch: return Icons.bookmark_add_rounded;
      case WatchStatus.rewatching: return Icons.replay_rounded;
    }
  }

  String _statusLabel(WatchStatus status) {
    switch (status) {
      case WatchStatus.watching: return 'Watching';
      case WatchStatus.completed: return 'Completed';
      case WatchStatus.onHold: return 'On Hold';
      case WatchStatus.dropped: return 'Dropped';
      case WatchStatus.planToWatch: return 'Plan to Watch';
      case WatchStatus.rewatching: return 'Rewatching';
    }
  }
}
