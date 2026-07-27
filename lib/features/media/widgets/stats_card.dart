import 'package:flutter/material.dart';
import '../../../models/media_model.dart';
import 'media_stats.dart';

/// Compact stats card delegating to MediaStats widget.
class StatsCard extends StatelessWidget {
  final MediaModel media;

  const StatsCard({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return MediaStats(
      runtime: media.runtime,
      releaseDate: media.releaseDate,
      countries: media.countries,
      language: media.language,
    );
  }
}
