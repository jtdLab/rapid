import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example_ui_linux/src/scaffold_theme.dart';

void main() {
  group('ExampleScaffoldTheme', () {
    group('.light', () {
      final light = ExampleScaffoldTheme.light;

      test('.backgroundColor', () {
        // Assert
        expect(light.backgroundColor, const Color(0xFFFFFFFF));
      });
    });

    group('.dark', () {
      final dark = ExampleScaffoldTheme.dark;

      test('.backgroundColor', () {
        // Assert
        expect(dark.backgroundColor, const Color(0xFF222222));
      });
    });
  });
}
