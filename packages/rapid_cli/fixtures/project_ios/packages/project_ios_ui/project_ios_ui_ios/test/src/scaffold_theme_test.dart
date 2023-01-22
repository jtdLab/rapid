import 'package:flutter_test/flutter_test.dart';
import 'package:project_ios_ui_ios/src/scaffold_theme.dart';

void main() {
  group('ProjectIosScaffoldTheme', () {
    group('.light', () {
      final light = ProjectIosScaffoldTheme.light;

      test('.primary returns #FFFFFF', () {
        expect(light.backgroundColor.value, 0xFFFFFFFF);
      });
    });

    group('.dark', () {
      final dark = ProjectIosScaffoldTheme.dark;

      test('.primary returns #222222', () {
        expect(dark.backgroundColor.value, 0xFF222222);
      });
    });
  });
}
