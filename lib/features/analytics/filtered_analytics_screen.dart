import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/shared/loading_widget.dart';
import '../../l10n/l10n.dart';
import 'providers/analytics_providers.dart';

class FilteredAnalyticsScreen extends ConsumerWidget {
  final String filterType;
  final String filterKey;

  const FilteredAnalyticsScreen({
    super.key,
    required this.filterType,
    required this.filterKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    final filteredMediaAsync = ref.watch(
      filteredMediaProvider((filterType, filterKey)),
    );

    return Scaffold(
      appBar: AppBar(title: Text(_getTitle(context))),
      body: filteredMediaAsync.when(
        loading: () => const FullScreenLoader(),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: cs.error),
              const SizedBox(height: Spacing.sm),
              Text(context.l10n.failedToLoadMedia, style: tt.bodyLarge),
              const SizedBox(height: Spacing.sm),
              TextButton(
                onPressed: () => ref.invalidate(
                  filteredMediaProvider((filterType, filterKey)),
                ),
                child: Text(context.l10n.retry),
              ),
            ],
          ),
        ),
        data: (mediaList) {
          if (mediaList.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.movie_outlined,
                    size: 64,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(height: Spacing.lg),
                  Text(context.l10n.noMediaForPeriod, style: tt.titleMedium),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsetsDirectional.all(Spacing.lg),
            itemCount: mediaList.length,
            separatorBuilder: (_, __) => const SizedBox(height: Spacing.sm),
            itemBuilder: (context, index) {
              final media = mediaList[index];
              return Card(
                margin: EdgeInsetsDirectional.zero,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: cs.surfaceContainerHighest,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  title: Text(
                    media['title'] as String? ?? context.l10n.unknown,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    media['media_type'] as String? ?? '',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  trailing: media['vote_average'] != null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: AppColors.star,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              (media['vote_average'] as num).toStringAsFixed(1),
                              style: tt.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : null,
                  onTap: () {
                    final mediaType = media['media_type'] as String? ?? 'movie';
                    context.push('/media/$mediaType/${media['id']}');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _getTitle(BuildContext context) {
    final l10n = context.l10n;
    if (filterType == 'weekly') {
      final parts = filterKey.split('-');
      if (parts.length >= 3) {
        return '${l10n.mediaFor} ${parts[1]}/${parts[2]}';
      }
    } else if (filterType == 'monthly') {
      final parts = filterKey.split('-');
      if (parts.length >= 2) {
        final monthIndex = int.tryParse(parts[1]) ?? 0;
        if (monthIndex > 0 && monthIndex <= 12) {
          final monthName = DateFormat.MMMM().format(
            DateTime(2024, monthIndex),
          );
          return '${l10n.mediaFor} $monthName ${parts[0]}';
        }
      }
    }
    return l10n.filteredMedia;
  }
}
