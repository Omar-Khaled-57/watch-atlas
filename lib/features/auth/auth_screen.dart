import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';
import '../../core/constants/dimensions.dart';
import '../../core/services/auth_service.dart';
import 'providers/auth_providers.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/google_account_picker.dart';
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

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 680) {
                  return _buildLandscape(
                    authState, authNotifier, colorScheme, textTheme,
                  );
                }
                return _buildPortrait(
                  authState, authNotifier, colorScheme, textTheme,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPortrait(
    AuthState authState,
    AuthNotifier authNotifier,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: Spacing.xl, vertical: Spacing.xxl),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(colorScheme, textTheme),
            const SizedBox(height: Spacing.section),
            _buildFormSection(authState, authNotifier, colorScheme, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscape(
    AuthState authState,
    AuthNotifier authNotifier,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 40, vertical: 48),
      child: Form(
        key: _formKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _buildHeader(colorScheme, textTheme, large: true),
            ),
            Container(
              width: 1,
              height: 320,
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 48),
              color: colorScheme.brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
            ),
            Expanded(
              child: _buildFormSection(
                authState, authNotifier, colorScheme, textTheme,
                compact: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme, {bool large = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: large ? 140 : 100,
          height: large ? 140 : 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(large ? 34 : 25),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                blurRadius: 24,
                spreadRadius: 0,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/logo/logo.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 20),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF00D4FF), Color(0xFF8B5CF6)],
            begin: Alignment(-0.5, -0.5),
            end: Alignment(0.5, 0.5),
          ).createShader(bounds),
          child: Text(
            context.l10n.appName,
            style: (large ? textTheme.displaySmall : textTheme.headlineMedium)
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
          const SizedBox(height: Spacing.sm),
        Text(
          context.l10n.splashSubtitle,
          style: (large ? textTheme.titleMedium : textTheme.bodyLarge)?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection(
    AuthState authState,
    AuthNotifier authNotifier,
    ColorScheme colorScheme,
    TextTheme textTheme, {
    bool compact = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
              ? _buildResetPasswordForm(authNotifier, colorScheme, textTheme)
              : _buildAuthForm(authState, authNotifier, colorScheme),
        ),
        if (!authState.showResetPassword) ...[
          SizedBox(height: compact ? 20 : 24),
          _buildDivider(colorScheme),
          SizedBox(height: compact ? 20 : 24),
          SocialButton(
            type: SocialButtonType.google,
            onPressed: () async {
              final accounts = await AuthService.instance.getSavedGoogleAccounts();
              if (!mounted) return;
              final picked = await showGoogleAccountPicker(
                context: context,
                accounts: accounts,
              );
              if (picked == null || !mounted) return;
              authNotifier.signInWithGoogle(
                loginHint: picked == '__other__' || picked == '__continue__'
                    ? null
                    : picked,
              );
            },
            loading: authState.status == AuthStatus.loading,
          ),
          SizedBox(height: compact ? 20 : 24),
          _buildToggleText(authState, authNotifier, colorScheme),
        ],
        if (authState.errorMessage != null) ...[
          const SizedBox(height: Spacing.lg),
          _buildErrorBanner(authState.errorMessage!, colorScheme),
        ],
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
          hintText: context.l10n.email,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          enabled: !isLoading,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return context.l10n.pleaseEnterEmail;
            if (!v.contains('@')) return context.l10n.pleaseEnterEmail;
            return null;
          },
        ),
            const SizedBox(height: Spacing.lg),
            AuthTextField(
          controller: _passwordController,
          hintText: context.l10n.password,
          icon: Icons.lock_outlined,
          obscureText: true,
          enabled: !isLoading,
          validator: (v) {
            if (v == null || v.isEmpty) return context.l10n.pleaseEnterPassword;
            if (v.length < 6) return context.l10n.passwordMinLength;
            return null;
          },
        ),
        if (authState.isSignUpMode) ...[
          const SizedBox(height: Spacing.lg),
          AuthTextField(
            controller: _confirmPasswordController,
            hintText: context.l10n.confirmPassword,
            icon: Icons.lock_outlined,
            obscureText: true,
            enabled: !isLoading,
            validator: (v) {
              if (v == null || v.isEmpty) return context.l10n.pleaseConfirmPassword;
              if (v != _passwordController.text) return context.l10n.passwordsDoNotMatch;
              return null;
            },
          ),
        ],
          const SizedBox(height: Spacing.sm),
        if (!authState.isSignUpMode)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: isLoading ? null : () => authNotifier.toggleResetPassword(),
              child: Text(
                context.l10n.forgotPassword,
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
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(authState.isSignUpMode ? context.l10n.signUp : context.l10n.signIn),
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
    final isLoading = ref.watch(authNotifierProvider).status == AuthStatus.loading;

    return Column(
      key: const ValueKey('resetPassword'),
      children: [
        Icon(Icons.lock_reset_rounded, size: 48, color: colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          context.l10n.forgotPassword,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
          const SizedBox(height: Spacing.sm),
        Text(
          context.l10n.enterEmailForReset,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
          const SizedBox(height: Spacing.xl),
        AuthTextField(
          controller: _emailController,
          hintText: context.l10n.email,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          enabled: !isLoading,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return context.l10n.pleaseEnterEmail;
            if (!v.contains('@')) return context.l10n.pleaseEnterEmail;
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
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(context.l10n.sendResetLink),
          ),
        ),
          const SizedBox(height: Spacing.sm),
        TextButton(
          onPressed: isLoading ? null : () => authNotifier.toggleResetPassword(),
          child: Text(context.l10n.backToSignIn, style: TextStyle(color: colorScheme.secondary)),
        ),
      ],
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(child: Divider(color: colorScheme.outlineVariant)),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
          child: Text(context.l10n.orContinueWith, style: TextStyle(color: colorScheme.onSurfaceVariant)),
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
              ? context.l10n.alreadyHaveAccount
              : context.l10n.dontHaveAccount,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        TextButton(
          onPressed: () => authNotifier.toggleMode(),
          child: Text(
            authState.isSignUpMode ? context.l10n.signIn : context.l10n.signUp,
            style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner(String error, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsetsDirectional.all(Spacing.md),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadiusDirectional.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.onErrorContainer, size: 20),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(error, style: TextStyle(color: colorScheme.onErrorContainer)),
          ),
          GestureDetector(
            onTap: () => ref.read(authNotifierProvider.notifier).clearError(),
            child: Icon(Icons.close, size: 18, color: colorScheme.onErrorContainer),
          ),
        ],
      ),
    );
  }
}
