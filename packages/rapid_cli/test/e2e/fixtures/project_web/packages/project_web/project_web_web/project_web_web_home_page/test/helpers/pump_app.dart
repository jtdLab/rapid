import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_web_web_app/project_web_web_app.dart';

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] wrapped with a [App].
  Future<void> pumpApp(
    Widget widget, {
    Locale? locale,
    ThemeMode? themeMode,
  }) =>
      pumpWidget(
        App(
          locale: locale,
          themeMode: themeMode,
          home: widget,
        ),
      );
}
