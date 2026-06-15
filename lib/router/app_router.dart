import 'package:go_router/go_router.dart';

import '../features/home/home_screen.dart';
import '../features/search/search_screen.dart';
import '../features/lists/lists_screen.dart';
import '../features/reviews/reviews_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/auth/auth_screen.dart';
import '../features/media/media_detail_screen.dart';
import '../features/settings/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/lists',
      name: 'lists',
      builder: (context, state) => const ListsScreen(),
    ),
    GoRoute(
      path: '/reviews',
      name: 'reviews',
      builder: (context, state) => const ReviewsScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/media/:id',
      name: 'mediaDetail',
      builder: (context, state) => MediaDetailScreen(
        mediaId: state.pathParameters['id']!,
      ),
    ),
  ],
);
