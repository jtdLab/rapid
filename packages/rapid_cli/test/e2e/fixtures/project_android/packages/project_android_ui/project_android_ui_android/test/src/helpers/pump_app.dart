import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_android_ui_android/src/app.dart';

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] wrapped with a [ProjectAndroidApp].
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
        ProjectAndroidApp.test(
          locale: locale,
          themeMode: themeMode,
          home: widget,
        ),
      );
}
