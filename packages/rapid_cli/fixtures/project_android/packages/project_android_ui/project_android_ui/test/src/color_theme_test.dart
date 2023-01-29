import 'package:flutter_test/flutter_test.dart';
import 'package:project_android_ui/src/color_theme.dart';

void main() {
  group('ProjectAndroidColorTheme', () {
    group('.light', () {
      final light = ProjectAndroidColorTheme.light;

      test('primary returns #FFFFFF', () {
        expect(light.primary.value, 0xFFFFFFFF);
      });

      test('secondary returns #3277B4', () {
        expect(light.secondary.value, 0xFF3277B4);
      });
    });

    group('.dark', () {
      final dark = ProjectAndroidColorTheme.dark;

      test('primary returns #222222', () {
        expect(dark.primary.value, 0xFF222222);
      });

      test('secondary returns #284D72', () {
        expect(dark.secondary.value, 0xFF284D72);
      });
    });
  });
}
