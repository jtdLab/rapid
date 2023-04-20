{{#android}}import 'package:flutter/material.dart';import 'package:flutter_test/flutter_test.dart';import 'package:{{project_name}}_ui_android/src/scaffold_theme.dart';{{/android}}{{#ios}}import 'package:flutter/cupertino.dart';import 'package:flutter_test/flutter_test.dart';import 'package:{{project_name}}_ui_ios/src/scaffold_theme.dart';{{/ios}}{{#linux}}import 'package:flutter/material.dart';import 'package:flutter_test/flutter_test.dart';import 'package:{{project_name}}_ui_linux/src/scaffold_theme.dart';{{/linux}}{{#macos}}import 'package:flutter/widgets.dart';import 'package:flutter_test/flutter_test.dart';import 'package:{{project_name}}_ui_macos/src/scaffold_theme.dart';{{/macos}}{{#web}}import 'package:flutter/material.dart';import 'package:flutter_test/flutter_test.dart';import 'package:{{project_name}}_ui_web/src/scaffold_theme.dart';{{/web}}{{#windows}}import 'package:fluent_ui/fluent_ui.dart';import 'package:flutter_test/flutter_test.dart';import 'package:{{project_name}}_ui_windows/src/scaffold_theme.dart';{{/windows}}

void main() {
  group('{{project_name.pascalCase()}}ScaffoldTheme', () {
    group('.light', () {
      final light = {{project_name.pascalCase()}}ScaffoldTheme.light;

      test('.backgroundColor', () {
        // Assert
        expect(light.backgroundColor, const Color(0xFFFFFFFF));
      });
    });

    group('.dark', () {
      final dark = {{project_name.pascalCase()}}ScaffoldTheme.dark;

      test('.backgroundColor', () {
        // Assert
        expect(dark.backgroundColor, const Color(0xFF222222));
      });
    });
  });
}
