import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_macos_macos_app/project_macos_macos_app.dart';

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] wrapped with a [App].
  Future<void> pumpApp(
    Widget widget, {
    Locale? locale,
    Brightness? brightness,
  }) =>
      pumpWidget(
        App(
          locale: locale,
          brightness: brightness,
          home: widget,
        ),
      );
}