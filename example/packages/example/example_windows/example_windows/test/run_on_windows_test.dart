import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:example_windows/run_on_windows.dart';

import 'mocks.dart';

void main() {
  group('runOnPlatform()', () {
    test('', () async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;

      // Act
      final callback = MockFunction();
      await runOnWindows(callback);

      // Assert
      verify(() => callback()).called(1);
    });

    test('throws when platform is not Windows', () async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

      // Act + Assert
      final callback = MockFunction();
      expect(() => runOnWindows(callback), throwsA(isA<TargetPlatformError>()));
    });
  });
}
