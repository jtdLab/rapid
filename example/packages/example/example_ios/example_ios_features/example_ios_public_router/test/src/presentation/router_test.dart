import 'package:auto_route/auto_route.dart';
import 'package:example_ios_public_router/src/presentation/router.dart';
import 'package:flutter_test/flutter_test.dart';

PublicRouter _publicRouter() {
  return PublicRouter();
}

void main() {
  group('PublicRouter', () {
    test('.pagesMap', () {
      final publicRouter = _publicRouter();
      expect(publicRouter.pagesMap, hasLength(3));
    });

    test('.routes', () {
      final publicRouter = _publicRouter();
      expect(publicRouter.routes, hasLength(1));
    });

    test('"/auth" -> PublicRouterRoute', () {
      final publicRouter = _publicRouter();
      expect(
        publicRouter.routes.first,
        isA<AutoRoute>()
            .having(
              (e) => e.path,
              'path',
              '/auth',
            )
            .having(
              (e) => e.name,
              'name',
              'PublicRouterRoute',
            )
            .having(
              (e) => e.children?.routes,
              'children',
              hasLength(2),
            ),
      );
    });
  });
}
