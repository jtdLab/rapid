import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_windows_ui_windows/src/scaffold_theme.dart';

void main() {
  group('ProjectWindowsScaffoldTheme', () {
    group('.light', () {
      final light = ProjectWindowsScaffoldTheme.light;

      test('.backgroundColor', () {
        // Assert
        expect(light.backgroundColor, const Color(0xFFFFFFFF));
      });
    });

    group('.dark', () {
      final dark = ProjectWindowsScaffoldTheme.dark;

      test('.backgroundColor', () {
        // Assert
        expect(dark.backgroundColor, const Color(0xFF222222));
      });
    });
  });
}
