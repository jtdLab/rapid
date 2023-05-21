{{#android}}import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_ui_android/src/app.dart';

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] wrapped with a [{{project_name.pascalCase()}}App].
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
        {{project_name.pascalCase()}}App.test(
          locale: locale,
          themeMode: themeMode,
          home: widget,
        ),
      );
}

{{/android}}{{#ios}}
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_ui_ios/src/app.dart';

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] wrapped with a [{{project_name.pascalCase()}}App].
  Future<void> pumpApp(
    Widget widget, {
    Locale? locale,
    Brightness? brightness,
  }) =>
      pumpWidget(
        {{project_name.pascalCase()}}App.test(
          locale: locale,
          brightness: brightness,
          home: widget,
        ),
      );
}
{{/ios}}{{#linux}}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_ui_linux/src/app.dart';

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] wrapped with a [{{project_name.pascalCase()}}App].
  Future<void> pumpApp(
    Widget widget, {
    Locale? locale,
    ThemeMode? themeMode,
  }) =>
      pumpWidget(
        {{project_name.pascalCase()}}App.test(
          locale: locale,
          themeMode: themeMode,
          home: widget,
        ),
      );
}
{{/linux}}{{#macos}}
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_ui_macos/src/app.dart';

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] wrapped with a [{{project_name.pascalCase()}}App].
  Future<void> pumpApp(
    Widget widget, {
    Locale? locale,
    Brightness? brightness,
  }) =>
      pumpWidget(
        {{project_name.pascalCase()}}App.test(
          locale: locale,
          brightness: brightness,
          home: widget,
        ),
      );
}
{{/macos}}{{#web}}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_ui_web/src/app.dart';

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] wrapped with a [{{project_name.pascalCase()}}App].
  Future<void> pumpApp(
    Widget widget, {
    Locale? locale,
    ThemeMode? themeMode,
  }) =>
      pumpWidget(
        {{project_name.pascalCase()}}App.test(
          locale: locale,
          themeMode: themeMode,
          home: widget,
        ),
      );
}
{{/web}}{{#windows}}
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_ui_windows/src/app.dart';

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] wrapped with a [{{project_name.pascalCase()}}App].
  Future<void> pumpApp(
    Widget widget, {
    Locale? locale,
    ThemeMode? themeMode,
  }) =>
      pumpWidget(
        {{project_name.pascalCase()}}App.test(
          locale: locale,
          themeMode: themeMode,
          home: widget,
        ),
      );
}
{{/windows}}{{#mobile}}import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_ui_mobile/src/app.dart';

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] wrapped with a [{{project_name.pascalCase()}}App].
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
        {{project_name.pascalCase()}}App.test(
          locale: locale,
          themeMode: themeMode,
          home: widget,
        ),
      );
}

{{/mobile}}