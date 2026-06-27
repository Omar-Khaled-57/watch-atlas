import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/extensions/string_extensions.dart';
import '../../core/shared/empty_state.dart';
import '../../core/shared/loading_widget.dart';
import '../../models/user_list_model.dart';
import '../../models/user_media_model.dart';
import '../../features/tracking/providers/tracking_providers.dart';
import 'providers/lists_providers.dart';
import 'widgets/list_card.dart';
import 'widgets/create_list_dialog.dart';
import '../../l10n/l10n.dart';
import 'all_items_screen.dart';

class ListsScreen extends ConsumerStatefulWidget {
  const ListsScreen({super.key});

  @override
  ConsumerState<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends ConsumerState<ListsScreen> {
  String? _selectedListId;

  bool get _isWide => context.isDesktop || (context.isTablet && MediaQuery.of(context).orientation == Orientation.landscape);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final listsAsync = ref.watch(userListsProvider);
    final totalTitles = ref.watch(totalTitlesProvider);
    final lists = listsAsync.valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.myCollections)),
      body: _isWide ? _buildWideLayout(lists, listsAsync, totalTitles, colorScheme, textTheme) : _buildNarrowLayout(listsAsync, totalTitles, colorScheme, textTheme),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildNarrowLayout(AsyncValue<List<UserListModel>> listsAsync, int totalTitles, ColorScheme colorScheme, TextTheme textTheme) {
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;
    final crossAxisCount = isDesktop ? 4 : isTablet ? 3 : 2;

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(userListsProvider),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHero(totalTitles, listsAsync.valueOrNull?.length ?? 0, colorScheme, textTheme)),
          listsAsync.when(
            loading: () => const SliverFillRemaining(child: FullScreenLoader()),
            error: (error, _) => SliverFillRemaining(
              child: Center(child: Text(context.l10n.failedToLoadList, style: textTheme.bodyMedium?.copyWith(color: colorScheme.error))),
            ),
            data: (lists) {
              if (lists.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(
                    title: context.l10n.noListsYet,
                    subtitle: context.l10n.createFirstList,
                    actionLabel: context.l10n.createList,
                    onAction: () => _showCreateDialog(),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 80),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisExtent: 320,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == 0) {
                        return _AllCollectionCard(totalTitles: totalTitles, onTap: () => _openAllItems());
                      }
                      final list = lists[index - 1];
                      return _ListCardWithMenu(
                        listData: list,
                        onTap: () => _navigateToDetail(list.id),
                        onRename: () => _showRenameDialog(list),
                        onDelete: () => _confirmDeleteList(list),
                      );
                    },
                    childCount: lists.length + 1,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout(List<UserListModel> lists, AsyncValue<List<UserListModel>> listsAsync, int totalTitles, ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        SizedBox(
          width: 320,
          child: listsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => Center(child: Text(context.l10n.error, style: textTheme.bodyMedium?.copyWith(color: colorScheme.error))),
            data: (data) {
              if (data.isEmpty) {
                return EmptyState(
                  title: context.l10n.noListsYet,
                  actionLabel: context.l10n.createList,
                  onAction: () => _showCreateDialog(),
                );
              }
              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(userListsProvider),
                child: ListView(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 0, 80),
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 16),
                      child: Text(context.l10n.yourCollections, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    ),
                    _AllCollectionListTile(
                      totalTitles: totalTitles,
                      onTap: () => _openAllItems(),
                      isSelected: _selectedListId == null,
                    ),
                    ...data.map((list) => _CompactListTile(
                      listData: list,
                      isSelected: _selectedListId == list.id,
                      onTap: () => setState(() => _selectedListId = list.id),
                      onRename: () => _showRenameDialog(list),
                      onDelete: () => _confirmDeleteList(list),
                    )),
                  ],
                ),
              );
            },
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _selectedListId != null ? _ListDetailPanel(listId: _selectedListId!) : _buildPlaceholder(colorScheme, textTheme),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.collections_bookmark_rounded, size: 64, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
          const SizedBox(height: Spacing.lg),
          Text(context.l10n.selectList, style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: Spacing.xs),
          Text(context.l10n.chooseListFromSidebar, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildHero(int totalTitles, int listCount, ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.yourCollections,
            style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
          ),
          const SizedBox(height: 6),
          Text(
            '${totalTitles == 1 ? '$totalTitles ${context.l10n.item}' : '$totalTitles ${context.l10n.items}'} \u2022 $listCount List${listCount == 1 ? '' : 's'}',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreateListDialog(),
    );
  }

  void _showRenameDialog(UserListModel list) {
    showDialog(
      context: context,
      builder: (context) => CreateListDialog(
        editId: list.id,
        initialTitle: list.title,
        initialDescription: list.description,
        initialType: list.listType,
      ),
    );
  }

  void _confirmDeleteList(UserListModel list) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.deleteListConfirm(list.title)),
        content: Text(context.l10n.deleteListWarning),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () {
              ref.read(userListsProvider.notifier).deleteList(list);
              if (_selectedListId == list.id) setState(() => _selectedListId = null);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${context.l10n.listDeleted}: ${list.title}')));
            },
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(String listId) {
    context.push('/lists/$listId');
  }

  void _openAllItems() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AllItemsScreen()),
    );
  }
}

class _ListCardWithMenu extends StatelessWidget {
  final UserListModel listData;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const _ListCardWithMenu({
    required this.listData,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) => _showContextMenu(context, details),
      child: ListCard(
        listData: listData,
        posterUrls: null,
        onTap: onTap,
      ),
    );
  }

  void _showContextMenu(BuildContext context, LongPressStartDetails details) {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(details.globalPosition.dx, details.globalPosition.dy, details.globalPosition.dx, details.globalPosition.dy),
      items: [
        PopupMenuItem(value: 'rename', child: ListTile(leading: Icon(Icons.edit_rounded), title: Text(context.l10n.rename), dense: true)),
        PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete_rounded), title: Text(context.l10n.delete), dense: true)),
      ],
    ).then((value) {
      if (value == 'rename') onRename();
      if (value == 'delete') onDelete();
    });
  }
}

class _CompactListTile extends StatelessWidget {
  final UserListModel listData;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const _CompactListTile({
    required this.listData,
    required this.isSelected,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      margin: const EdgeInsetsDirectional.only(bottom: 4),
      color: isSelected ? colorScheme.primaryContainer : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.all(Radius.circular(12)),
        side: BorderSide(color: isSelected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        leading: Icon(isSelected ? Icons.folder_open_rounded : Icons.folder_rounded, size: 20),
        title: Text(listData.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
        subtitle: Text(context.l10n.itemCount(listData.itemCount)),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded, size: 18),
          onSelected: (value) {
            if (value == 'rename') onRename();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (_) => [
            PopupMenuItem(value: 'rename', child: ListTile(leading: Icon(Icons.edit_rounded), title: Text(context.l10n.rename), dense: true)),
            PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete_rounded), title: Text(context.l10n.delete), dense: true)),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class _AllCollectionListTile extends StatelessWidget {
  final int totalTitles;
  final VoidCallback onTap;
  final bool isSelected;

  const _AllCollectionListTile({required this.totalTitles, required this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      color: isSelected ? colorScheme.secondaryContainer : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.all(Radius.circular(12)),
        side: BorderSide(color: isSelected ? colorScheme.secondary : colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        leading: Icon(Icons.collections_bookmark_rounded, size: 20, color: isSelected ? colorScheme.onSecondaryContainer : null),
        title: Text(context.l10n.allCollections, style: TextStyle(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
        subtitle: Text(context.l10n.itemCount(totalTitles)),
        onTap: onTap,
      ),
    );
  }
}

class _ListDetailPanel extends ConsumerStatefulWidget {
  final String listId;

  const _ListDetailPanel({required this.listId});

  @override
  ConsumerState<_ListDetailPanel> createState() => _ListDetailPanelState();
}

class _ListDetailPanelState extends ConsumerState<_ListDetailPanel> {
  MasterDetailViewMode _viewMode = MasterDetailViewMode.list;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final listsAsync = ref.watch(userListsProvider);
    final itemsAsync = ref.watch(listItemsProvider(widget.listId));
    final list = listsAsync.valueOrNull?.where((l) => l.id == widget.listId).firstOrNull;
    if (list == null) return const SizedBox.shrink();

    final itemCount = itemsAsync.valueOrNull?.length ?? list.itemCount;

    return Column(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 16, 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1))),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(list.title, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(context.l10n.itemCount(itemCount), style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(_viewMode == MasterDetailViewMode.grid ? Icons.view_list_rounded : Icons.grid_view_rounded, size: 20),
                tooltip: context.l10n.toggleView,
                onPressed: () => setState(() {
                  _viewMode = _viewMode == MasterDetailViewMode.grid ? MasterDetailViewMode.list : MasterDetailViewMode.grid;
                }),
              ),
            ],
          ),
        ),
        Expanded(
          child: _ListDetailItems(listId: widget.listId, viewMode: _viewMode),
        ),
      ],
    );
  }
}

enum MasterDetailViewMode { grid, list }

class _ListDetailItems extends ConsumerWidget {
  final String listId;
  final MasterDetailViewMode viewMode;

  const _ListDetailItems({required this.listId, required this.viewMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final itemsAsync = ref.watch(listItemsProvider(listId));
    final userMediaAsync = ref.watch(userMediaProvider);

    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(child: Text(context.l10n.failedToLoadItems, style: textTheme.bodyMedium?.copyWith(color: colorScheme.error))),
      data: (items) {
        if (items.isEmpty) {
          return EmptyState(
            title: context.l10n.noItemsInList,
            subtitle: context.l10n.addMediaFromDetails,
          );
        }
        final userMedia = userMediaAsync.valueOrNull ?? [];

        if (viewMode == MasterDetailViewMode.grid) {
          return GridView.builder(
            padding: const EdgeInsetsDirectional.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 0.6,
              crossAxisSpacing: Spacing.sm,
              mainAxisSpacing: Spacing.sm,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) => _LandscapeGridTile(
              item: items[index],
              userMedia: userMedia,
              onTap: () {
                final mediaData = items[index]['media'] as Map<String, dynamic>?;
                final mediaId = items[index]['media_id'] as int;
                final mediaType = mediaData?['media_type'] as String? ?? 'movie';
                context.push('/media/$mediaType/$mediaId');
              },
              onRemove: () => _confirmRemoveItem(context, ref, items[index]),
              onMove: () => _showMoveCopyDialog(context, ref, items[index], move: true),
              onCopy: () => _showMoveCopyDialog(context, ref, items[index], move: false),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsetsDirectional.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final mediaId = item['media_id'] as int;
            final mediaData = item['media'] as Map<String, dynamic>?;
            final title = mediaData?['title'] as String? ?? 'ID: $mediaId';
            final posterPath = mediaData?['poster_path'] as String?;
            final mediaType = mediaData?['media_type'] as String? ?? item['media_type'] as String? ?? 'movie';
            final um = userMedia.where((u) => u.mediaId == mediaId).firstOrNull;

            return Card(
              clipBehavior: Clip.antiAlias,
              elevation: 0,
              margin: const EdgeInsetsDirectional.only(bottom: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.all(Radius.circular(12)),
                side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1)),
              ),
              child: InkWell(
                onTap: () {
                  context.push('/media/$mediaType/$mediaId');
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(14),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusDirectional.all(Radius.circular(8)),
                        child: Container(
                          width: 56,
                          height: 72,
                          color: colorScheme.surfaceContainerHighest,
                          child: posterPath != null
                              ? CachedNetworkImage(
                                  imageUrl: posterPath.posterUrl,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => Icon(Icons.movie_outlined, size: 24, color: colorScheme.onSurfaceVariant),
                                )
                              : Center(child: Icon(Icons.movie_outlined, size: 24, color: colorScheme.onSurfaceVariant)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                                    borderRadius: BorderRadiusDirectional.all(Radius.circular(4)),
                                  ),
                                  child: Text(mediaType.toUpperCase(), style: textTheme.labelSmall?.copyWith(fontSize: 9, color: colorScheme.onPrimaryContainer)),
                                ),
                                if (um != null) ...[
                                  const SizedBox(width: Spacing.sm),
                                  Container(width: 8, height: 8, decoration: BoxDecoration(color: _statusColor(um.status.name, colorScheme), shape: BoxShape.circle)),
                                  const SizedBox(width: Spacing.xs),
                                  Flexible(
                                    child: Text(
                                      um.status.name[0].toUpperCase() + um.status.name.substring(1).replaceAllMapped(RegExp(r'[A-Z]'), (m) => ' ${m.group(0)}'),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: textTheme.labelSmall?.copyWith(color: _statusColor(um.status.name, colorScheme)),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert_rounded, size: 18, color: colorScheme.onSurfaceVariant),
                        onSelected: (value) {
                          if (value == 'remove') _confirmRemoveItem(context, ref, item);
                          if (value == 'move') _showMoveCopyDialog(context, ref, item, move: true);
                          if (value == 'copy') _showMoveCopyDialog(context, ref, item, move: false);
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(value: 'remove', child: ListTile(leading: Icon(Icons.remove_circle_outline_rounded), title: Text(context.l10n.remove), dense: true)),
                          PopupMenuItem(value: 'move', child: ListTile(leading: Icon(Icons.drive_file_move_rounded), title: Text(context.l10n.move), dense: true)),
                          PopupMenuItem(value: 'copy', child: ListTile(leading: Icon(Icons.copy_rounded), title: Text(context.l10n.copy), dense: true)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _statusColor(String status, ColorScheme colorScheme) {
    return switch (status) {
      'watching' => const Color(0xFF4CAF50),
      'completed' => const Color(0xFF2196F3),
      'planToWatch' => const Color(0xFF9C27B0),
      'onHold' => const Color(0xFFFF9800),
      'dropped' => const Color(0xFFF44336),
      _ => colorScheme.onSurfaceVariant,
    };
  }

  void _confirmRemoveItem(BuildContext context, WidgetRef ref, Map<String, dynamic> item) {
    final mediaId = item['media_id'] as int;
    final mediaData = item['media'] as Map<String, dynamic>?;
    final title = mediaData?['title'] as String? ?? 'this item';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.removeListTitle(title)),
        content: Text(context.l10n.removeFromListWarning),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () {
              ref.read(userListsProvider.notifier).removeItemFromList(listId, mediaId);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.removedFromList)));
            },
            child: Text(context.l10n.remove),
          ),
        ],
      ),
    );
  }

  void _showMoveCopyDialog(BuildContext context, WidgetRef ref, Map<String, dynamic> item, {required bool move}) {
    final mediaId = item['media_id'] as int;
    final lists = ref.read(userListsProvider).valueOrNull ?? [];
    final otherLists = lists.where((l) => l.id != listId).toList();

    if (otherLists.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(move ? context.l10n.noOtherListsToMoveTo : context.l10n.noOtherListsToCopyTo)),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(move ? context.l10n.moveTo : context.l10n.copyTo),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: otherLists.map((list) => ListTile(
              leading: const Icon(Icons.folder_rounded),
              title: Text(list.title),
              subtitle: Text(context.l10n.itemCount(list.itemCount)),
              onTap: () {
                if (move) {
                  ref.read(userListsProvider.notifier).moveItemToList(listId, list.id, mediaId);
                } else {
                  ref.read(userListsProvider.notifier).copyItemToList(list.id, mediaId);
                }
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(move ? context.l10n.movedToTitle(list.title) : context.l10n.copiedToTitle(list.title))),
                );
              },
            )).toList(),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.cancel))],
      ),
    );
  }
}

class _LandscapeGridTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final List<UserMediaModel> userMedia;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onMove;
  final VoidCallback onCopy;

  const _LandscapeGridTile({
    required this.item,
    required this.userMedia,
    required this.onTap,
    required this.onRemove,
    required this.onMove,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final mediaId = item['media_id'] as int;
    final mediaData = item['media'] as Map<String, dynamic>?;
    final posterPath = mediaData?['poster_path'] as String?;
    final title = mediaData?['title'] as String? ?? 'ID: $mediaId';
    final um = userMedia.where((u) => u.mediaId == mediaId).firstOrNull;

    return GestureDetector(
      onLongPressStart: (details) => _showMenu(context, details),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(10)),
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1)),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: posterPath != null
                    ? CachedNetworkImage(
                        imageUrl: posterPath.posterUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: Center(child: Icon(Icons.movie_outlined, size: 32, color: colorScheme.onSurfaceVariant)),
                        ),
                      )
                    : Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: Center(child: Icon(Icons.movie_outlined, size: 32, color: colorScheme.onSurfaceVariant)),
                      ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(6, 4, 6, 4),
                child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
              ),
              if (um != null)
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 6, vertical: 3),
                  color: colorScheme.surfaceContainerLow,
                  child: Row(
                    children: [
                      _statusDot(um.status.name, colorScheme),
                      const SizedBox(width: Spacing.xs),
                      Expanded(
                        child: Text(
                          um.status.name[0].toUpperCase() + um.status.name.substring(1).replaceAllMapped(RegExp(r'[A-Z]'), (m) => ' ${m.group(0)}'),
                          style: textTheme.labelSmall?.copyWith(fontSize: 9),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusDot(String status, ColorScheme colorScheme) {
    final color = switch (status) {
      'watching' => const Color(0xFF4CAF50),
      'completed' => const Color(0xFF2196F3),
      'planToWatch' => const Color(0xFF9C27B0),
      'onHold' => const Color(0xFFFF9800),
      'dropped' => const Color(0xFFF44336),
      _ => colorScheme.onSurfaceVariant,
    };
    return Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }

  void _showMenu(BuildContext context, LongPressStartDetails details) {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(details.globalPosition.dx, details.globalPosition.dy, details.globalPosition.dx, details.globalPosition.dy),
      items: [
        PopupMenuItem(value: 'remove', child: ListTile(leading: Icon(Icons.remove_circle_outline_rounded), title: Text(context.l10n.remove), dense: true)),
        PopupMenuItem(value: 'move', child: ListTile(leading: Icon(Icons.drive_file_move_rounded), title: Text(context.l10n.move), dense: true)),
        PopupMenuItem(value: 'copy', child: ListTile(leading: Icon(Icons.copy_rounded), title: Text(context.l10n.copy), dense: true)),
      ],
    ).then((value) {
      if (value == 'remove') onRemove();
      if (value == 'move') onMove();
      if (value == 'copy') onCopy();
    });
  }
}

class _AllCollectionCard extends StatelessWidget {
  final int totalTitles;
  final VoidCallback onTap;

  const _AllCollectionCard({required this.totalTitles, required this.onTap});

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
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primaryContainer, colorScheme.secondaryContainer],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.collections_bookmark_rounded, size: 28, color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(14, 10, 14, 4),
              child:               Text(
                context.l10n.allCollections,
                style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(14, 0, 14, 4),
              child: Text(
                '${totalTitles == 1 ? '$totalTitles ${context.l10n.item}' : '$totalTitles ${context.l10n.items}'}',
                style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(14, 0, 14, 10),
              child: Container(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(6)),
                ),
                child: Text(
                  context.l10n.allItems,
                  style: textTheme.labelSmall?.copyWith(fontSize: 9, color: colorScheme.onPrimaryContainer),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
