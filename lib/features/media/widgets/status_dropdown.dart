import 'package:flutter/material.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/models/media_enums.dart';

class StatusDropdown extends StatelessWidget {
  final WatchStatus? currentStatus;
  final ValueChanged<WatchStatus?>? onChanged;

  const StatusDropdown({
    super.key,
    this.currentStatus,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<WatchStatus?>(
      value: currentStatus,
      decoration: InputDecoration(
        labelText: 'Watch Status',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        contentPadding: EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        prefixIcon: Icon(
          _statusIcon(currentStatus),
          size: 20,
        ),
      ),
      items: [
        DropdownMenuItem(
          value: null,
          child: Text('Not in list'),
        ),
        ...WatchStatus.values.map((status) {
          return DropdownMenuItem(
            value: status,
            child: Row(
              children: [
                Icon(
                  _statusIcon(status),
                  size: 18,
                  color: _statusColor(status, context),
                ),
                SizedBox(width: Spacing.md),
                Text(_statusLabel(status)),
              ],
            ),
          );
        }),
      ],
      onChanged: onChanged,
    );
  }

  IconData _statusIcon(WatchStatus? status) {
    switch (status) {
      case WatchStatus.watching:
        return Icons.play_circle_rounded;
      case WatchStatus.completed:
        return Icons.check_circle_rounded;
      case WatchStatus.onHold:
        return Icons.pause_circle_rounded;
      case WatchStatus.dropped:
        return Icons.cancel_rounded;
      case WatchStatus.planToWatch:
        return Icons.bookmark_add_rounded;
      case WatchStatus.rewatching:
        return Icons.replay_rounded;
      case null:
        return Icons.remove_circle_outline_rounded;
    }
  }

  Color _statusColor(WatchStatus status, BuildContext context) {
    switch (status) {
      case WatchStatus.watching:
        return Colors.blue;
      case WatchStatus.completed:
        return Colors.green;
      case WatchStatus.onHold:
        return Colors.orange;
      case WatchStatus.dropped:
        return Colors.red;
      case WatchStatus.planToWatch:
        return Colors.purple;
      case WatchStatus.rewatching:
        return Colors.teal;
    }
  }

  String _statusLabel(WatchStatus status) {
    switch (status) {
      case WatchStatus.watching:
        return 'Watching';
      case WatchStatus.completed:
        return 'Completed';
      case WatchStatus.onHold:
        return 'On Hold';
      case WatchStatus.dropped:
        return 'Dropped';
      case WatchStatus.planToWatch:
        return 'Plan to Watch';
      case WatchStatus.rewatching:
        return 'Rewatching';
    }
  }
}
