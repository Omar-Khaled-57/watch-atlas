import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers/app_providers.dart';
import '../features/auth/auth_screen.dart';
import '../features/auth/providers/auth_providers.dart';
import '../l10n/l10n.dart';
import '../features/splash/splash_screen.dart';
import '../features/analytics/analytics_screen.dart';
import '../features/discover/discover_screen.dart';
import '../features/home/home_screen.dart';
import '../features/lists/lists_screen.dart';
import '../features/lists/list_detail_screen.dart';
import '../features/media/media_details_screen.dart';
import '../features/moderation/moderation_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/profile/edit_profile_screen.dart';
import '../features/auth/onboarding_screen.dart';
import '../features/tracking/tracking_screen.dart';
import '../features/legal/privacy_screen.dart';
import '../features/legal/terms_screen.dart';
import '../features/legal/licenses_screen.dart';
import '../features/legal/attribution_screen.dart';
import '../features/recommendations/recommendations_screen.dart';

class _RouterRefreshNotifier extends ChangeNotifier {
  void requestRefresh() {
    notifyListeners();
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier();

  ref.listen(authStateProvider, (prev, next) {
    refreshNotifier.requestRefresh();
  });
  ref.listen(authNotifierProvider, (prev, next) {
    refreshNotifier.requestRefresh();
  });
  ref.listen(appInitializationProvider, (prev, next) {
    refreshNotifier.requestRefresh();
  });
  ref.onDispose(() => refreshNotifier.dispose());

  return GoRouter(
    refreshListenable: refreshNotifier,
    initialLocation: '/splash',
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final init = ref.read(appInitializationProvider);
      final isSplashRoute = state.matchedLocation == '/splash';

      if (init.isLoading) {
        if (!isSplashRoute) return '/splash';
        return null;
      }

      final authState = ref.read(authNotifierProvider);

      // Auth resolution still in progress — stay on splash
      if (authState.status == AuthStatus.initial || authState.status == AuthStatus.loading) {
        if (!isSplashRoute) return '/splash';
        return null;
      }

      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isAuthRoute = state.matchedLocation == '/auth';
      final location = state.matchedLocation;
      final isPublicRoute = location == '/privacy' || location == '/terms';

      if (isSplashRoute) return isAuthenticated ? '/' : '/auth';
      if (!isAuthenticated && !isAuthRoute && !isPublicRoute) return '/auth';
      if (isAuthenticated && isAuthRoute) return '/';

      final isOnboardingRoute = state.matchedLocation == '/onboarding';
      if (isAuthenticated && authState.isNewUser && !isOnboardingRoute) return '/onboarding';
      if (isOnboardingRoute && !authState.isNewUser) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/discover',
                name: 'discover',
                pageBuilder: (context, state) => _buildTabTransition(
                  child: const DiscoverScreen(),
                  state: state,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/lists',
                name: 'lists',
                pageBuilder: (context, state) => _buildTabTransition(
                  child: const ListsScreen(),
                  state: state,
                ),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: 'listDetail',
                    builder: (context, state) => ListDetailScreen(
                      listId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                pageBuilder: (context, state) => _buildTabTransition(
                  child: const ProfileScreen(),
                  state: state,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'editProfile',
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    name: 'userProfile',
                    builder: (context, state) => ProfileScreen(
                      userId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/media/:type/:id',
        name: 'mediaDetail',
        pageBuilder: (context, state) => _buildPageTransition(
          child: MediaDetailsScreen(
            mediaId: state.pathParameters['id']!,
            mediaType: state.pathParameters['type'] ?? 'movie',
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) => _buildPageTransition(
          child: const OnboardingScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/tracking',
        name: 'tracking',
        pageBuilder: (context, state) => _buildPageTransition(
          child: const TrackingScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        pageBuilder: (context, state) => _buildPageTransition(
          child: const NotificationsScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/analytics',
        name: 'analytics',
        pageBuilder: (context, state) => _buildPageTransition(
          child: const AnalyticsScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/moderation',
        name: 'moderation',
        pageBuilder: (context, state) => _buildPageTransition(
          child: const ModerationScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/recommendations',
        name: 'recommendations',
        pageBuilder: (context, state) => _buildPageTransition(
          child: const RecommendationsScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/privacy',
        name: 'privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: '/terms',
        name: 'terms',
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: '/licenses',
        name: 'licenses',
        builder: (context, state) => const LicensesScreen(),
      ),
      GoRoute(
        path: '/attribution',
        name: 'attribution',
        builder: (context, state) => const AttributionScreen(),
      ),
    ],
  );
});

Page<T> _buildPageTransition<T>({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.03, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 250),
  );
}

Page<T> _buildTabTransition<T>({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
}

class ShellScaffold extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const ShellScaffold({super.key, required this.navigationShell});

  static List<_NavDest> _navItems(BuildContext context) {
    final l10n = context.l10n;
    return [
      _NavDest(Icons.home_rounded, Icons.home_outlined, l10n.navHome),
      _NavDest(Icons.explore_rounded, Icons.explore_outlined, l10n.discover),
      _NavDest(Icons.folder_rounded, Icons.folder_outlined, l10n.navLists),
      _NavDest(Icons.person_rounded, Icons.person_outlined, l10n.navProfile),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          return _DesktopShell(navigationShell: navigationShell);
        }
        return _MobileShell(navigationShell: navigationShell);
      },
    );
  }
}

class _NavDest {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;

  const _NavDest(this.activeIcon, this.inactiveIcon, this.label);
}

class _MobileShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _MobileShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: navigationShell,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        animationDuration: const Duration(milliseconds: 300),
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: ShellScaffold._navItems(context).map((item) {
          return NavigationDestination(
            icon: Icon(item.inactiveIcon),
            selectedIcon: Icon(item.activeIcon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class _DesktopShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _DesktopShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          NavigationRail(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 16),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                      blurRadius: 12,
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/images/logo/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            trailing: Padding(
              padding: const EdgeInsetsDirectional.only(top: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                ],
              ),
            ),
            destinations: ShellScaffold._navItems(context).map((item) {
              return NavigationRailDestination(
                icon: Icon(item.inactiveIcon),
                selectedIcon: Icon(item.activeIcon),
                label: Text(item.label),
              );
            }).toList(),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}