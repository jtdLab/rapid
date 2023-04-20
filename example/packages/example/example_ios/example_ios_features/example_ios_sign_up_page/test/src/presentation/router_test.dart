import 'package:auto_route/auto_route.dart';
import 'package:example_ios_sign_up_page/src/presentation/router.dart';
import 'package:flutter_test/flutter_test.dart';

SignUpPageRouter _signUpPageRouter() {
  return SignUpPageRouter();
}

void main() {
  group('SignUpPageRouter', () {
    test('has single route', () {
      final signUpPageRouter = _signUpPageRouter();
      expect(signUpPageRouter.pagesMap, hasLength(1));
      expect(signUpPageRouter.routes, hasLength(1));
    });

    test('"sign-up" -> SignUpRoute', () {
      final signUpPageRouter = _signUpPageRouter();
      expect(
        signUpPageRouter.routes.first,
        isA<AutoRoute>()
            .having(
              (e) => e.path,
              'path',
              'sign-up',
            )
            .having(
              (e) => e.name,
              'name',
              'SignUpRoute',
            ),
      );
    });
  });
}
