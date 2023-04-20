import 'package:auto_route/auto_route.dart';
import 'package:example_ios_login_page/src/presentation/navigator.dart';
import 'package:example_ios_login_page/src/presentation/router.gr.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

LoginPageNavigator _loginPageNavigator(StackRouter router) {
  final loginPageNavigator = LoginPageNavigator();
  loginPageNavigator.routerOverrides = router;

  return loginPageNavigator;
}

void main() {
  group('LoginPageNavigator', () {
    group('.navigate()', () {
      test('navigates to LoginRoute', () {
        // Arrange
        final router = MockStackRouter();
        when(
          () => router.navigate(const LoginRoute()),
        ).thenAnswer((_) async => null);
        final loginPageNavigator = _loginPageNavigator(router);

        // Act
        loginPageNavigator.navigate(FakeBuildContext());

        // Assert
        verify(() => router.navigate(const LoginRoute()));
      });
    });
  });
}
