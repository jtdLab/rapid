import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_linux_ui_linux/src/app.dart';

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] in a [ProjectLinuxApp]-like environment.
  Future<void> pumpApp(
    Widget widget, {
    Locale? locale,
    ThemeMode? themeMode,
  }) =>
      pumpWidget(
        ProjectLinuxApp(
          supportedLocales: [locale ?? const Locale('en')],
          locale: locale,
          themeMode: themeMode,
          home: widget,
        ),
      );
}
