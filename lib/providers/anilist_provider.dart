import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/anilist/anilist_service.dart';

final anilistServiceProvider = Provider<AnilistService>((ref) {
  return AnilistService();
});
