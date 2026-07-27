import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import 'service_providers.dart';

final isOnlineProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.onConnectivityChanged;
});

final authStateProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(authServiceProvider);
  return service.authStateChanges.map((_) => service.isAuthenticated);
});

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final service = ref.watch(authServiceProvider);
  if (!service.isAuthenticated) return null;
  return service.getProfile();
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final service = ref.watch(authServiceProvider);
  ref.watch(authStateProvider);
  return service.isAuthenticated;
});
