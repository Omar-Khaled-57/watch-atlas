import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/shared/user_avatar.dart';
import '../../core/shared/empty_state.dart';
import '../../core/shared/loading_widget.dart';
import '../../core/providers/app_providers.dart';
import '../../models/user_model.dart';
import 'providers/social_providers.dart';

class SocialScreen extends ConsumerStatefulWidget {
  const SocialScreen({super.key});

  @override
  ConsumerState<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends ConsumerState<SocialScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final userId = ref.watch(authServiceProvider).userId;

    final followersAsync = ref.watch(currentUserFollowersProvider);
    final followingAsync = ref.watch(currentUserFollowingProvider);
    final activityAsync = ref.watch(friendActivityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.onSurface,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          indicatorColor: colorScheme.primary,
          tabs: const [
            Tab(text: 'Following'),
            Tab(text: 'Followers'),
            Tab(text: 'Activity'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(colorScheme, textTheme),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFollowingTab(followingAsync, userId, colorScheme, textTheme),
                _buildFollowersTab(followersAsync, userId, colorScheme, textTheme),
                _buildFriendActivityTab(activityAsync, colorScheme, textTheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(Spacing.lg, Spacing.sm, Spacing.lg, Spacing.sm),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by username...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            ref.invalidate(searchUsersProvider(value.trim()));
          }
        },
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  Widget _buildFollowingTab(
    AsyncValue<List<UserModel>> followingAsync,
    String userId,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return followingAsync.when(
      loading: () => const FullScreenLoader(),
      error: (error, stack) => ErrorWidgetView(
        message: 'Failed to load following',
        onRetry: () => ref.invalidate(currentUserFollowingProvider),
      ),
      data: (users) {
        if (users.isEmpty) {
          return const EmptyState(
            title: 'Not following anyone',
            subtitle: 'Find friends to follow and see their activity.',
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(currentUserFollowingProvider),
          child: ListView.separated(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
            itemCount: users.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: 72,
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
            itemBuilder: (context, index) =>
                _buildUserTile(users[index], userId, colorScheme, textTheme),
          ),
        );
      },
    );
  }

  Widget _buildFollowersTab(
    AsyncValue<List<UserModel>> followersAsync,
    String userId,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return followersAsync.when(
      loading: () => const FullScreenLoader(),
      error: (error, stack) => ErrorWidgetView(
        message: 'Failed to load followers',
        onRetry: () => ref.invalidate(currentUserFollowersProvider),
      ),
      data: (users) {
        if (users.isEmpty) {
          return const EmptyState(
            title: 'No followers yet',
            subtitle: 'When someone follows you, they will appear here.',
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(currentUserFollowersProvider),
          child: ListView.separated(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
            itemCount: users.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: 72,
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
            itemBuilder: (context, index) =>
                _buildUserTile(users[index], userId, colorScheme, textTheme),
          ),
        );
      },
    );
  }

  Widget _buildFriendActivityTab(
    AsyncValue<List<Map<String, dynamic>>> activityAsync,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return activityAsync.when(
      loading: () => const FullScreenLoader(),
      error: (error, stack) => ErrorWidgetView(
        message: 'Failed to load activity',
        onRetry: () => ref.invalidate(friendActivityProvider),
      ),
      data: (activities) {
        if (activities.isEmpty) {
          return const EmptyState(
            title: 'No friend activity',
            subtitle: 'Activity from people you follow will appear here.',
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(friendActivityProvider),
          child: ListView.separated(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
            itemCount: activities.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
            itemBuilder: (context, index) {
              final item = activities[index];
              return ListTile(
                leading: UserAvatar(
                  imageUrl: item['user_avatar'] as String?,
                  radius: 18,
                ),
                title: Text(
                  item['description'] as String? ?? '',
                  style: textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: item['created_at'] != null
                    ? Text(
                        _formatTime(item['created_at'] as String),
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      )
                    : null,
                onTap: () {},
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildUserTile(
    UserModel user,
    String currentUserId,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final isSelf = user.id == currentUserId;
    final isFollowing = ref.watch(isFollowingProvider(user.id));

    return ListTile(
      leading: UserAvatar(
        imageUrl: user.avatarUrl,
        initials: (user.displayName ?? user.username)[0].toUpperCase(),
        radius: 22,
      ),
      title: Text(
        user.displayName ?? user.username,
        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '@${user.username}',
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: isSelf
          ? null
          : isFollowing.when(
              data: (following) {
                if (following) {
                  return OutlinedButton(
                    onPressed: () => ref.read(unfollowUserProvider(user.id)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Following'),
                  );
                }
                return FilledButton(
                  onPressed: () => ref.read(followUserProvider(user.id)),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Follow'),
                );
              },
              loading: () => const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (error, stack) => const SizedBox.shrink(),
            ),
      onTap: () => context.pushNamed('userProfile', pathParameters: {'id': user.id}),
    );
  }

  String _formatTime(String isoDate) {
    final dateTime = DateTime.tryParse(isoDate);
    if (dateTime == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${diff.inDays}d ago';
  }
}
