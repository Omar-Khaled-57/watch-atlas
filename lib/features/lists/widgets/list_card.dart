import 'package:flutter/material.dart';
import '../../../core/models/media_enums.dart';
import '../../../models/user_list_model.dart';

class ListCard extends StatelessWidget {
  final UserListModel listData;
  final VoidCallback? onTap;
  final VoidCallback? onPin;
  final VoidCallback? onDelete;

  const ListCard({
    super.key,
    required this.listData,
    this.onTap,
    this.onPin,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsDirectional.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(12)),
                ),
                child: Icon(
                  listData.listType == MediaListType.collaborative
                      ? Icons.group_rounded
                      : listData.listType == MediaListType.private
                          ? Icons.lock_rounded
                          : Icons.list_alt_rounded,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            listData.title,
                            style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurface),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _TypeBadge(listType: listData.listType, colorScheme: colorScheme, textTheme: textTheme),
                      ],
                    ),
                    if (listData.description != null && listData.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        listData.description!,
                        style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.movie_outlined, size: 14, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          '${listData.itemCount} items',
                          style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                        if (listData.likesCount > 0) ...[
                          const SizedBox(width: 12),
                          Icon(Icons.favorite_border_rounded, size: 14, color: colorScheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            '${listData.likesCount}',
                            style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (onPin != null || onDelete != null)
                PopupMenuButton<String>(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'pin',
                      child: Row(
                        children: [
                          Icon(listData.isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined, size: 18),
                          const SizedBox(width: 8),
                          Text(listData.isPinned ? 'Unpin' : 'Pin'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded, size: 18, color: colorScheme.error),
                          const SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: colorScheme.error)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'pin') onPin?.call();
                    if (value == 'delete') onDelete?.call();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final MediaListType listType;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _TypeBadge({
    required this.listType,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (listType) {
      MediaListType.public => ('Public', Colors.green),
      MediaListType.private => ('Private', Colors.orange),
      MediaListType.collaborative => ('Collab', Colors.blue),
    };

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadiusDirectional.all(Radius.circular(20)),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}
