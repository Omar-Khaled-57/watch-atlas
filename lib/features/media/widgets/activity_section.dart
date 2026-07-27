import 'package:flutter/material.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../l10n/l10n.dart';
import 'detail_section_header.dart';

/// Placeholder activity timeline section.
class ActivitySection extends StatelessWidget {
  const ActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailSectionHeader(title: context.l10n.activity),
        SizedBox(height: Spacing.md),
        Container(
          width: double.infinity,
          padding: EdgeInsetsDirectional.all(Spacing.xl),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadiusDirectional.all(
              Radius.circular(Spacing.cardRadiusMd),
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.timeline_rounded,
                size: 36,
                color: context.colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: Spacing.sm),
              Text(
                context.l10n.noRecentActivity,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
