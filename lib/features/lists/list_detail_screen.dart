import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/models/media_enums.dart';
import '../../models/user_list_model.dart';
import '../../core/shared/loading_widget.dart';
import 'providers/lists_providers.dart';

class ListDetailScreen extends ConsumerStatefulWidget {
  final String listId;

  const ListDetailScreen({super.key, required this.listId});

  @override
  ConsumerState<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends ConsumerState<ListDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final listsAsync = ref.watch(userListsProvider);
    final itemsAsync = ref.watch(listItemsProvider(widget.listId));
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;

    final crossAxisCount = isDesktop ? 5 : isTablet ? 4 : 3;

    return listsAsync.when(
      loading: () => const Scaffold(body: FullScreenLoader()),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Failed to load list', style: textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
        ),
      ),
      data: (lists) {
        final listData = lists.where((l) => l.id == widget.listId).firstOrNull;
        if (listData == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('List not found')),
            body: const Center(child: Text('This list could not be found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(listData.title),
            actions: [
              if (listData.listType == MediaListType.collaborative)
                IconButton(
                  icon: const Icon(Icons.favorite_border_rounded),
                  tooltip: 'Like',
                  onPressed: () => ref.read(userListsProvider.notifier).likeList(widget.listId),
                ),
              IconButton(
                icon: const Icon(Icons.share_rounded),
                tooltip: 'Share',
                onPressed: () {
                  SharePlus.instance.share(
                    ShareParams(text: 'Check out my list: ${listData.title} on WatchAtlas'),
                  );
                },
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (listData.description != null && listData.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 8),
                  child: Text(
                    listData.description!,
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
                child: Row(
                  children: [
                    _MetaChip(
                      icon: Icons.movie_outlined,
                      label: '${listData.itemCount} items',
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    const SizedBox(width: 8),
                    _MetaChip(
                      icon: Icons.favorite_border_rounded,
                      label: '${listData.likesCount} likes',
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    const SizedBox(width: 8),
                    _TypeChip(listType: listData.listType, colorScheme: colorScheme, textTheme: textTheme),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: itemsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text('Failed to load items', style: textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
                  ),
                  data: (items) {
                    if (items.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.movie_filter_rounded, size: 64, color: colorScheme.onSurfaceVariant),
                            const SizedBox(height: 16),
                            Text(
                              'No items in this list',
                              style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      );
                    }
                    return ReorderableGridView.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      padding: const EdgeInsetsDirectional.all(12),
                      childAspectRatio: 0.65,
                      onReorder: (oldIndex, newIndex) {
                        final mediaIds = items.map((m) => m['media_id'] as int).toList();
                        final item = mediaIds.removeAt(oldIndex);
                        mediaIds.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, item);
                        ref.read(userListsProvider.notifier).reorderItems(widget.listId, mediaIds);
                      },
                      buildDefaultDragHandles: false,
                      children: [
                        for (final item in items)
                          _ListGridItem(
                            key: ValueKey(item['media_id']),
                            mediaId: item['media_id'] as int,
                            note: item['note'] as String?,
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                            onTap: () => Navigator.of(context).pushNamed('/media/${item['media_id']}'),
                            onDelete: () => ref
                                .read(userListsProvider.notifier)
                                .removeItemFromList(widget.listId, item['media_id'] as int),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadiusDirectional.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(label, style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final MediaListType listType;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _TypeChip({
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
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadiusDirectional.all(Radius.circular(20)),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ListGridItem extends StatelessWidget {
  final int mediaId;
  final String? note;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ListGridItem({
    super.key,
    required this.mediaId,
    this.note,
    required this.colorScheme,
    required this.textTheme,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.movie_outlined, size: 32, color: colorScheme.onSurfaceVariant),
                          const SizedBox(height: 4),
                          Text(
                            'ID: $mediaId',
                            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (note != null && note!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.all(8),
                    child: Text(
                      note!,
                      style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          PositionedDirectional(
            top: 4,
            end: 4,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsetsDirectional.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(20)),
                ),
                child: Icon(Icons.close_rounded, size: 16, color: Colors.white),
              ),
            ),
          ),
          PositionedDirectional(
            top: 4,
            start: 4,
            child: ReorderableDragStartListener(
              index: 0,
              child: Container(
                padding: const EdgeInsetsDirectional.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(20)),
                ),
                child: Icon(Icons.drag_handle_rounded, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
