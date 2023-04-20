import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:project_linux_ui/src/color_theme.dart';

void main() {
  group('ProjectLinuxColorTheme', () {
    group('.light', () {
      final light = ProjectLinuxColorTheme.light;

      test('.primary', () {
        expect(light.primary, const Color(0xFFFFFFFF));
      });

      test('.secondary', () {
        expect(light.secondary, const Color(0xFF3277B4));
      });
    });

    group('.dark', () {
      final dark = ProjectLinuxColorTheme.dark;

      test('.primary', () {
        expect(dark.primary, const Color(0xFF222222));
      });

      test('.secondary', () {
        expect(dark.secondary, const Color(0xFF284D72));
      });
    });
  });
}
