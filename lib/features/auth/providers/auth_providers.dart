import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/auth_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final bool isSignUpMode;
  final bool showResetPassword;
  final bool isNewUser;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.isSignUpMode = false,
    this.showResetPassword = false,
    this.isNewUser = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    bool? isSignUpMode,
    bool? showResetPassword,
    bool? isNewUser,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isSignUpMode: isSignUpMode ?? this.isSignUpMode,
      showResetPassword: showResetPassword ?? this.showResetPassword,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  StreamSubscription? _authSub;

  AuthNotifier(this._authService)
    : super(const AuthState(status: AuthStatus.initial)) {
    // Subscribe to real-time auth state changes from Supabase.
    // This handles:
    //   1. Session restore on startup (initialSession → authenticated)
    //   2. Session expiry or revocation (SIGNED_OUT → unauthenticated)
    //   3. External sign-out from other tabs/devices
    _authSub = _authService.authStateChanges.listen((supabaseAuth) {
      if (supabaseAuth.session != null) {
        state = AuthState(status: AuthStatus.authenticated);
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    });
    // Also check the current session synchronously in case the stream's
    // initialSession event was already emitted before we subscribed.
    if (_authService.isAuthenticated) {
      state = AuthState(status: AuthStatus.authenticated);
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authService.signIn(email, password);
      state = state.copyWith(status: AuthStatus.authenticated);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _formatError(e),
      );
    }
  }

  Future<void> signUp(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authService.signUp(email, password);
      await _authService.assignDefaultAvatar();
      state = state.copyWith(status: AuthStatus.authenticated, isNewUser: true);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _formatError(e),
      );
    }
  }

  Future<void> signInWithGoogle({String? loginHint}) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authService.signInWithGoogle(loginHint: loginHint);
      if (!kIsWeb) {
        await _authService.importOAuthProfile();
        final profile = await _authService.getProfile();
        final needsOnboarding = profile?.gender == null && profile?.dateOfBirth == null;
        state = state.copyWith(
          status: AuthStatus.authenticated,
          isNewUser: needsOnboarding,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _formatError(e),
      );
    }
  }

  Future<void> signInWithApple() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authService.signInWithApple();
      if (!kIsWeb) {
        await _authService.importOAuthProfile();
        final profile = await _authService.getProfile();
        final needsOnboarding = profile?.gender == null && profile?.dateOfBirth == null;
        state = state.copyWith(
          status: AuthStatus.authenticated,
          isNewUser: needsOnboarding,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _formatError(e),
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _authService.signOut();
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _formatError(e),
      );
    }
  }

  Future<void> resetPassword(String email) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authService.resetPassword(email);
      state = state.copyWith(
        status: AuthStatus.initial,
        showResetPassword: false,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _formatError(e),
      );
    }
  }

  void completeOnboarding() {
    state = state.copyWith(isNewUser: false);
  }

  void toggleMode() {
    state = state.copyWith(
      isSignUpMode: !state.isSignUpMode,
      errorMessage: null,
    );
  }

  void toggleResetPassword() {
    state = state.copyWith(
      showResetPassword: !state.showResetPassword,
      errorMessage: null,
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  String _formatError(Object error) {
    final message = error.toString();
    if (message.contains('Invalid login credentials')) {
      return 'Invalid email or password';
    }
    if (message.contains('Email not confirmed')) {
      return 'Please confirm your email address';
    }
    if (message.contains('User already registered')) {
      return 'An account with this email already exists';
    }
    if (message.contains('Password should be')) {
      return 'Password must be at least 6 characters';
    }
    return message.replaceAll('Exception: ', '');
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
