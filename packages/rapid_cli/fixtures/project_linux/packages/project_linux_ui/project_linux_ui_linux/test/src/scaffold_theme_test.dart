import 'package:flutter_test/flutter_test.dart';
import 'package:project_linux_ui_linux/src/scaffold_theme.dart';

void main() {
  group('ProjectLinuxScaffoldTheme', () {
    group('.light', () {
      final light = ProjectLinuxScaffoldTheme.light;

      test('.primary returns #FFFFFF', () {
        expect(light.backgroundColor.value, 0xFFFFFFFF);
      });
    });

    group('.dark', () {
      final dark = ProjectLinuxScaffoldTheme.dark;

      test('.primary returns #222222', () {
        expect(dark.backgroundColor.value, 0xFF222222);
      });
    });
  });
}
