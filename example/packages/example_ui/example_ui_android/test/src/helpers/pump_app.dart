import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example_ui_android/src/app.dart';

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] wrapped with a [ExampleApp].
  ///
  /// Specify [locale] to test localization.
  ///
  /// Specify [themeMode] to test different appearances.
  Future<void> pumpApp(
    Widget widget, {
    Locale? locale,
    ThemeMode? themeMode,
  }) =>
      pumpWidget(
        ExampleApp.test(
          locale: locale,
          themeMode: themeMode,
          home: widget,
        ),
      );
}
