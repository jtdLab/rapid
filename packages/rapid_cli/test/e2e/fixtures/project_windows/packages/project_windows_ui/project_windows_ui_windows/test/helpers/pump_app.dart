import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_windows_ui_windows/src/app.dart';

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] wrapped with a [ProjectWindowsApp].
  Future<void> pumpApp(
    Widget widget, {
    Locale? locale,
    ThemeMode? themeMode,
  }) =>
      pumpWidget(
        ProjectWindowsApp(
          supportedLocales: [locale ?? const Locale('en')],
          locale: locale,
          themeMode: themeMode,
          home: widget,
        ),
      );
}
