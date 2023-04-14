import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_macos_macos/run_on_macos.dart';

import 'mocks.dart';

void main() {
  group('runOnPlatform()', () {
    test('', () async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

      // Act
      final callback = MockFunction();
      await runOnMacos(callback);

      // Assert
      verify(() => callback()).called(1);
    });

    test('throws when platform is not macOS', () async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

      // Act + Assert
      final callback = MockFunction();
      expect(() => runOnMacos(callback), throwsA(isA<TargetPlatformError>()));
    });
  });
}
