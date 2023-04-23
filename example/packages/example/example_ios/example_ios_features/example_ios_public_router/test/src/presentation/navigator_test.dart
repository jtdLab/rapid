import 'package:example_ios_public_router/src/presentation/navigator.dart';
import 'package:example_ios_public_router/src/presentation/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

PublicRouterNavigator _publicRouterNavigator() {
  return PublicRouterNavigator();
}

void main() {
  group('PublicRouterNavigator', () {
    group('.replace()', () {
      test('replaces with PublicRouterRoute', () {
        // Arrange
        final router = MockStackRouter();
        when(
          () => router.replace(const PublicRouterRoute()),
        ).thenAnswer((_) async => null);
        final publicRouterNavigator = _publicRouterNavigator();

        // Act
        publicRouterNavigator.replace(router);

        // Assert
        verify(() => router.replace(const PublicRouterRoute()));
      });
    });
  });
}
