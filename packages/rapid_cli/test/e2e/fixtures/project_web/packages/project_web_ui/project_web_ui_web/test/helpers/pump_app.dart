import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_web_ui_web/src/app.dart';

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] wrapped with a [ProjectWebApp].
  Future<void> pumpApp(
    Widget widget, {
    Locale? locale,
    ThemeMode? themeMode,
  }) =>
      pumpWidget(
        ProjectWebApp(
          supportedLocales: [locale ?? const Locale('en')],
          locale: locale,
          themeMode: themeMode,
          home: widget,
        ),
      );
}
