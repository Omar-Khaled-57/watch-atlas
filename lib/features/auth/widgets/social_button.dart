import 'package:flutter/material.dart';

enum SocialButtonType { google, apple }

class SocialButton extends StatelessWidget {
  final SocialButtonType type;
  final VoidCallback? onPressed;
  final bool loading;

  const SocialButton({
    super.key,
    required this.type,
    this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: loading ? null : onPressed,
        icon: loading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              )
            : _buildIcon(),
        label: Text(
          type == SocialButtonType.apple
              ? 'Continue with Apple'
              : 'Continue with Google',
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(12),
          ),
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.1),
          ),
          backgroundColor: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white,
          foregroundColor: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (type == SocialButtonType.apple) {
      return const Icon(Icons.phone_iphone_rounded, size: 22);
    }

    return const Image(
      image: AssetImage('assets/images/icons/google.png'),
      width: 22,
      height: 22,
    );
  }
}
