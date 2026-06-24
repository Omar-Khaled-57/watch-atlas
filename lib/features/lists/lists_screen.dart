import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/shared/empty_state.dart';
import '../../core/shared/loading_widget.dart';
import 'providers/lists_providers.dart';
import 'widgets/list_card.dart';
import 'widgets/create_list_dialog.dart';

class ListsScreen extends ConsumerStatefulWidget {
  const ListsScreen({super.key});

  @override
  ConsumerState<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends ConsumerState<ListsScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final listsAsync = ref.watch(userListsProvider);
    final pinned = ref.watch(pinnedListsProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(),
        child: const Icon(Icons.add_rounded),
      ),
      body: listsAsync.when(
        loading: () => const FullScreenLoader(),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(32),
            child: Text('Failed to load lists', style: textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
          ),
        ),
        data: (lists) {
          if (lists.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async => ref.invalidate(userListsProvider),
              child: ListView(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 16),
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                    child: Text(
                      'My Lists',
                      style: textTheme.headlineMedium?.copyWith(color: colorScheme.onSurface),
                    ),
                  ),
                  Expanded(
                    child: EmptyState(
                      title: 'No lists yet',
                      subtitle: 'Create your first list to organize your media',
                      actionLabel: 'Create List',
                      onAction: () => _showCreateDialog(),
                    ),
                  ),
                ],
              ),
            );
          }

          final unpinned = lists.where((l) => !l.isPinned).toList();

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(userListsProvider),
            child: ListView(
              padding: EdgeInsetsDirectional.only(
                top: MediaQuery.of(context).padding.top + 16,
                bottom: 88,
              ),
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'My Lists',
                          style: textTheme.headlineMedium?.copyWith(color: colorScheme.onSurface),
                        ),
                      ),
                      Text(
                        '${lists.length} lists',
                        style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                if (pinned.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 8),
                    child: Row(
                      children: [
                        Icon(Icons.push_pin_rounded, size: 16, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Text(
                          'Pinned',
                          style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  ...pinned.map((list) => Padding(
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 4),
                    child: ListCard(
                      listData: list,
                      onTap: () => _navigateToDetail(list.id),
                      onPin: () => ref.read(userListsProvider.notifier).togglePin(list),
                      onDelete: () => _confirmDelete(list.id),
                    ),
                  )),
                ],
                if (unpinned.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: 16,
                      end: 16,
                      top: pinned.isNotEmpty ? 12 : 20,
                      bottom: 8,
                    ),
                    child: Text(
                      'All Lists',
                      style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                  ...unpinned.map((list) => Padding(
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 4),
                    child: ListCard(
                      listData: list,
                      onTap: () => _navigateToDetail(list.id),
                      onPin: () => ref.read(userListsProvider.notifier).togglePin(list),
                      onDelete: () => _confirmDelete(list.id),
                    ),
                  )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreateListDialog(),
    );
  }

  void _navigateToDetail(String listId) {
    context.push('/lists/$listId');
  }

  void _confirmDelete(String listId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete List'),
        content: const Text('Are you sure you want to delete this list?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final list = ref.read(userListsProvider).valueOrNull?.firstWhere((l) => l.id == listId);
              if (list != null) {
                ref.read(userListsProvider.notifier).deleteList(list);
              }
              Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  ColorScheme get colorScheme => Theme.of(context).colorScheme;
}
