import 'package:flutter_test/flutter_test.dart';
import 'package:project_windows_ui_windows/src/scaffold_theme.dart';

void main() {
  group('ProjectWindowsScaffoldTheme', () {
    group('.light', () {
      final light = ProjectWindowsScaffoldTheme.light;

      test('backgroundColor returns #FFFFFF', () {
        expect(light.backgroundColor.value, 0xFFFFFFFF);
      });
    });

    group('.dark', () {
      final dark = ProjectWindowsScaffoldTheme.dark;

      test('backgroundColor returns #222222', () {
        expect(dark.backgroundColor.value, 0xFF222222);
      });
    });
  });
}
