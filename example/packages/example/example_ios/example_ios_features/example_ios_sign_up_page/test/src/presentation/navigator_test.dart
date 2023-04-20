import 'package:auto_route/auto_route.dart';
import 'package:example_ios_sign_up_page/src/presentation/navigator.dart';
import 'package:example_ios_sign_up_page/src/presentation/router.gr.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

SignUpPageNavigator _signUpPageNavigator(StackRouter router) {
  final signUpPageNavigator = SignUpPageNavigator();
  signUpPageNavigator.routerOverrides = router;

  return signUpPageNavigator;
}

void main() {
  group('SignUpPageNavigator', () {
    group('.navigate()', () {
      test('navigates to SignUpRoute', () {
        // Arrange
        final router = MockStackRouter();
        when(
          () => router.navigate(const SignUpRoute()),
        ).thenAnswer((_) async => null);
        final signUpPageNavigator = _signUpPageNavigator(router);

        // Act
        signUpPageNavigator.navigate(FakeBuildContext());

        // Assert
        verify(() => router.navigate(const SignUpRoute()));
      });
    });
  });
}
