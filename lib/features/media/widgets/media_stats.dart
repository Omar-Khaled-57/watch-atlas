import 'package:flutter/material.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/number_extensions.dart';
import 'package:intl/intl.dart';

class MediaStats extends StatelessWidget {
  final int? runtime;
  final DateTime? releaseDate;
  final List<String>? countries;
  final String? language;

  const MediaStats({
    super.key,
    this.runtime,
    this.releaseDate,
    this.countries,
    this.language,
  });

  @override
  Widget build(BuildContext context) {
    final items = <_StatItem>[];

    if (runtime != null) {
      items.add(_StatItem(
        icon: Icons.schedule_rounded,
        label: runtime!.toRuntimeString(),
      ));
    }

    if (releaseDate != null) {
      final locale = Localizations.localeOf(context).toString();
      items.add(_StatItem(
        icon: Icons.calendar_today_rounded,
        label: DateFormat.yMMMd(locale).format(releaseDate!),
      ));
    }

    if (countries != null && countries!.isNotEmpty) {
      items.add(_StatItem(
        icon: Icons.public_rounded,
        label: countries!.join(', '),
      ));
    }

    if (language != null) {
      items.add(_StatItem(
        icon: Icons.language_rounded,
        label: language!,
      ));
    }

    if (items.isEmpty) return SizedBox.shrink();

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 16,
              color: context.colorScheme.onSurfaceVariant,
            ),
          SizedBox(width: Spacing.xs),
          Text(
              item.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _StatItem {
  final IconData icon;
  final String label;

  const _StatItem({
    required this.icon,
    required this.label,
  });
}
