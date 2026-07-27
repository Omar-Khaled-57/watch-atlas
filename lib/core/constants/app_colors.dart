import 'package:flutter/material.dart';

import '../models/media_enums.dart';

/// Centralized semantic colors used across the app.
class AppColors {
  AppColors._();

  /// Star/rating color.
  static const Color star = Color(0xFFFFC107);

  /// Brand purple used for logo glow and accents.
  static const Color logoPurple = Color(0xFF8B5CF6);
}

/// Extension on [WatchStatus] for a centralized status color.
extension WatchStatusColor on WatchStatus {
  Color get color => switch (this) {
    WatchStatus.watching => const Color(0xFF2196F3),
    WatchStatus.completed => const Color(0xFF4CAF50),
    WatchStatus.planToWatch => const Color(0xFF9C27B0),
    WatchStatus.onHold => const Color(0xFFFF9800),
    WatchStatus.dropped => const Color(0xFFF44336),
    WatchStatus.rewatching => const Color(0xFF009688),
  };
}

/// Resolves a status color from a status string name.
///
/// Falls back to [fallback] if the string doesn't match a known status.
Color statusColorFromString(String status, {Color? fallback}) {
  return switch (status) {
    'watching' => const Color(0xFF2196F3),
    'completed' => const Color(0xFF4CAF50),
    'planToWatch' => const Color(0xFF9C27B0),
    'onHold' => const Color(0xFFFF9800),
    'dropped' => const Color(0xFFF44336),
    _ => fallback ?? const Color(0xFF78716C),
  };
}
