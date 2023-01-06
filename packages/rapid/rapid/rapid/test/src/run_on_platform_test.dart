import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid/src/run_on_platform.dart';

abstract class _Function {
  Future<void> call();
}

class _MockFunction extends Mock implements _Function {}

void main() {
  group('.runOnPlatform', () {
    late Future<void> Function() androidCallback;
    late Future<void> Function() iosCallback;
    late Future<void> Function() linuxCallback;
    late Future<void> Function() macosCallback;
    late Future<void> Function() webCallback;
    late Future<void> Function() windowsCallback;

    setUp(() {
      androidCallback = _MockFunction();
      when(() => androidCallback()).thenAnswer((_) async {});
      iosCallback = _MockFunction();
      when(() => iosCallback()).thenAnswer((_) async {});
      linuxCallback = _MockFunction();
      when(() => linuxCallback()).thenAnswer((_) async {});
      macosCallback = _MockFunction();
      when(() => macosCallback()).thenAnswer((_) async {});
      webCallback = _MockFunction();
      when(() => webCallback()).thenAnswer((_) async {});
      windowsCallback = _MockFunction();
      when(() => windowsCallback()).thenAnswer((_) async {});
    });

    tearDown(() {
      isWebOverrides = null;
    });

    test('runs only the android callback when platform is android', () async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      // Act
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
