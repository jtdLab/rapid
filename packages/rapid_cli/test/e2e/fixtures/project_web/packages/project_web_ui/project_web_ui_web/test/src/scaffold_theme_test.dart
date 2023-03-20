import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_web_ui_web/src/scaffold_theme.dart';

void main() {
  group('ProjectWebScaffoldTheme', () {
    group('.light', () {
      final light = ProjectWebScaffoldTheme.light;

      test('.backgroundColor', () {
        // Assert
        expect(light.backgroundColor, const Color(0xFFFFFFFF));
      });
    });

    group('.dark', () {
      final dark = ProjectWebScaffoldTheme.dark;

      test('.backgroundColor', () {
        // Assert
        expect(dark.backgroundColor, const Color(0xFF222222));
      });
    });
  });
}
