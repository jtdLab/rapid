import 'package:auto_route/auto_route.dart';
import 'package:example_di/example_di.dart';
import 'package:example_domain/example_domain.dart';
import 'package:example_ios_navigation/example_ios_navigation.dart';
import 'package:example_ios_protected_router/src/presentation/router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

ProtectedRouter _protectedRouter([AuthGuard? authGuard]) {
  getIt.registerSingleton<AuthGuard>(authGuard ?? MockAuthGuard());

  return ProtectedRouter();
}

AuthGuard _authGuard([
  IAuthService? authService,
  IPublicRouterNavigator? publicRouterNavigator,
]) {
  return AuthGuard(
    authService ?? MockAuthService(),
    publicRouterNavigator ?? MockPublicRouterNavigator(),
  );
}

void main() {
  group('ProtectedRouter', () {
    tearDown(() async {
      await getIt.reset();
    });

    test('.pagesMap', () {
      final protectedRouter = _protectedRouter();
      expect(protectedRouter.pagesMap, hasLength(2));
    });

    test('.routes', () {
      final protectedRouter = _protectedRouter();
      expect(protectedRouter.routes, hasLength(1));
    });

    test('"/" -> ProtectedRouterRoute', () {
      final authGuard = MockAuthGuard();
      final protectedRouter = _protectedRouter(authGuard);
      expect(
        protectedRouter.routes.first,
        isA<AutoRoute>()
            .having(
              (e) => e.path,
              'path',
              '/',
            )
            .having(
              (e) => e.name,
              'name',
              'ProtectedRouterRoute',
            )
            .having(
              (e) => e.children?.routes,
              'children',
              hasLength(1),
            )
            .having(
              (e) => e.guards,
              'guards',
              contains(authGuard),
            ),
      );
    });
  });

  group('AuthGuard', () {
    test('continues navigation when authenticated', () {
      final authService = MockAuthService();
      when(() => authService.isAuthenticated()).thenReturn(true);
      final authGuard = _authGuard(authService);

      final resolver = MockNavigationResolver();
      final router = MockStackRouter();
      authGuard.onNavigation(resolver, router);

      verify(() => resolver.next(true)).called(1);
    });

    test(
        'aborts navigation and redirects to public router when not authenticated',
        () {
      final authService = MockAuthService();
      when(() => authService.isAuthenticated()).thenReturn(false);
      final publicRouterNavigator = MockPublicRouterNavigator();
      final authGuard = _authGuard(authService, publicRouterNavigator);

      final resolver = MockNavigationResolver();
      final router = MockStackRouter();
      authGuard.onNavigation(resolver, router);

      verify(() => publicRouterNavigator.replace(router)).called(1);
      verify(() => resolver.next(false)).called(1);
    });
  });
}
