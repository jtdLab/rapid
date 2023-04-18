import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:example_web/run_on_web.dart';

import 'mocks.dart';

void main() {
  group('runOnPlatform()', () {
    test('', () async {
      // Arrange
      isWebOverrides = true;

      // Act
      final callback = MockFunction();
      await runOnWeb(callback);

      // Assert
      verify(() => callback()).called(1);
    });

    test('throws when platform is not Web', () async {
      // Arrange
      isWebOverrides = false;

      // Act + Assert
      final callback = MockFunction();
      expect(() => runOnWeb(callback), throwsA(isA<TargetPlatformError>()));
    });
  });
}