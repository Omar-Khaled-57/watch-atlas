import 'package:flutter/material.dart';

class StatItem {
  final String label;
  final int count;

  const StatItem({required this.label, required this.count});
}

class StatsBar extends StatelessWidget {
  final List<StatItem> items;

  const StatsBar({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadiusDirectional.all(Radius.circular(12)),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;
          return Expanded(
            child: Container(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 4),
              decoration: isLast
                  ? null
                  : BoxDecoration(
                      border: BorderDirectional(
                        end: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                    ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatCount(item.count),
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.label,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
