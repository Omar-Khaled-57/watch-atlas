import 'package:flutter/material.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/extensions/datetime_extensions.dart';
import '../../../models/user_list_model.dart';
import '../../../l10n/l10n.dart';
import 'collage_cover.dart';

class ListCard extends StatelessWidget {
  final UserListModel listData;
  final List<String>? posterUrls;
  final List<String>? categories;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ListCard({
    super.key,
    required this.listData,
    this.posterUrls,
    this.categories,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.all(Radius.circular(16)),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CollageCover(
                    imageUrls: posterUrls ?? [],
                    height: double.infinity,
                    borderRadius: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          listData.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          '${listData.itemCount} ${listData.itemCount == 1 ? context.l10n.title : context.l10n.items}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(14, 10, 14, 4),
              child: Row(
                children: [
                  if (listData.updatedAt != null) ...[
                    Icon(Icons.access_time_rounded, size: 12, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      'Updated ${listData.updatedAt!.timeAgo(context)}',
                      style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant, fontSize: 10),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Icon(Icons.movie_outlined, size: 12, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    '${listData.itemCount}',
                    style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant, fontSize: 10),
                  ),
                ],
              ),
            ),
            if (categories != null && categories!.isNotEmpty)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(14, 0, 14, 10),
                child: Wrap(
                  spacing: 4,
                  children: categories!.take(3).map((c) => Container(
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadiusDirectional.all(Radius.circular(6)),
                    ),
                    child: Text(
                      c,
                      style: textTheme.labelSmall?.copyWith(fontSize: 9, color: colorScheme.onSurfaceVariant),
                    ),
                  )).toList(),
                ),
              )
            else
              const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
