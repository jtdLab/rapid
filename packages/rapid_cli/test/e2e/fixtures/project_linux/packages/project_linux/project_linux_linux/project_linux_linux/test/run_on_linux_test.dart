import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_linux_linux/run_on_linux.dart';

import 'mocks.dart';

void main() {
  group('runOnPlatform()', () {
    test('', () async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;

      // Act
      final callback = MockFunction();
      await runOnLinux(callback);

      // Assert
      verify(() => callback()).called(1);
    });

    test('throws when platform is not Linux', () async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

      // Act + Assert
      final callback = MockFunction();
      expect(() => runOnLinux(callback), throwsA(isA<TargetPlatformError>()));
    });
  });
}
