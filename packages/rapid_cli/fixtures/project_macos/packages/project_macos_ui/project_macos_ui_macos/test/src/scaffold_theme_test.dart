import 'package:flutter_test/flutter_test.dart';
import 'package:project_macos_ui_macos/src/scaffold_theme.dart';

void main() {
  group('ProjectMacosScaffoldTheme', () {
    group('.light', () {
      final light = ProjectMacosScaffoldTheme.light;

      test('.primary returns #FFFFFF', () {
        expect(light.backgroundColor.value, 0xFFFFFFFF);
      });
    });

    group('.dark', () {
      final dark = ProjectMacosScaffoldTheme.dark;

      test('.primary returns #222222', () {
        expect(dark.backgroundColor.value, 0xFF222222);
      });
    });
  });
}
