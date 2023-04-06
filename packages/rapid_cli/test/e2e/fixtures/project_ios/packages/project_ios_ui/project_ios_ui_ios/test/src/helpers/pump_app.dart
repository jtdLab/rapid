import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_ios_ui_ios/src/app.dart';

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] wrapped with a [ProjectIosApp].
  Future<void> pumpApp(
    Widget widget, {
    Locale? locale,
    Brightness? brightness,
  }) =>
      pumpWidget(
        ProjectIosApp.test(
          locale: locale,
          brightness: brightness,
          home: widget,
        ),
      );
}
