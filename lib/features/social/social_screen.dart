import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/extensions/datetime_extensions.dart';
import '../../core/shared/user_avatar.dart';
import '../../core/shared/empty_state.dart';
import '../../core/shared/loading_widget.dart';
import '../../core/providers/app_providers.dart';
import '../../models/user_model.dart';
import '../../l10n/l10n.dart';
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
        title: Text(context.l10n.community),
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.onSurface,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          indicatorColor: colorScheme.primary,
          tabs: [
            Tab(text: context.l10n.following),
            Tab(text: context.l10n.followers),
            Tab(text: context.l10n.activity),
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
                _buildFollowingTab(
                  followingAsync,
                  userId,
                  colorScheme,
                  textTheme,
                ),
                _buildFollowersTab(
                  followersAsync,
                  userId,
                  colorScheme,
                  textTheme,
                ),
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
      padding: const EdgeInsetsDirectional.fromSTEB(
        Spacing.lg,
        Spacing.sm,
        Spacing.lg,
        Spacing.sm,
      ),
      child: Semantics(
        label: context.l10n.searchByUsername,
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: context.l10n.searchByUsername,
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _searchController.text.isNotEmpty
                ? Semantics(
                    button: true,
                    label: context.l10n.clearSearch,
                    child: IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    ),
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
        message: context.l10n.failedToLoadFollowing,
        onRetry: () => ref.invalidate(currentUserFollowingProvider),
      ),
      data: (users) {
        if (users.isEmpty) {
          return EmptyState(
            title: context.l10n.notFollowingAnyone,
            subtitle: context.l10n.findFriendsToFollow,
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
        message: context.l10n.failedToLoadFollowers,
        onRetry: () => ref.invalidate(currentUserFollowersProvider),
      ),
      data: (users) {
        if (users.isEmpty) {
          return EmptyState(
            title: context.l10n.noFollowersYet,
            subtitle: context.l10n.whenSomeoneFollowsYou,
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
        message: context.l10n.failedToLoadActivity,
        onRetry: () => ref.invalidate(friendActivityProvider),
      ),
      data: (activities) {
        if (activities.isEmpty) {
          return EmptyState(
            title: context.l10n.noFriendActivity,
            subtitle: context.l10n.activityFromPeopleYouFollow,
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
              final description = item['description'] as String? ?? '';
              final time = item['created_at'] != null
                  ? _formatTime(item['created_at'] as String)
                  : '';
              return Semantics(
                label: '$description${time.isNotEmpty ? ', $time' : ''}',
                child: ListTile(
                  leading: UserAvatar(
                    imageUrl: item['user_avatar'] as String?,
                    radius: 18,
                  ),
                  title: Text(
                    description,
                    style: textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: item['created_at'] != null
                      ? Text(
                          time,
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        )
                      : null,
                  onTap: () {},
                ),
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
    final isBlocked = ref.watch(isBlockedProvider(user.id));

    return Semantics(
      button: true,
      label: '${user.displayName ?? user.username}, @${user.username}',
      child: ListTile(
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
            : isBlocked.when(
                data: (blocked) {
                  if (blocked) {
                    return OutlinedButton(
                      onPressed: () => ref.read(unblockUserProvider(user.id)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(context.l10n.unblock),
                    );
                  }
                  return PopupMenuButton<String>(
                    itemBuilder: (ctx) => [
                      PopupMenuItem(
                        value: 'report',
                        child: Row(
                          children: [
                            Icon(
                              Icons.flag_rounded,
                              size: 18,
                              color: colorScheme.error,
                            ),
                            const SizedBox(width: Spacing.sm),
                            Text(context.l10n.report),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'block',
                        child: Row(
                          children: [
                            Icon(
                              Icons.block_rounded,
                              size: 18,
                              color: colorScheme.error,
                            ),
                            const SizedBox(width: Spacing.sm),
                            Text(context.l10n.block),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'report') {
                        _showReportDialog(context, ref, user);
                      } else if (value == 'block') {
                        _showBlockDialog(context, ref, user);
                      }
                    },
                  );
                },
                loading: () => const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (error, stack) => const SizedBox.shrink(),
              ),
        onTap: () =>
            context.pushNamed('userProfile', pathParameters: {'id': user.id}),
      ),
    );
  }

  String _formatTime(String isoDate) {
    final dateTime = DateTime.tryParse(isoDate);
    if (dateTime == null) return '';
    return dateTime.timeAgo(context);
  }

  void _showReportDialog(BuildContext context, WidgetRef ref, UserModel user) {
    final l10n = context.l10n;
    final reasonController = TextEditingController();
    String selectedReason = 'spam';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l10n.reportUser),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${l10n.report} @${user.username}'),
              const SizedBox(height: Spacing.lg),
              DropdownButtonFormField<String>(
                initialValue: selectedReason,
                decoration: InputDecoration(labelText: l10n.reason),
                items: [
                  DropdownMenuItem(value: 'spam', child: Text(l10n.spam)),
                  DropdownMenuItem(
                    value: 'inappropriate',
                    child: Text(l10n.inappropriate),
                  ),
                  DropdownMenuItem(
                    value: 'harassment',
                    child: Text(l10n.harassment),
                  ),
                  DropdownMenuItem(value: 'other', child: Text(l10n.other)),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => selectedReason = value);
                },
              ),
              const SizedBox(height: Spacing.md),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: l10n.additionalDetails,
                  hintText: l10n.optional,
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                await ref.read(
                  reportUserProvider((
                    userId: user.id,
                    reason: selectedReason,
                    description: reasonController.text.trim(),
                  )).future,
                );
                if (ctx.mounted) Navigator.pop(ctx);
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.reportSubmitted)));
                }
              },
              child: Text(l10n.submit),
            ),
          ],
        ),
      ),
    );
    reasonController.dispose();
  }

  void _showBlockDialog(BuildContext context, WidgetRef ref, UserModel user) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.blockUser),
        content: Text(l10n.confirmBlockUser),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              await ref.read(blockUserProvider(user.id).future);
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.userBlocked)));
              }
            },
            child: Text(l10n.block),
          ),
        ],
      ),
    );
  }
}
