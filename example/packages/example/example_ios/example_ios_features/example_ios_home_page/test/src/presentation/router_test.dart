import 'package:auto_route/auto_route.dart';
import 'package:example_ios_home_page/src/presentation/router.dart';
import 'package:flutter_test/flutter_test.dart';

HomePageRouter _homePageRouter() {
  return HomePageRouter();
}

void main() {
  group('HomePageRouter', () {
    test('has single route', () {
      final homePageRouter = _homePageRouter();
      expect(homePageRouter.pagesMap, hasLength(1));
      expect(homePageRouter.routes, hasLength(1));
    });

    test('"" -> HomeRoute', () {
      final homePageRouter = _homePageRouter();
      expect(
        homePageRouter.routes.first,
        isA<AutoRoute>()
            .having(
              (e) => e.path,
              'path',
              '',
            )
            .having(
              (e) => e.name,
              'name',
              'HomeRoute',
            ),
      );
    });
  });
}
