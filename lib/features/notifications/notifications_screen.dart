import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/shared/empty_state.dart';
import '../../core/shared/loading_widget.dart';
import '../../models/notification_model.dart';
import '../../core/models/media_enums.dart';
import 'providers/notifications_providers.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final notificationsAsync = ref.watch(notificationsProvider);
    final unreadAsync = ref.watch(unreadCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          unreadAsync.when(
            data: (count) {
              if (count == 0) return const SizedBox.shrink();
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (value) {
                  switch (value) {
                    case 'markRead':
                      ref.read(markAllNotificationsReadProvider);
                    case 'clear':
                      _showClearDialog();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'markRead',
                    child: Row(
                      children: [
                        Icon(Icons.done_all_rounded, size: 20),
                        SizedBox(width: Spacing.md),
                        Text('Mark all as read'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'clear',
                    child: Row(
                      children: [
                        Icon(Icons.delete_sweep_rounded, size: 20),
                        SizedBox(width: Spacing.md),
                        Text('Clear all'),
                      ],
                    ),
                  ),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (error, stack) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const FullScreenLoader(),
        error: (error, stack) => ErrorWidgetView(
          message: 'Failed to load notifications',
          onRetry: () => ref.invalidate(notificationsProvider),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return const EmptyState(
              title: 'No notifications',
              subtitle: 'You\'re all caught up!',
            );
          }

          final grouped = _groupByDate(notifications);

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(notificationsProvider),
            child: ListView.builder(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
              itemCount: grouped.length,
              itemBuilder: (context, index) {
                final entry = grouped.entries.elementAt(index);
                return _buildDateSection(
                  entry.key, entry.value, colorScheme, textTheme,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateSection(
    String dateLabel,
    List<NotificationModel> notifications,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(Spacing.lg, Spacing.lg, Spacing.lg, Spacing.sm),
          child: Text(
            dateLabel,
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...notifications.map((n) => _buildNotificationTile(n, colorScheme, textTheme)),
      ],
    );
  }

  Widget _buildNotificationTile(
    NotificationModel notification,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return InkWell(
      onTap: () {
        if (!notification.isRead) {
          ref.read(markNotificationReadProvider(notification.id));
        }
        _handleNavigation(notification);
      },
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: !notification.isRead
              ? colorScheme.primary.withValues(alpha: 0.05)
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationIcon(notification.type, colorScheme),
            const SizedBox(width: Spacing.md),
            if (notification.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadiusDirectional.all(Radius.circular(6)),
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: CachedNetworkImage(
                    imageUrl: notification.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: colorScheme.surfaceContainerHighest,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.notifications_rounded,
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            if (notification.imageUrl != null) const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: !notification.isRead
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.body,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (notification.createdAt != null) ...[
                    const SizedBox(height: Spacing.xs),
                    Text(
                      _formatTime(notification.createdAt!),
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!notification.isRead)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 8),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationType type, ColorScheme colorScheme) {
    IconData icon;
    Color color;
    switch (type) {
      case NotificationType.friendFollow:
        icon = Icons.person_add_rounded;
        color = const Color(0xFF8B5CF6);
      case NotificationType.newEpisode:
        icon = Icons.new_releases_rounded;
        color = const Color(0xFF22C55E);
      case NotificationType.newSeason:
        icon = Icons.auto_awesome_rounded;
        color = const Color(0xFF3B82F6);
      case NotificationType.review:
        icon = Icons.rate_review_rounded;
        color = const Color(0xFFEAB308);
      case NotificationType.comment:
        icon = Icons.chat_rounded;
        color = const Color(0xFFEC4899);
      case NotificationType.listUpdate:
        icon = Icons.list_alt_rounded;
        color = const Color(0xFFF97316);
      case NotificationType.recommendation:
        icon = Icons.recommend_rounded;
        color = const Color(0xFF06B6D4);
    }
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadiusDirectional.all(Radius.circular(10)),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  void _handleNavigation(NotificationModel notification) {
    if (notification.deepLink != null) {
      context.push(notification.deepLink!);
    }
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all notifications?'),
        content: const Text(
          'This action cannot be undone. All notifications will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(clearAllNotificationsProvider);
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Map<String, List<NotificationModel>> _groupByDate(
    List<NotificationModel> notifications,
  ) {
    final grouped = <String, List<NotificationModel>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final n in notifications) {
      String label;
      if (n.createdAt == null) {
        label = 'Unknown';
      } else {
        final date = DateTime(
          n.createdAt!.year,
          n.createdAt!.month,
          n.createdAt!.day,
        );
        if (date == today) {
          label = 'Today';
        } else if (date == yesterday) {
          label = 'Yesterday';
        } else if (date.isAfter(today.subtract(const Duration(days: 7)))) {
          label = DateFormat('EEEE').format(n.createdAt!);
        } else {
          label = DateFormat('MMM d, yyyy').format(n.createdAt!);
        }
      }
      grouped.putIfAbsent(label, () => []);
      grouped[label]!.add(n);
    }
    return grouped;
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(dateTime);
  }
}
