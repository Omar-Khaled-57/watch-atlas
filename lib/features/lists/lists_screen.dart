import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/shared/loading_widget.dart';
import '../../models/user_list_model.dart';
import 'providers/lists_providers.dart';
import 'widgets/list_card.dart';
import 'widgets/create_list_dialog.dart';
import 'all_items_screen.dart';

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
    final totalTitles = ref.watch(totalTitlesProvider);
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;

    final crossAxisCount = isDesktop ? 4 : isTablet ? 3 : 2;

    return Scaffold(
      appBar: AppBar(title: const Text('My Collections')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(userListsProvider),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHero(totalTitles, listsAsync.valueOrNull?.length ?? 0, colorScheme, textTheme)),
            _buildBodyContent(listsAsync, colorScheme, textTheme, crossAxisCount, totalTitles),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(),
        child: const Icon(Icons.add_rounded),
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
            'Your Collections',
            style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
          ),
          const SizedBox(height: 6),
          Text(
            '$totalTitles Title${totalTitles == 1 ? '' : 's'} \u2022 $listCount List${listCount == 1 ? '' : 's'}',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent(
    AsyncValue<List<UserListModel>> listsAsync,
    ColorScheme colorScheme,
    TextTheme textTheme,
    int crossAxisCount,
    int totalTitles,
  ) {
    return listsAsync.when(
      loading: () => const SliverFillRemaining(child: FullScreenLoader()),
      error: (error, _) => SliverFillRemaining(
        child: Center(child: Text('Failed to load lists', style: textTheme.bodyMedium?.copyWith(color: colorScheme.error))),
      ),
      data: (lists) {
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
                return ListCard(
                  listData: list,
                  posterUrls: null,
                  onTap: () => _navigateToDetail(list.id),
                );
              },
              childCount: lists.length + 1,
            ),
          ),
        );
      },
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

  void _openAllItems() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AllItemsScreen()),
    );
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
              child: Text(
                'All Collections',
                style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(14, 0, 14, 4),
              child: Text(
                '$totalTitles Title${totalTitles == 1 ? '' : 's'}',
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
                  'All Items',
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
