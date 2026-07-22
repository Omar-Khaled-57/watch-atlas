import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../l10n/l10n.dart';

extension DateTimeFormatting on DateTime {
  String timeAgo(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final diff = now.difference(this);
    if (diff.inDays > 30) return l10n.monthsAgo((diff.inDays ~/ 30).toDouble());
    if (diff.inDays > 0) return l10n.daysAgo(diff.inDays.toDouble());
    if (diff.inHours > 0) return l10n.hoursAgo(diff.inHours.toDouble());
    if (diff.inMinutes > 0) return l10n.minutesAgo(diff.inMinutes.toDouble());
    return l10n.justNow;
  }
}
