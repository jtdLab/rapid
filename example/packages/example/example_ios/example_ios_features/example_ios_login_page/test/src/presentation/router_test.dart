import 'package:auto_route/auto_route.dart';
import 'package:example_ios_login_page/src/presentation/router.dart';
import 'package:flutter_test/flutter_test.dart';

LoginPageRouter _loginPageRouter() {
  return LoginPageRouter();
}

void main() {
  group('LoginPageRouter', () {
    test('has single route', () {
      final loginPageRouter = _loginPageRouter();
      expect(loginPageRouter.pagesMap, hasLength(1));
      expect(loginPageRouter.routes, hasLength(1));
    });

    test('"" -> LoginRoute', () {
      final loginPageRouter = _loginPageRouter();
      expect(
        loginPageRouter.routes.first,
        isA<AutoRoute>()
            .having(
              (e) => e.path,
              'path',
              '',
            )
            .having(
              (e) => e.name,
              'name',
              'LoginRoute',
            ),
      );
    });
  });
}
