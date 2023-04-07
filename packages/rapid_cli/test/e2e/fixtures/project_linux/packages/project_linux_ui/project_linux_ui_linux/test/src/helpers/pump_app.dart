import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_linux_ui_linux/src/app.dart';

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] wrapped with a [ProjectLinuxApp].
  Future<void> pumpApp(
    Widget widget, {
    Locale? locale,
    ThemeMode? themeMode,
  }) =>
      pumpWidget(
        ProjectLinuxApp.test(
          locale: locale,
          themeMode: themeMode,
          home: widget,
        ),
      );
}
