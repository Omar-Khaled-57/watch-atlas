import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Router redirect logic', () {
    String? redirect({
      required String currentLocation,
      required bool isLoading,
      required String authStatus,
      required bool isNewUser,
    }) {
      final isSplashRoute = currentLocation == '/splash';

      if (isLoading) {
        if (!isSplashRoute) return '/splash';
        return null;
      }

      final isAuthenticated = authStatus == 'authenticated';
      final isAuthRoute = currentLocation == '/auth';
      final isPublicRoute = currentLocation == '/privacy' || currentLocation == '/terms';

      if (isSplashRoute) return isAuthenticated ? '/' : '/auth';
      if (!isAuthenticated && !isAuthRoute && !isPublicRoute) return '/auth';
      if (isAuthenticated && isAuthRoute) return '/';

      final isOnboardingRoute = currentLocation == '/onboarding';
      if (isAuthenticated && isNewUser && !isOnboardingRoute) return '/onboarding';
      if (isOnboardingRoute && !isNewUser) return '/';

      return null;
    };

    test('redirects to splash when loading', () {
      expect(redirect(currentLocation: '/', isLoading: true, authStatus: 'initial', isNewUser: false), '/splash');
      expect(redirect(currentLocation: '/auth', isLoading: true, authStatus: 'initial', isNewUser: false), '/splash');
    });

    test('stays on splash when loading and already on splash', () {
      expect(redirect(currentLocation: '/splash', isLoading: true, authStatus: 'initial', isNewUser: false), isNull);
    });

    test('redirects splash to home when authenticated', () {
      expect(redirect(currentLocation: '/splash', isLoading: false, authStatus: 'authenticated', isNewUser: false), '/');
    });

    test('redirects splash to auth when not authenticated', () {
      expect(redirect(currentLocation: '/splash', isLoading: false, authStatus: 'unauthenticated', isNewUser: false), '/auth');
    });

    test('redirects to auth when not authenticated', () {
      expect(redirect(currentLocation: '/', isLoading: false, authStatus: 'unauthenticated', isNewUser: false), '/auth');
      expect(redirect(currentLocation: '/discover', isLoading: false, authStatus: 'unauthenticated', isNewUser: false), '/auth');
      expect(redirect(currentLocation: '/profile', isLoading: false, authStatus: 'unauthenticated', isNewUser: false), '/auth');
    });

    test('does not redirect public routes when not authenticated', () {
      expect(redirect(currentLocation: '/privacy', isLoading: false, authStatus: 'unauthenticated', isNewUser: false), isNull);
      expect(redirect(currentLocation: '/terms', isLoading: false, authStatus: 'unauthenticated', isNewUser: false), isNull);
    });

    test('redirects away from auth when authenticated', () {
      expect(redirect(currentLocation: '/auth', isLoading: false, authStatus: 'authenticated', isNewUser: false), '/');
    });

    test('redirects new users to onboarding', () {
      expect(redirect(currentLocation: '/', isLoading: false, authStatus: 'authenticated', isNewUser: true), '/onboarding');
      expect(redirect(currentLocation: '/discover', isLoading: false, authStatus: 'authenticated', isNewUser: true), '/onboarding');
    });

    test('redirects away from onboarding for non-new users', () {
      expect(redirect(currentLocation: '/onboarding', isLoading: false, authStatus: 'authenticated', isNewUser: false), '/');
    });

    test('stays on onboarding for new users', () {
      expect(redirect(currentLocation: '/onboarding', isLoading: false, authStatus: 'authenticated', isNewUser: true), isNull);
    });

    test('stays on valid authenticated routes', () {
      expect(redirect(currentLocation: '/', isLoading: false, authStatus: 'authenticated', isNewUser: false), isNull);
      expect(redirect(currentLocation: '/discover', isLoading: false, authStatus: 'authenticated', isNewUser: false), isNull);
      expect(redirect(currentLocation: '/lists', isLoading: false, authStatus: 'authenticated', isNewUser: false), isNull);
      expect(redirect(currentLocation: '/profile', isLoading: false, authStatus: 'authenticated', isNewUser: false), isNull);
    });
  });
}
