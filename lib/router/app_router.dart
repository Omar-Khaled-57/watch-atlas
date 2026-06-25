import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers/app_providers.dart';
import '../features/auth/auth_screen.dart';
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
import '../features/search/search_screen.dart';
import '../features/search/providers/search_providers.dart';
import '../features/settings/settings_screen.dart';
import '../features/social/social_screen.dart';
import '../features/tracking/tracking_screen.dart';

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
  ref.onDispose(() => refreshNotifier.dispose());

  return GoRouter(
    refreshListenable: refreshNotifier,
    initialLocation: '/',
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final init = ref.read(appInitializationProvider);
      if (init.isLoading || init.hasError) return null;

      final auth = ref.read(authStateProvider);
      final isAuthenticated = auth.valueOrNull ?? false;
      final isAuthRoute = state.matchedLocation == '/auth';

      if (!isAuthenticated && !isAuthRoute) return '/auth';
      if (isAuthenticated && isAuthRoute) return '/';
      return null;
    },
    routes: [
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
                path: '/search',
                name: 'search',
                pageBuilder: (context, state) => _buildTabTransition(
                  child: const SearchScreen(),
                  state: state,
                ),
                routes: [
                  GoRoute(
                    path: ':query',
                    name: 'searchQuery',
                    builder: (context, state) {
                      final query = Uri.decodeComponent(state.pathParameters['query']!);
                      return _SearchWithQuery(query: query);
                    },
                  ),
                ],
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
                    path: ':id',
                    name: 'userProfile',
                    builder: (context, state) => ProfileScreen(
                      userId: state.pathParameters['id'],
                    ),
                  ),
                  GoRoute(
                    path: 'edit',
                    name: 'editProfile',
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/auth',
        name: 'auth',
        pageBuilder: (context, state) => _buildPageTransition(
          child: const AuthScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/media/:id',
        name: 'mediaDetail',
        pageBuilder: (context, state) => _buildPageTransition(
          child: MediaDetailsScreen(
            mediaId: state.pathParameters['id']!,
          ),
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
        path: '/social',
        name: 'social',
        pageBuilder: (context, state) => _buildPageTransition(
          child: const SocialScreen(),
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
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => _buildPageTransition(
          child: const SettingsScreen(),
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

class _SearchWithQuery extends ConsumerStatefulWidget {
  final String query;

  const _SearchWithQuery({required this.query});

  @override
  ConsumerState<_SearchWithQuery> createState() => _SearchWithQueryState();
}

class _SearchWithQueryState extends ConsumerState<_SearchWithQuery> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(searchQueryProvider.notifier).state = widget.query;
    });
  }

  @override
  Widget build(BuildContext context) => const SearchScreen();
}

class ShellScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ShellScaffold({super.key, required this.navigationShell});

  static const _destinations = (
    home: _NavDest(Icons.home_rounded, Icons.home_outlined, 'Home'),
    discover: _NavDest(Icons.explore_rounded, Icons.explore_outlined, 'Discover'),
    search: _NavDest(Icons.search_rounded, Icons.search_off_outlined, 'Search'),
    lists: _NavDest(Icons.folder_rounded, Icons.folder_outlined, 'Lists'),
    profile: _NavDest(Icons.person_rounded, Icons.person_outlined, 'Profile'),
  );

  static final _navItems = [
    _destinations.home,
    _destinations.discover,
    _destinations.search,
    _destinations.lists,
    _destinations.profile,
  ];

  @override
  Widget build(BuildContext context) {
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
      body: navigationShell,
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
        destinations: ShellScaffold._navItems.map((item) {
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
    final colorScheme = Theme.of(context).colorScheme;
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
              child: Icon(
                Icons.explore_rounded,
                color: colorScheme.primary,
                size: 32,
              ),
            ),
            trailing: Padding(
              padding: const EdgeInsetsDirectional.only(top: 16),
              child: IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => context.go('/settings'),
                tooltip: 'Settings',
              ),
            ),
            destinations: ShellScaffold._navItems.map((item) {
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
