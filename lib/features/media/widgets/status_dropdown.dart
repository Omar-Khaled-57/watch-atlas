import 'package:flutter/material.dart';
import '../../../l10n/l10n.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/models/media_enums.dart';

class StatusDropdown extends StatelessWidget {
  final WatchStatus currentStatus;
  final ValueChanged<WatchStatus>? onChanged;

  const StatusDropdown({
    super.key,
    this.currentStatus = WatchStatus.planToWatch,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<WatchStatus>(
      value: currentStatus,
      decoration: InputDecoration(
        labelText: context.l10n.status,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        contentPadding: EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      items: WatchStatus.values.map((status) {
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
              Text(_statusLabel(context, status)),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) onChanged?.call(value);
      },
    );
  }

  IconData _statusIcon(WatchStatus status) {
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
