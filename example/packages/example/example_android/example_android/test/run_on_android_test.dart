import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:example_android/run_on_android.dart';

import 'mocks.dart';

void main() {
  group('runOnPlatform()', () {
    test('', () async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      // Act
      final callback = MockFunction();
      await runOnAndroid(callback);

      // Assert
      verify(() => callback()).called(1);
    });

    test('throws when platform is not Android', () async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

      // Act + Assert
      final callback = MockFunction();
      expect(() => runOnAndroid(callback), throwsA(isA<TargetPlatformError>()));
    });
  });
}
