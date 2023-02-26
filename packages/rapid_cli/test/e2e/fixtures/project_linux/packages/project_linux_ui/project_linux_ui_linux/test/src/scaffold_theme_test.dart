import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_linux_ui_linux/src/scaffold_theme.dart';

void main() {
  group('ProjectLinuxScaffoldTheme', () {
    group('.light', () {
      final light = ProjectLinuxScaffoldTheme.light;

      test('.backgroundColor', () {
        // Assert
        expect(light.backgroundColor, const Color(0xFFFFFFFF));
      });
    });

    group('.dark', () {
      final dark = ProjectLinuxScaffoldTheme.dark;

      test('.backgroundColor', () {
        // Assert
        expect(dark.backgroundColor, const Color(0xFF222222));
      });
    });
  });
}
