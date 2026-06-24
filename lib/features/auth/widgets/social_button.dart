import 'package:flutter/cupertino.dart';
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
          side: BorderSide(color: colorScheme.outlineVariant),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? colorScheme.surfaceContainerHighest
              : null,
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (type == SocialButtonType.apple) {
      return const Icon(CupertinoIcons.apple, size: 22);
    }

    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(4),
        color: Colors.white,
      ),
      child: const Text(
        'G',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4285F4),
          fontFamily: 'Product Sans',
        ),
      ),
    );
  }
}
