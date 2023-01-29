import 'package:flutter_test/flutter_test.dart';
import 'package:project_web_ui_web/src/scaffold_theme.dart';

void main() {
  group('ProjectWebScaffoldTheme', () {
    group('.light', () {
      final light = ProjectWebScaffoldTheme.light;

      test('backgroundColor returns #FFFFFF', () {
        expect(light.backgroundColor.value, 0xFFFFFFFF);
      });
    });

    group('.dark', () {
      final dark = ProjectWebScaffoldTheme.dark;

      test('backgroundColor returns #222222', () {
        expect(dark.backgroundColor.value, 0xFF222222);
      });
    });
  });
}
