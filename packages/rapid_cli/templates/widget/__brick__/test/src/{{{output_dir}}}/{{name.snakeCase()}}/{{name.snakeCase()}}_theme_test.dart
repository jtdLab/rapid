{{#android}}import 'package:flutter/material.dart';{{/android}}{{#ios}}import 'package:flutter/cupertino.dart';{{/ios}}{{#linux}}import 'package:flutter/material.dart';{{/linux}}{{#macos}}import 'package:flutter/cupertino.dart';{{/macos}}{{#web}}import 'package:flutter/material.dart';{{/web}}{{#windows}}import 'package:fluent_ui/fluent_ui.dart';{{/windows}}
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_{{#android}}android{{/android}}{{#ios}}ios{{/ios}}{{#linux}}linux{{/linux}}{{#macos}}macos{{/macos}}{{#web}}web{{/web}}{{#windows}}windows{{/windows}}/src/{{name.snakeCase()}}/{{name.snakeCase()}}_theme.dart';

void main() {
  group('{{project_name.pascalCase()}}{{name.pascalCase()}}Theme', () {
    group('.light', () {
      final light = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme.light;

      test('.backgroundColor', () {
        // Assert
        expect(light.backgroundColor, const Color(0xFF000000));
      });
    });

    group('.dark', () {
      final dark = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme.dark;

      test('.backgroundColor', () {
        // Assert
        expect(dark.backgroundColor, const Color(0xFFFFFFFF));
      });
    });
  });
}
