{{#android}}import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_ui_android/src/app.dart';

/// Wraps [widget] with a fully functional [{{project_name.pascalCase()}}App].
///
/// Use the [locale] parameter to set the language of the app.
///
/// Use the [themeMode] parameter to customize the app's appearance.
Widget appWrapper({
  required Widget widget,
  Locale? locale,
  ThemeMode? themeMode,
}) {
  return {{project_name.pascalCase()}}App.test(
    locale: locale ?? const Locale('en'),
    themeMode: themeMode,
    home: widget,
  );
}

extension WidgetTesterX on WidgetTester {
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
{{/android}}{{#ios}}
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_ui_ios/src/app.dart';

/// Wraps [widget] with a fully functional [{{project_name.pascalCase()}}App].
///
/// Use the [locale] parameter to set the language of the app.
///
/// Use the [brightness] parameter to customize the app's appearance.
Widget appWrapper({
  required Widget widget,
  Locale? locale,
  Brightness? brightness,
}) {
  return {{project_name.pascalCase()}}App.test(
    locale: locale ?? const Locale('en'),
    brightness: brightness,
    home: widget,
  );
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    Locale? locale,
    Brightness? brightness,
  }) =>
      pumpWidget(
        appWrapper(
          locale: locale,
          brightness: brightness,
          widget: widget,
        ),
      );
}
{{/ios}}{{#linux}}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_ui_linux/src/app.dart';

/// Wraps [widget] with a fully functional [{{project_name.pascalCase()}}App].
///
/// Use the [locale] parameter to set the language of the app.
///
/// Use the [themeMode] parameter to customize the app's appearance.
Widget appWrapper({
  required Widget widget,
  Locale? locale,
  ThemeMode? themeMode,
}) {
  return {{project_name.pascalCase()}}App.test(
    locale: locale ?? const Locale('en'),
    themeMode: themeMode,
    home: widget,
  );
}

extension WidgetTesterX on WidgetTester {
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
{{/linux}}{{#macos}}
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_ui_macos/src/app.dart';

/// Wraps [widget] with a fully functional [{{project_name.pascalCase()}}App].
///
/// Use the [locale] parameter to set the language of the app.
///
/// Use the [themeMode] parameter to customize the app's appearance.
Widget appWrapper({
  required Widget widget,
  Locale? locale,
  ThemeMode? themeMode,
}) {
  return {{project_name.pascalCase()}}App.test(
    locale: locale ?? const Locale('en'),
    themeMode: themeMode,
    home: widget,
  );
}

extension WidgetTesterX on WidgetTester {
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
{{/macos}}{{#web}}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_ui_web/src/app.dart';

/// Wraps [widget] with a fully functional [{{project_name.pascalCase()}}App].
///
/// Use the [locale] parameter to set the language of the app.
///
/// Use the [themeMode] parameter to customize the app's appearance.
Widget appWrapper({
  required Widget widget,
  Locale? locale,
  ThemeMode? themeMode,
}) {
  return {{project_name.pascalCase()}}App.test(
    locale: locale ?? const Locale('en'),
    themeMode: themeMode,
    home: widget,
  );
}

extension WidgetTesterX on WidgetTester {
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
{{/web}}{{#windows}}
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_ui_windows/src/app.dart';

/// Wraps [widget] with a fully functional [{{project_name.pascalCase()}}App].
///
/// Use the [locale] parameter to set the language of the app.
///
/// Use the [themeMode] parameter to customize the app's appearance.
Widget appWrapper({
  required Widget widget,
  Locale? locale,
  ThemeMode? themeMode,
}) {
  return {{project_name.pascalCase()}}App.test(
    locale: locale ?? const Locale('en'),
    themeMode: themeMode,
    home: widget,
  );
}

extension WidgetTesterX on WidgetTester {
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
{{/windows}}{{#mobile}}import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_ui_mobile/src/app.dart';

/// Wraps [widget] with a fully functional [{{project_name.pascalCase()}}App].
///
/// Use the [locale] parameter to set the language of the app.
///
/// Use the [themeMode] parameter to customize the app's appearance.
Widget appWrapper({
  required Widget widget,
  Locale? locale,
  ThemeMode? themeMode,
}) {
  return {{project_name.pascalCase()}}App.test(
    locale: locale ?? const Locale('en'),
    themeMode: themeMode,
    home: widget,
  );
}

extension WidgetTesterX on WidgetTester {
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
{{/mobile}}