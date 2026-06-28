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

class AuthNotifier extends Notifier<AuthState> {
  late final AuthService _authService;
  StreamSubscription? _authSub;

  @override
  AuthState build() {
    _authService = ref.read(authServiceProvider);
    _authSub = _authService.authStateChanges.listen((supabaseAuth) {
      if (supabaseAuth.session != null) {
        state = AuthState(status: AuthStatus.authenticated);
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    });
    if (_authService.isAuthenticated) {
      state = AuthState(status: AuthStatus.authenticated);
    }
    ref.onDispose(() => _authSub?.cancel());
    return const AuthState(status: AuthStatus.initial);
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

  void forceUnauthenticated() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  String _formatError(Object error) {
    final message = error.toString();
    if (message.contains('Invalid login credentials')) {
      return 'invalidEmailOrPassword';
    }
    if (message.contains('Email not confirmed')) {
      return 'pleaseConfirmEmail';
    }
    if (message.contains('User already registered')) {
      return 'accountAlreadyExists';
    }
    if (message.contains('Password should be')) {
      return 'passwordMinLength';
    }
    if (message.contains('Account created!')) {
      return 'accountCreated';
    }
    return message.replaceAll('Exception: ', '');
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
