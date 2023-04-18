import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_android_ui_android/src/scaffold_theme.dart';

void main() {
  group('ProjectAndroidScaffoldTheme', () {
    group('.light', () {
      final light = ProjectAndroidScaffoldTheme.light;

      test('.backgroundColor', () {
        // Assert
        expect(light.backgroundColor, const Color(0xFFFFFFFF));
      });
    });

    group('.dark', () {
      final dark = ProjectAndroidScaffoldTheme.dark;

      test('.backgroundColor', () {
        // Assert
        expect(dark.backgroundColor, const Color(0xFF222222));
      });
    });
  });
}
