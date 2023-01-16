import 'package:flutter_test/flutter_test.dart';
import 'package:project_linux_ui/src/color_theme.dart';

void main() {
  group('ProjectLinuxColorTheme', () {
    group('.light', () {
      final light = ProjectLinuxColorTheme.light;

      test('.primary returns #FFFFFF', () {
        expect(light.primary.value, 0xFFFFFFFF);
      });

      test('.primary returns #3277B4', () {
        expect(light.secondary.value, 0xFF3277B4);
      });
    });

    group('.dark', () {
      final dark = ProjectLinuxColorTheme.dark;

      test('.primary returns #222222', () {
        expect(dark.primary.value, 0xFF222222);
      });

      test('.primary returns #284D72', () {
        expect(dark.secondary.value, 0xFF284D72);
      });
    });
  });
}
