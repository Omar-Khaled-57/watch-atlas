import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/models/media_enums.dart';
import '../../core/shared/loading_widget.dart';
import '../../models/user_model.dart';
import 'providers/moderation_providers.dart';

class ModerationScreen extends ConsumerStatefulWidget {
  const ModerationScreen({super.key});

  @override
  ConsumerState<ModerationScreen> createState() => _ModerationScreenState();
}

class _ModerationScreenState extends ConsumerState<ModerationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMod = ref.watch(isModeratorProvider);

    if (!isMod) {
      return Scaffold(
        appBar: AppBar(title: const Text('Moderation')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shield_outlined,
                size: 64,
                color: context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: Spacing.lg),
              Text(
                'Access Denied',
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                'You do not have moderator permissions.',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Moderation'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Reports'),
            Tab(text: 'Users'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ReportsTab(),
          _UsersTab(),
        ],
      ),
    );
  }
}

class _ReportsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportsProvider);
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return reportsAsync.when(
      loading: () => const FullScreenLoader(),
      error: (e, _) => ErrorWidgetView(
        message: 'Failed to load reports',
        detail: e.toString(),
        onRetry: () => ref.invalidate(reportsProvider),
      ),
      data: (reports) {
        if (reports.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline_rounded, size: 64, color: cs.onSurfaceVariant),
                const SizedBox(height: Spacing.lg),
                Text('No pending reports', style: tt.titleMedium),
                const SizedBox(height: Spacing.sm),
                Text('All clear!', style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(reportsProvider),
          child: ListView.separated(
            padding: const EdgeInsetsDirectional.all(Spacing.lg),
            itemCount: reports.length,
            separatorBuilder: (_, __) => const SizedBox(height: Spacing.md),
            itemBuilder: (context, index) {
              final report = reports[index];
              return _ReportCard(report: report);
            },
          ),
        );
      },
    );
  }
}

class _ReportCard extends ConsumerWidget {
  final ReportItem report;

  const _ReportCard({required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final statusColor = report.status == 'pending'
        ? Colors.orange
        : report.status == 'resolved'
            ? Colors.green
            : Colors.grey;

    return Card(
      margin: EdgeInsetsDirectional.zero,
      child: ExpansionTile(
        tilePadding: const EdgeInsetsDirectional.fromSTEB(Spacing.lg, Spacing.sm, Spacing.lg, Spacing.sm),
        childrenPadding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(12)),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(12)),
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadiusDirectional.all(Radius.circular(10)),
          ),
          child: Icon(
            report.mediaId != null
                ? Icons.movie_rounded
                : Icons.person_rounded,
            color: statusColor,
            size: 20,
          ),
        ),
        title: Text(
          report.reasonLabel,
          style: tt.titleSmall,
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadiusDirectional.all(Radius.circular(4)),
              ),
              child: Text(
                report.status.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Text(
                _timeAgo(report.createdAt),
                style: tt.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        children: [
          if (report.description.isNotEmpty) ...[
            Align(
              alignment: AlignmentDirectional.centerStart,
          child: Text(
            report.description,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            style: tt.bodyMedium,
          ),
            ),
            const SizedBox(height: Spacing.md),
          ],
          if (report.reportedUser != null) ...[
            _buildDetailRow(context, 'Reported User', report.reportedUser?['username'] as String? ?? 'Unknown'),
            const SizedBox(height: Spacing.xs),
          ],
          if (report.mediaId != null) ...[
            _buildDetailRow(context, 'Media ID', report.mediaId.toString()),
            const SizedBox(height: Spacing.xs),
          ],
          _buildDetailRow(context, 'Reporter', report.reporter?['username'] as String? ?? 'Unknown'),
          const SizedBox(height: Spacing.lg),
          if (report.status == 'pending')
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showActionDialog(context, ref),
                    icon: const Icon(Icons.gavel_rounded, size: 18),
                    label: const Text('Take Action'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: cs.onSurface),
          ),
        ),
      ],
    );
  }

  void _showActionDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _ActionSheet(report: report),
    );
  }

  String _timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }
}

class _ActionSheet extends ConsumerWidget {
  final ReportItem report;

  const _ActionSheet({required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsetsDirectional.all(Spacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Take Action', style: tt.titleLarge),
          const SizedBox(height: Spacing.xs),
          Text(
            '${report.reasonLabel} - ${report.mediaId != null ? "Content Report" : "User Report"}',
            style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: Spacing.xl),
          _ActionButton(
            icon: Icons.warning_amber_rounded,
            color: Colors.orange,
            label: 'Warn User',
            description: 'Send a warning to the user',
            onTap: () async {
              if (report.reportedUserId != null) {
                await ref.read(warnUserProvider(report.reportedUserId!).future);
              }
              await ref.read(resolveReportProvider(report.id).future);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: Spacing.sm),
          _ActionButton(
            icon: Icons.visibility_off_rounded,
            color: Colors.blue,
            label: 'Hide Content',
            description: 'Make content invisible to users',
            onTap: () async {
              if (report.mediaId != null) {
                await ref.read(hideContentProvider(report.mediaId!).future);
              }
              await ref.read(resolveReportProvider(report.id).future);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: Spacing.sm),
          _ActionButton(
            icon: Icons.delete_forever_rounded,
            color: Colors.redAccent,
            label: 'Delete Content',
            description: 'Permanently remove this content',
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Confirm Deletion'),
                  content: const Text('Are you sure you want to permanently delete this content?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirmed == true && report.mediaId != null) {
                await ref.read(deleteContentProvider(report.mediaId!).future);
                await ref.read(resolveReportProvider(report.id).future);
                if (context.mounted) Navigator.of(context).pop();
              }
            },
          ),
          const SizedBox(height: Spacing.sm),
          _ActionButton(
            icon: Icons.block_rounded,
            color: Colors.red,
            label: 'Ban User',
            description: 'Permanently ban this user from the platform',
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Confirm Ban'),
                  content: const Text('Are you sure you want to permanently ban this user?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Ban'),
                    ),
                  ],
                ),
              );
              if (confirmed == true && report.reportedUserId != null) {
                await ref.read(banUserProvider(report.reportedUserId!).future);
                await ref.read(resolveReportProvider(report.id).future);
                if (context.mounted) Navigator.of(context).pop();
              }
            },
          ),
          const SizedBox(height: Spacing.xl),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(height: Spacing.sm),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String description;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(10)),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: Spacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: tt.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _UsersTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(reportedUsersProvider);
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return usersAsync.when(
      loading: () => const FullScreenLoader(),
      error: (e, _) => ErrorWidgetView(
        message: 'Failed to load users',
        detail: e.toString(),
        onRetry: () => ref.invalidate(reportedUsersProvider),
      ),
      data: (users) {
        if (users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline_rounded, size: 64, color: cs.onSurfaceVariant),
                const SizedBox(height: Spacing.lg),
                Text('No users found', style: tt.titleMedium),
              ],
            ),
          );
        }

        final moderators = users.where((u) => u.role == UserRole.moderator || u.role == UserRole.admin).toList();
        final regularUsers = users.where((u) => u.role == UserRole.user).toList();

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(reportedUsersProvider),
          child: ListView(
            padding: const EdgeInsetsDirectional.all(Spacing.lg),
            children: [
              if (moderators.isNotEmpty) ...[
                Text('Staff', style: tt.titleSmall?.copyWith(color: cs.onSurfaceVariant)),
                const SizedBox(height: Spacing.sm),
                ...moderators.map((user) => Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 8),
                  child: _UserCard(user: user),
                )),
                const SizedBox(height: Spacing.lg),
              ],
              Text('Users', style: tt.titleSmall?.copyWith(color: cs.onSurfaceVariant)),
              const SizedBox(height: Spacing.sm),
              ...regularUsers.map((user) => Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 8),
                child: _UserCard(user: user),
              )),
            ],
          ),
        );
      },
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserModel user;

  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final roleColor = user.role == UserRole.admin
        ? Colors.red
        : user.role == UserRole.moderator
            ? Colors.blue
            : cs.onSurfaceVariant;

    return Card(
      margin: EdgeInsetsDirectional.zero,
      child: ListTile(
        contentPadding: const EdgeInsetsDirectional.fromSTEB(Spacing.lg, Spacing.sm, Spacing.lg, Spacing.sm),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: cs.surfaceContainerHighest,
          backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
          child: user.avatarUrl == null
              ? Text(
                  (user.displayName ?? user.username)[0].toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                )
              : null,
        ),
        title: Text(
          user.displayName ?? user.username,
          style: tt.titleSmall,
        ),
        subtitle: Text(
          '@${user.username}',
          style: tt.bodySmall,
        ),
        trailing: Container(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: roleColor.withValues(alpha: 0.12),
            borderRadius: BorderRadiusDirectional.all(Radius.circular(6)),
          ),
          child: Text(
            user.role.name.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: roleColor,
            ),
          ),
        ),
      ),
    );
  }
}
