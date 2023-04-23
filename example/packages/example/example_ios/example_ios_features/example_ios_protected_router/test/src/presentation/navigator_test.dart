import 'package:auto_route/auto_route.dart';
import 'package:example_ios_protected_router/src/presentation/navigator.dart';
import 'package:example_ios_protected_router/src/presentation/router.gr.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

ProtectedRouterNavigator _protectedRouterNavigator(StackRouter router) {
  final protectedRouterNavigator = ProtectedRouterNavigator();
  protectedRouterNavigator.routerOverrides = router;

  return protectedRouterNavigator;
}

void main() {
  group('ProtectedRouterNavigator', () {
    group('.replace()', () {
      test('replaces with ProtectedRouterRoute', () {
        // Arrange
        final router = MockStackRouter();
        when(
          () => router.replace(const ProtectedRouterRoute()),
        ).thenAnswer((_) async => null);
        final protectedRouterNavigator = _protectedRouterNavigator(router);

        // Act
        protectedRouterNavigator.replace(FakeBuildContext());

        // Assert
        verify(() => router.replace(const ProtectedRouterRoute()));
      });
    });
  });
}
