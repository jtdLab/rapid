import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_ui/src/theme_extensions.dart';

/// Wraps [widget] with a fully functional [MaterialApp].
///
/// Use the [locale] parameter to set the language of the app.
///
/// Use the [themeMode] parameter to customize the app's appearance.
Widget appWrapper({
  required Widget widget,
  Locale? locale,
  ThemeMode? themeMode,
}) {
  return MaterialApp(
    locale: locale ?? const Locale('en'),
    themeMode: themeMode,
    theme: ThemeData(extensions: lightExtensions),
    darkTheme: ThemeData(extensions: darkExtensions),
    home: widget,
  );
}

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] wrapped with a [MaterialApp].
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
        appWrapper(
          locale: locale,
          themeMode: themeMode,
          widget: widget,
        ),
      );
}
