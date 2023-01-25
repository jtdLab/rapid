import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_android_ui_android/src/app.dart';

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] in a [ProjectAndroidApp]-like environment.
  Future<void> pumpApp(
    Widget widget, {
    Locale? locale,
    ThemeMode? themeMode,
  }) =>
      pumpWidget(
        ProjectAndroidApp(
          supportedLocales: [locale ?? const Locale('en')],
          locale: locale,
          themeMode: themeMode,
          home: widget,
        ),
      );
}
