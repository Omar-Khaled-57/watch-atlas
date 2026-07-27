import 'package:flutter/material.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../l10n/l10n.dart';
import '../../../models/media_model.dart';
import 'detail_section_header.dart';
import '../../../core/shared/expandable_text.dart';

/// Expandable synopsis/overview section for media details.
class OverviewSection extends StatelessWidget {
  final MediaModel media;

  const OverviewSection({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    if (media.overview == null || media.overview!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailSectionHeader(title: context.l10n.overview),
        SizedBox(height: Spacing.sm),
        ExpandableText(
          text: media.overview!,
          style: context.textTheme.bodyMedium?.copyWith(height: 1.6),
        ),
      ],
    );
  }
}
