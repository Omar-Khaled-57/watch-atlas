import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/auth_providers.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/social_button.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    ref.listen(authNotifierProvider, (prev, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go('/');
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 24,
                vertical: 32,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(colorScheme, textTheme),
                    const SizedBox(height: 48),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.05),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: authState.showResetPassword
                          ? _buildResetPasswordForm(
                              authNotifier,
                              colorScheme,
                              textTheme,
                            )
                          : _buildAuthForm(
                              authState,
                              authNotifier,
                              colorScheme,
                            ),
                    ),
                    if (!authState.showResetPassword) ...[
                      const SizedBox(height: 24),
                      _buildDivider(colorScheme),
                      const SizedBox(height: 24),
                      SocialButton(
                        type: SocialButtonType.google,
                        onPressed: () => authNotifier.signInWithGoogle(),
                        loading: authState.status == AuthStatus.loading,
                      ),
                      const SizedBox(height: 12),
                      SocialButton(
                        type: SocialButtonType.apple,
                        onPressed: () => authNotifier.signInWithApple(),
                        loading: authState.status == AuthStatus.loading,
                      ),
                      const SizedBox(height: 24),
                      _buildToggleText(authState, authNotifier, colorScheme),
                    ],
                    if (authState.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      _buildErrorBanner(authState.errorMessage!, colorScheme),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadiusDirectional.circular(22),
          ),
          child: Icon(
            Icons.play_circle_fill_rounded,
            size: 52,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'WatchAtlas',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your personal media tracker',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthForm(
    AuthState authState,
    AuthNotifier authNotifier,
    ColorScheme colorScheme,
  ) {
    final isLoading = authState.status == AuthStatus.loading;

    return Column(
      key: const ValueKey('authForm'),
      children: [
        AuthTextField(
          controller: _emailController,
          hintText: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          enabled: !isLoading,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Please enter your email';
            if (!v.contains('@')) return 'Please enter a valid email';
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _passwordController,
          hintText: 'Password',
          icon: Icons.lock_outlined,
          obscureText: true,
          enabled: !isLoading,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Please enter your password';
            if (v.length < 6) return 'Password must be at least 6 characters';
            return null;
          },
        ),
        if (authState.isSignUpMode) ...[
          const SizedBox(height: 16),
          AuthTextField(
            controller: _confirmPasswordController,
            hintText: 'Confirm Password',
            icon: Icons.lock_outlined,
            obscureText: true,
            enabled: !isLoading,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please confirm your password';
              if (v != _passwordController.text)
                return 'Passwords do not match';
              return null;
            },
          ),
        ],
        const SizedBox(height: 8),
        if (!authState.isSignUpMode)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: isLoading
                  ? null
                  : () => authNotifier.toggleResetPassword(),
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: colorScheme.secondary),
              ),
            ),
          ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: isLoading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      if (authState.isSignUpMode) {
                        authNotifier.signUp(
                          _emailController.text.trim(),
                          _passwordController.text,
                        );
                      } else {
                        authNotifier.signIn(
                          _emailController.text.trim(),
                          _passwordController.text,
                        );
                      }
                    }
                  },
            style: FilledButton.styleFrom(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(authState.isSignUpMode ? 'Sign Up' : 'Sign In'),
          ),
        ),
      ],
    );
  }

  Widget _buildResetPasswordForm(
    AuthNotifier authNotifier,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final isLoading =
        ref.watch(authNotifierProvider).status == AuthStatus.loading;

    return Column(
      key: const ValueKey('resetPassword'),
      children: [
        Icon(Icons.lock_reset_rounded, size: 48, color: colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          'Reset Password',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your email to receive a password reset link',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        AuthTextField(
          controller: _emailController,
          hintText: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          enabled: !isLoading,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Please enter your email';
            if (!v.contains('@')) return 'Please enter a valid email';
            return null;
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: isLoading
                ? null
                : () {
                    if (_emailController.text.trim().isNotEmpty) {
                      authNotifier.resetPassword(_emailController.text.trim());
                    }
                  },
            style: FilledButton.styleFrom(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Send Reset Link'),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: isLoading
              ? null
              : () => authNotifier.toggleResetPassword(),
          child: Text(
            'Back to Sign In',
            style: TextStyle(color: colorScheme.secondary),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(child: Divider(color: colorScheme.outlineVariant)),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Text(
            'or continue with',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
        Expanded(child: Divider(color: colorScheme.outlineVariant)),
      ],
    );
  }

  Widget _buildToggleText(
    AuthState authState,
    AuthNotifier authNotifier,
    ColorScheme colorScheme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          authState.isSignUpMode
              ? 'Already have an account?'
              : "Don't have an account?",
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        TextButton(
          onPressed: () => authNotifier.toggleMode(),
          child: Text(
            authState.isSignUpMode ? 'Sign In' : 'Sign Up',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner(String error, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsetsDirectional.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadiusDirectional.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.onErrorContainer,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ),
          GestureDetector(
            onTap: () => ref.read(authNotifierProvider.notifier).clearError(),
            child: Icon(
              Icons.close,
              size: 18,
              color: colorScheme.onErrorContainer,
            ),
          ),
        ],
      ),
    );
  }
}
