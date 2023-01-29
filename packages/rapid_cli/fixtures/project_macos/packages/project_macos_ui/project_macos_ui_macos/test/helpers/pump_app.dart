import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_macos_ui_macos/src/app.dart';

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] wrapped with a [ProjectMacosApp].
  Future<void> pumpApp(
    Widget widget, {
    Locale? locale,
    Brightness? brightness,
  }) =>
      pumpWidget(
        ProjectMacosApp(
          supportedLocales: [locale ?? const Locale('en')],
          locale: locale,
          brightness: brightness,
          home: widget,
        ),
      );
}
