import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/extensions/datetime_extensions.dart';
import '../../core/models/media_enums.dart';
import '../../core/shared/loading_widget.dart';
import '../../core/shared/expandable_text.dart';
import '../../models/user_list_model.dart';
import '../../models/user_media_model.dart';
import '../../features/tracking/providers/tracking_providers.dart';
import 'providers/lists_providers.dart';

enum DetailViewMode { grid, list }

class ListDetailScreen extends ConsumerStatefulWidget {
  final String listId;

  const ListDetailScreen({super.key, required this.listId});

  @override
  ConsumerState<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends ConsumerState<ListDetailScreen> {
  DetailViewMode _viewMode = DetailViewMode.grid;
  String _categoryFilter = 'all';
  String _statusFilter = 'all';

  final _statuses = ['all', 'watching', 'completed', 'planToWatch', 'onHold', 'dropped'];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final listsAsync = ref.watch(userListsProvider);
    final itemsAsync = ref.watch(listItemsProvider(widget.listId));
    final categoriesAsync = ref.watch(listCategoriesProvider(widget.listId));
    final userMediaAsync = ref.watch(userMediaProvider);
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;

    return listsAsync.when(
      loading: () => const Scaffold(body: FullScreenLoader()),
      error: (_, __) => Scaffold(
        body: Center(child: Text('Failed to load list', style: textTheme.bodyMedium?.copyWith(color: colorScheme.error))),
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
                onPressed: () => Share.share('Check out my list: ${listData.title} on WatchAtlas'),
              ),
            ],
          ),
          body: itemsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => Center(child: Text('Failed to load items', style: textTheme.bodyMedium?.copyWith(color: colorScheme.error))),
            data: (items) {
              return _buildContent(listData, items, categoriesAsync.valueOrNull ?? [], userMediaAsync.valueOrNull ?? [], isDesktop, isTablet, colorScheme, textTheme);
            },
          ),
        );
      },
    );
  }

  Widget _buildContent(
    UserListModel listData,
    List<Map<String, dynamic>> items,
    List<String> categories,
    List<UserMediaModel> userMedia,
    bool isDesktop,
    bool isTablet,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final itemMediaIds = items.map((i) => i['media_id'] as int).toSet();

    final filteredByCategory = _categoryFilter == 'all'
        ? items
        : items.where((i) => _matchesCategory(i, _categoryFilter)).toList();

    final statusCounts = {
      'watching': 0, 'completed': 0, 'planToWatch': 0, 'onHold': 0, 'dropped': 0,
    };
    for (final item in filteredByCategory) {
      final mediaId = item['media_id'] as int;
      final um = userMedia.where((u) => u.mediaId == mediaId).firstOrNull;
      if (um != null) {
        statusCounts[um.status.name] = (statusCounts[um.status.name] ?? 0) + 1;
      }
    }

    final crossAxisCount = isDesktop ? 6 : isTablet ? 5 : 3;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildCover(listData, items, colorScheme, textTheme)),
        SliverToBoxAdapter(child: _buildMeta(listData, colorScheme, textTheme)),
        SliverToBoxAdapter(child: _buildCategoryTabs(categories, colorScheme, textTheme)),
        SliverToBoxAdapter(child: _buildStatusChips(colorScheme, textTheme)),
        SliverToBoxAdapter(child: _buildFilterToolbar(colorScheme, textTheme)),
        _buildItemsGrid(filteredByCategory, userMedia, crossAxisCount, colorScheme, textTheme),
        if (filteredByCategory.isNotEmpty)
          SliverToBoxAdapter(child: _buildInsights(filteredByCategory, userMedia, statusCounts, colorScheme, textTheme)),
        const SliverPadding(padding: EdgeInsetsDirectional.only(bottom: 80)),
      ],
    );
  }

  Widget _buildCover(UserListModel listData, List<Map<String, dynamic>> items, ColorScheme colorScheme, TextTheme textTheme) {
    return SizedBox(
      height: 220,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primaryContainer, colorScheme.secondaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
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
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  listData.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  '${listData.itemCount} ${listData.itemCount == 1 ? 'Title' : 'Titles'}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeta(UserListModel listData, ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 14, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (listData.description != null && listData.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 10),
              child: ExpandableText(
                text: listData.description!,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _chip(Icons.public_rounded, listData.listType.name, colorScheme, textTheme),
                const SizedBox(width: 6),
                if (listData.updatedAt != null) _chip(Icons.access_time_rounded, listData.updatedAt!.timeAgo, colorScheme, textTheme),
                if (listData.tags.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  ...listData.tags.take(3).map((t) => _chip(Icons.label_rounded, t, colorScheme, textTheme)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(List<String> categories, ColorScheme colorScheme, TextTheme textTheme) {
    if (categories.isEmpty) return const SizedBox.shrink();
    final allCategories = ['all', ...categories];

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 0, 4),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: allCategories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (context, index) {
            final c = allCategories[index];
            final isSelected = _categoryFilter == c;
            return FilterChip(
              label: Text(c == 'all' ? 'All' : c, style: textTheme.labelMedium?.copyWith(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
              selected: isSelected,
              onSelected: (_) => setState(() => _categoryFilter = c),
              showCheckmark: false,
              visualDensity: VisualDensity.compact,
              selectedColor: colorScheme.primaryContainer,
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusChips(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 0, 0),
      child: SizedBox(
        height: 32,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _statuses.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (context, index) {
            final s = _statuses[index];
            final isSelected = _statusFilter == s;
            final label = s == 'all' ? 'All' : s[0].toUpperCase() + s.substring(1).replaceAllMapped(
              RegExp(r'[A-Z]'), (m) => ' ${m.group(0)}');
            return FilterChip(
              label: Text(label, style: textTheme.labelSmall?.copyWith(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
              selected: isSelected,
              onSelected: (_) => setState(() => _statusFilter = s),
              showCheckmark: false,
              visualDensity: VisualDensity.compact,
              selectedColor: colorScheme.secondaryContainer,
              backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterToolbar(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
      child: Row(
        children: [
          Text('${_itemCount} items', style: textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
          const Spacer(),
          IconButton(
            icon: Icon(_viewMode == DetailViewMode.grid ? Icons.view_list_rounded : Icons.grid_view_rounded, size: 20),
            tooltip: 'Toggle view',
            onPressed: () => setState(() {
              _viewMode = _viewMode == DetailViewMode.grid ? DetailViewMode.list : DetailViewMode.grid;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsGrid(
    List<Map<String, dynamic>> items,
    List<UserMediaModel> userMedia,
    int crossAxisCount,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    var filtered = items.where((item) {
      if (_statusFilter == 'all') return true;
      final mediaId = item['media_id'] as int;
      final um = userMedia.where((u) => u.mediaId == mediaId).firstOrNull;
      return um?.status.name == _statusFilter;
    }).toList();

    if (filtered.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded, size: 48, color: colorScheme.onSurfaceVariant),
              const SizedBox(height: Spacing.md),
              Text('No items match', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      );
    }

    if (_viewMode == DetailViewMode.grid) {
      return SliverPadding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 0),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.6,
            crossAxisSpacing: Spacing.sm,
            mainAxisSpacing: Spacing.sm,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => _GridTile(
              item: filtered[index],
              userMedia: userMedia,
              colorScheme: colorScheme,
              textTheme: textTheme,
              onTap: () {
                final type = filtered[index]['media_type'] as String? ?? 'movie';
                context.push('/media/$type/${filtered[index]['media_id']}');
              },
            ),
            childCount: filtered.length,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _ListTile(
            item: filtered[index],
            userMedia: userMedia,
            colorScheme: colorScheme,
            textTheme: textTheme,
            onTap: () {
              final type = filtered[index]['media_type'] as String? ?? 'movie';
              context.push('/media/$type/${filtered[index]['media_id']}');
            },
          ),
          childCount: filtered.length,
        ),
      ),
    );
  }

  Widget _buildInsights(
    List<Map<String, dynamic>> items,
    List<UserMediaModel> userMedia,
    Map<String, int> statusCounts,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final total = items.length;
    if (total == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
          const SizedBox(height: 14),
          Text('$total Total Title${total == 1 ? '' : 's'}', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: statusCounts.entries.where((e) => e.value > 0).map((e) {
              final color = switch (e.key) {
                'watching' => const Color(0xFF4CAF50),
                'completed' => const Color(0xFF2196F3),
                'planToWatch' => const Color(0xFF9C27B0),
                'onHold' => const Color(0xFFFF9800),
                'dropped' => const Color(0xFFF44336),
                _ => colorScheme.onSurfaceVariant,
              };
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text(
                    '${e.value} ${e.key[0].toUpperCase()}${e.key.substring(1).replaceAllMapped(RegExp(r'[A-Z]'), (m) => ' ${m.group(0)}')}',
                    style: textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label, ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadiusDirectional.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: Spacing.xs),
          Text(label, style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  bool _matchesCategory(Map<String, dynamic> item, String category) {
    final type = item['media_type'] as String?;
    if (category == 'TV Shows') return type == 'tv';
    if (category == 'Movies') return type == 'movie';
    if (category == 'Anime') return type == 'anime';
    return true;
  }

  int get _itemCount {
    final items = ref.watch(listItemsProvider(widget.listId)).valueOrNull ?? [];
    return _categoryFilter == 'all'
        ? items.length
        : items.where((i) => _matchesCategory(i, _categoryFilter)).length;
  }
}

class _GridTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final List<UserMediaModel> userMedia;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onTap;

  const _GridTile({
    required this.item,
    required this.userMedia,
    required this.colorScheme,
    required this.textTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mediaId = item['media_id'] as int;
    final um = userMedia.where((u) => u.mediaId == mediaId).firstOrNull;

    return Card(
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
              child: Container(
                color: colorScheme.surfaceContainerHighest,
                child: Center(
                  child: Icon(Icons.movie_outlined, size: 32, color: colorScheme.onSurfaceVariant),
                ),
              ),
            ),
            if (um != null)
              Container(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 6, vertical: 3),
                color: colorScheme.surfaceContainerLow,
                child: Row(
                  children: [
                    _statusDot(um.status.name),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Text(
                        um.status.name[0].toUpperCase() + um.status.name.substring(1).replaceAllMapped(
                          RegExp(r'[A-Z]'), (m) => ' ${m.group(0)}'),
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
    );
  }

  Widget _statusDot(String status) {
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
}

class _ListTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final List<UserMediaModel> userMedia;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onTap;

  const _ListTile({
    required this.item,
    required this.userMedia,
    required this.colorScheme,
    required this.textTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mediaId = item['media_id'] as int;
    final note = item['note'] as String?;
    final mediaType = item['media_type'] as String? ?? 'movie';
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
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsDirectional.all(14),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 72,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(8)),
                ),
                child: Center(child: Icon(Icons.movie_outlined, size: 24, color: colorScheme.onSurfaceVariant)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: $mediaId', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    if (note != null && note.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(note, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
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
                          _statusDot(um.status.name),
                          const SizedBox(width: Spacing.xs),
                          Flexible(
                            child: Text(
                              um.status.name[0].toUpperCase() + um.status.name.substring(1).replaceAllMapped(
                                RegExp(r'[A-Z]'), (m) => ' ${m.group(0)}'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.labelSmall?.copyWith(color: _statusColor(um.status.name)),
                            ),
                          ),
                          if (um.episodeProgress > 0)
                            Flexible(
                              child: Text(
                                ' \u2022 ${um.episodeProgress}/${um.totalEpisodes}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                              ),
                            ),
                        ],
                      ],
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

  Widget _statusDot(String status) {
    return Container(width: 8, height: 8, decoration: BoxDecoration(color: _statusColor(status), shape: BoxShape.circle));
  }

  Color _statusColor(String status) {
    return switch (status) {
      'watching' => const Color(0xFF4CAF50),
      'completed' => const Color(0xFF2196F3),
      'planToWatch' => const Color(0xFF9C27B0),
      'onHold' => const Color(0xFFFF9800),
      'dropped' => const Color(0xFFF44336),
      _ => colorScheme.onSurfaceVariant,
    };
  }
}
