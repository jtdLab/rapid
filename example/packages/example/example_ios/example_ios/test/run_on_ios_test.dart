import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:example_ios/run_on_ios.dart';

import 'mocks.dart';

void main() {
  group('runOnPlatform()', () {
    test('', () async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      // Act
      final callback = MockFunction();
      await runOnIos(callback);

      // Assert
      verify(() => callback()).called(1);
    });

    test('throws when platform is not iOS', () async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

      // Act + Assert
      final callback = MockFunction();
      expect(() => runOnIos(callback), throwsA(isA<TargetPlatformError>()));
    });
  });
}
