import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(context.l10n.reviewsScreen),
      ),
    );
  }
}
