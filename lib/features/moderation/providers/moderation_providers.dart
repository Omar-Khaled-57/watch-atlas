import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/media_enums.dart';
import '../../../core/providers/app_providers.dart';
import '../../../models/user_model.dart';

final userRoleProvider = Provider<UserRole>((ref) {
  final user = ref.watch(currentUserProvider);
  return user.value?.role ?? UserRole.user;
});

final isModeratorProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role == UserRole.moderator || role == UserRole.admin;
});

final reportsProvider = FutureProvider<List<ReportItem>>((ref) async {
  final isMod = ref.watch(isModeratorProvider);
  if (!isMod) return [];
  final supabase = ref.watch(supabaseServiceProvider);
  final client = supabase.client;
  final response = await client
      .from('reports')
      .select('*, reporter:reporter_id(*), reported_user:reported_user_id(*)')
      .order('created_at', ascending: false);
  return (response as List<dynamic>).map((json) => ReportItem.fromJson(json as Map<String, dynamic>)).toList();
});

final resolveReportProvider = FutureProvider.family<void, String>((ref, reportId) async {
  final supabase = ref.watch(supabaseServiceProvider);
  await supabase.client.from('reports').update({
    'status': 'resolved',
    'resolved_at': DateTime.now().toIso8601String(),
  }).eq('id', reportId);
  ref.invalidate(reportsProvider);
});

final hideContentProvider = FutureProvider.family<void, int>((ref, mediaId) async {
  final supabase = ref.watch(supabaseServiceProvider);
  await supabase.client.from('media').update({
    'status': 'hidden',
    'updated_at': DateTime.now().toIso8601String(),
  }).eq('id', mediaId);
});

final deleteContentProvider = FutureProvider.family<void, int>((ref, mediaId) async {
  final supabase = ref.watch(supabaseServiceProvider);
  await supabase.client.from('media').delete().eq('id', mediaId);
});

final banUserProvider = FutureProvider.family<void, String>((ref, userId) async {
  final supabase = ref.watch(supabaseServiceProvider);
  await supabase.client.from('profiles').update({
    'role': 'banned',
    'updated_at': DateTime.now().toIso8601String(),
  }).eq('id', userId);
  ref.invalidate(reportsProvider);
});

final warnUserProvider = FutureProvider.family<void, String>((ref, userId) async {
  final supabase = ref.watch(supabaseServiceProvider);
  await supabase.client.from('profiles').update({
    'warning_count': supabase.client.rpc('increment_warning_count', params: {'user_id': userId}),
    'updated_at': DateTime.now().toIso8601String(),
  }).eq('id', userId);
  ref.invalidate(reportsProvider);
});

final reportedUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  final isMod = ref.watch(isModeratorProvider);
  if (!isMod) return [];
  final supabase = ref.watch(supabaseServiceProvider);
  final response = await supabase.client
      .from('profiles')
      .select()
      .order('created_at', ascending: false);
  return (response as List<dynamic>).map((json) => UserModel.fromJson(json as Map<String, dynamic>)).toList();
});

class ReportItem {
  final String id;
  final String reporterId;
  final String? reportedUserId;
  final int? mediaId;
  final ReportReason reason;
  final String description;
  final String status;
  final DateTime createdAt;
  final Map<String, dynamic>? reporter;
  final Map<String, dynamic>? reportedUser;

  ReportItem({
    required this.id,
    required this.reporterId,
    this.reportedUserId,
    this.mediaId,
    required this.reason,
    required this.description,
    required this.status,
    required this.createdAt,
    this.reporter,
    this.reportedUser,
  });

  factory ReportItem.fromJson(Map<String, dynamic> json) {
    final reasonStr = json['reason'] as String? ?? 'other';
    return ReportItem(
      id: json['id'] as String,
      reporterId: json['reporter_id'] as String,
      reportedUserId: json['reported_user_id'] as String?,
      mediaId: json['media_id'] as int?,
      reason: ReportReason.values.firstWhere(
        (r) => r.name == reasonStr,
        orElse: () => ReportReason.other,
      ),
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      reporter: json['reporter'] as Map<String, dynamic>?,
      reportedUser: json['reported_user'] as Map<String, dynamic>?,
    );
  }

  String get reasonLabel {
    switch (reason) {
      case ReportReason.spam:
        return 'Spam';
      case ReportReason.inappropriate:
        return 'Inappropriate';
      case ReportReason.copyright:
        return 'Copyright';
      case ReportReason.incorrect:
        return 'Incorrect';
      case ReportReason.other:
        return 'Other';
    }
  }
}
