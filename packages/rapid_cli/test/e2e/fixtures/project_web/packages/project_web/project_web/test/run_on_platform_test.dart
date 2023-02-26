import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_web/run_on_platform.dart';

import 'mocks.dart';

void main() {
  group('.runOnPlatform()', () {
    tearDown(() {
      isWebOverrides = null;
    });

    test('runs only the android callback when platform is android', () async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      // Act
      final androidCallback = MockFunction();
      final iosCallback = MockFunction();
      final linuxCallback = MockFunction();
      final macosCallback = MockFunction();
      final webCallback = MockFunction();
      final windowsCallback = MockFunction();
      await runOnPlatform(
        android: androidCallback,
        ios: iosCallback,
        linux: linuxCallback,
        macos: macosCallback,
        web: webCallback,
        windows: windowsCallback,
      );

      // Assert
      verify(() => androidCallback()).called(1);
      verifyNever(() => iosCallback());
      verifyNever(() => linuxCallback());
      verifyNever(() => macosCallback());
      verifyNever(() => webCallback());
      verifyNever(() => windowsCallback());
    });

    test('runs only the ios callback when platform is ios', () async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      // Act
      final androidCallback = MockFunction();
      final iosCallback = MockFunction();
      final linuxCallback = MockFunction();
      final macosCallback = MockFunction();
      final webCallback = MockFunction();
      final windowsCallback = MockFunction();
      await runOnPlatform(
        android: androidCallback,
        ios: iosCallback,
        linux: linuxCallback,
        macos: macosCallback,
        web: webCallback,
        windows: windowsCallback,
      );

      // Assert
      verifyNever(() => androidCallback());
      verify(() => iosCallback()).called(1);
      verifyNever(() => linuxCallback());
      verifyNever(() => macosCallback());
      verifyNever(() => webCallback());
      verifyNever(() => windowsCallback());
    });

    test('runs only the linux callback when platform is linux', () async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;

      // Act
      final androidCallback = MockFunction();
      final iosCallback = MockFunction();
      final linuxCallback = MockFunction();
      final macosCallback = MockFunction();
      final webCallback = MockFunction();
      final windowsCallback = MockFunction();
      await runOnPlatform(
        android: androidCallback,
        ios: iosCallback,
        linux: linuxCallback,
        macos: macosCallback,
        web: webCallback,
        windows: windowsCallback,
      );

      // Assert
      verifyNever(() => androidCallback());
      verifyNever(() => iosCallback());
      verify(() => linuxCallback()).called(1);
      verifyNever(() => macosCallback());
      verifyNever(() => webCallback());
      verifyNever(() => windowsCallback());
    });

    test('runs only the macos callback when platform is macos', () async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

      // Act
      final androidCallback = MockFunction();
      final iosCallback = MockFunction();
      final linuxCallback = MockFunction();
      final macosCallback = MockFunction();
      final webCallback = MockFunction();
      final windowsCallback = MockFunction();
      await runOnPlatform(
        android: androidCallback,
        ios: iosCallback,
        linux: linuxCallback,
        macos: macosCallback,
        web: webCallback,
        windows: windowsCallback,
      );

      // Assert
      verifyNever(() => androidCallback());
      verifyNever(() => iosCallback());
      verifyNever(() => linuxCallback());
      verify(() => macosCallback()).called(1);
      verifyNever(() => webCallback());
      verifyNever(() => windowsCallback());
    });

    test('runs only the web callback when platform is web', () async {
      // Arrange
      isWebOverrides = true;

      // Act
      final androidCallback = MockFunction();
      final iosCallback = MockFunction();
      final linuxCallback = MockFunction();
      final macosCallback = MockFunction();
      final webCallback = MockFunction();
      final windowsCallback = MockFunction();
      await runOnPlatform(
        android: androidCallback,
        ios: iosCallback,
        linux: linuxCallback,
        macos: macosCallback,
        web: webCallback,
        windows: windowsCallback,
      );

      // Assert
      verifyNever(() => androidCallback());
      verifyNever(() => iosCallback());
      verifyNever(() => linuxCallback());
      verifyNever(() => macosCallback());
      verify(() => webCallback()).called(1);
      verifyNever(() => windowsCallback());
    });

    test('runs only the windows callback when platform is windows', () async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;

      // Act
      final androidCallback = MockFunction();
      final iosCallback = MockFunction();
      final linuxCallback = MockFunction();
      final macosCallback = MockFunction();
      final webCallback = MockFunction();
      final windowsCallback = MockFunction();
      await runOnPlatform(
        android: androidCallback,
        ios: iosCallback,
        linux: linuxCallback,
        macos: macosCallback,
        web: webCallback,
        windows: windowsCallback,
      );

      // Assert
      verifyNever(() => androidCallback());
      verifyNever(() => iosCallback());
      verifyNever(() => linuxCallback());
      verifyNever(() => macosCallback());
      verifyNever(() => webCallback());
      verify(() => windowsCallback()).called(1);
    });
  });
}
