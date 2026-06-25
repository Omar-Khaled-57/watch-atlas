import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({
    super.key,
    required this.child,
  });

  static const _destinations = (
    home: _NavDestination(Icons.home_rounded, Icons.home_outlined, 'Home', '/'),
    discover: _NavDestination(Icons.explore_rounded, Icons.explore_outlined, 'Discover', '/discover'),
    search: _NavDestination(Icons.search_rounded, Icons.search_off_outlined, 'Search', '/search'),
    lists: _NavDestination(Icons.folder_rounded, Icons.folder_outlined, 'Lists', '/lists'),
    profile: _NavDestination(Icons.person_rounded, Icons.person_outlined, 'Profile', '/profile'),
  );

  static final _navItems = [
    _destinations.home,
    _destinations.discover,
    _destinations.search,
    _destinations.lists,
    _destinations.profile,
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return _navItems.indexWhere((item) => item.path == location);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          return _DesktopScaffold(
            currentIndex: _currentIndex(context),
            child: child,
          );
        }
        return _MobileScaffold(
          currentIndex: _currentIndex(context),
          child: child,
        );
      },
    );
  }
}

class _NavDestination {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  final String path;

  const _NavDestination(this.activeIcon, this.inactiveIcon, this.label, this.path);
}

class _MobileScaffold extends StatelessWidget {
  final int currentIndex;
  final Widget child;

  const _MobileScaffold({
    required this.currentIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: KeyedSubtree(
          key: ValueKey(currentIndex),
          child: child,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex >= 0 ? currentIndex : 0,
        onDestinationSelected: (index) {
          if (index >= 0 && index < AppScaffold._navItems.length) {
            context.go(AppScaffold._navItems[index].path);
          }
        },
        animationDuration: const Duration(milliseconds: 300),
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: AppScaffold._navItems.map((item) {
          final isSelected = AppScaffold._navItems.indexOf(item) == currentIndex;
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

class _DesktopScaffold extends StatelessWidget {
  final int currentIndex;
  final Widget child;

  const _DesktopScaffold({
    required this.currentIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex >= 0 ? currentIndex : 0,
            onDestinationSelected: (index) {
              if (index >= 0 && index < AppScaffold._navItems.length) {
                context.go(AppScaffold._navItems[index].path);
              }
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
            destinations: AppScaffold._navItems.map((item) {
              final isSelected = AppScaffold._navItems.indexOf(item) == currentIndex;
              return NavigationRailDestination(
                icon: Icon(item.inactiveIcon),
                selectedIcon: Icon(item.activeIcon),
                label: Text(item.label),
              );
            }).toList(),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: KeyedSubtree(
                key: ValueKey(currentIndex),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
