import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_ios_ui_ios/src/scaffold_theme.dart';

void main() {
  group('ProjectIosScaffoldTheme', () {
    group('.light', () {
      final light = ProjectIosScaffoldTheme.light;

      test('.backgroundColor', () {
        // Assert
        expect(light.backgroundColor, const Color(0xFFFFFFFF));
      });
    });

    group('.dark', () {
      final dark = ProjectIosScaffoldTheme.dark;

      test('.backgroundColor', () {
        // Assert
        expect(dark.backgroundColor, const Color(0xFF222222));
      });
    });
  });
}
