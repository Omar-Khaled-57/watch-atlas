import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/shared/user_avatar.dart';
import '../../core/shared/empty_state.dart';
import '../../core/shared/loading_widget.dart';
import '../../core/providers/app_providers.dart';
import 'providers/profile_providers.dart';
import 'widgets/activity_tile.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final isOwn = widget.userId == null;
    final userId = widget.userId ?? ref.watch(authServiceProvider).userId;

    final profileAsync = ref.watch(
      isOwn ? currentUserProfileProvider : userProfileProvider(userId),
    );
    final activityAsync = ref.watch(userActivityProvider(userId));

    return Scaffold(
      body: profileAsync.when(
        loading: () => const FullScreenLoader(),
        error: (error, stack) => ErrorWidgetView(
          message: 'Failed to load profile',
          detail: error.toString(),
          onRetry: () => ref.invalidate(currentUserProfileProvider),
        ),
        data: (profile) {
          if (profile == null) {
            return const EmptyState(
              title: 'Profile not found',
              subtitle: 'This user does not exist.',
            );
          }

          final initials = profile.displayName ?? profile.username;

          return NestedScrollView(
            headerSliverBuilder: (context, innerScrolled) => [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeader(profile, initials, colorScheme),
                ),
                actions: [
                  if (isOwn)
                    IconButton(
                      icon: const Icon(Icons.settings_rounded),
                      onPressed: () => context.pushNamed('settings'),
                    ),
                ],
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: colorScheme.onSurface,
                    unselectedLabelColor: colorScheme.onSurfaceVariant,
                    indicatorColor: colorScheme.primary,
                    tabs: const [
                      Tab(text: 'Activity'),
                      Tab(text: 'Reviews'),
                      Tab(text: 'Lists'),
                      Tab(text: 'Stats'),
                    ],
                  ),
                  colorScheme.surface,
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildActivityTab(activityAsync, colorScheme, textTheme),
                _buildReviewsTab(profile, colorScheme, textTheme),
                _buildListsTab(profile, colorScheme, textTheme),
                _buildStatsTab(profile, colorScheme, textTheme),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    dynamic profile,
    String initials,
    ColorScheme colorScheme,
  ) {
    final isOwn = widget.userId == null;

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: const BorderRadiusDirectional.vertical(
            bottom: Radius.circular(0),
          ),
          child: profile.bannerUrl != null
              ? CachedNetworkImage(
                  imageUrl: profile.bannerUrl as String,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => _buildDefaultBanner(colorScheme),
                )
              : _buildDefaultBanner(colorScheme),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topCenter,
              end: AlignmentDirectional.bottomCenter,
              colors: [
                Colors.transparent,
                colorScheme.surface.withValues(alpha: 0.85),
              ],
              stops: const [0.5, 1.0],
            ),
          ),
        ),
        PositionedDirectional(
          bottom: 16,
          start: 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              UserAvatar(
                imageUrl: profile.avatarUrl as String?,
                initials: initials[0].toUpperCase(),
                radius: 34,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      profile.displayName ?? profile.username as String,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '@${profile.username as String}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isOwn)
          PositionedDirectional(
            top: MediaQuery.of(context).padding.top + 4,
            end: 8,
            child: FilledButton.tonalIcon(
              onPressed: () => context.pushNamed('editProfile'),
              icon: const Icon(Icons.edit_rounded, size: 16),
              label: const Text('Edit'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDefaultBanner(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.movie_rounded,
          size: 64,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildActivityTab(
    AsyncValue<List<UserActivity>> activityAsync,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return activityAsync.when(
      loading: () => const FullScreenLoader(),
      error: (error, stack) => ErrorWidgetView(
        message: 'Failed to load activity',
        onRetry: () => ref.invalidate(currentUserActivityProvider),
      ),
      data: (activities) {
        if (activities.isEmpty) {
          return const EmptyState(
            title: 'No activity yet',
            subtitle: 'Activity from watched media will appear here.',
          );
        }
        return RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(currentUserActivityProvider),
          child: ListView.separated(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
            itemCount: activities.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
            itemBuilder: (context, index) => ActivityTile(
              activity: activities[index],
              onTap: () {},
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab(
    dynamic profile,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return const EmptyState(
      title: 'No reviews yet',
      subtitle: 'Reviews you write will appear here.',
    );
  }

  Widget _buildListsTab(
    dynamic profile,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return const EmptyState(
      title: 'No lists yet',
      subtitle: 'Lists you create will appear here.',
    );
  }

  Widget _buildStatsTab(
    dynamic profile,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return const EmptyState(
      title: 'Stats coming soon',
      subtitle: 'Your viewing statistics will appear here.',
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  _TabBarDelegate(this.tabBar, this.backgroundColor);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: backgroundColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => false;
}
