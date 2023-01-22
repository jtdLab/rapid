import 'package:flutter_test/flutter_test.dart';
import 'package:project_android_ui_android/src/scaffold_theme.dart';

void main() {
  group('ProjectAndroidScaffoldTheme', () {
    group('.light', () {
      final light = ProjectAndroidScaffoldTheme.light;

      test('.primary returns #FFFFFF', () {
        expect(light.backgroundColor.value, 0xFFFFFFFF);
      });
    });

    group('.dark', () {
      final dark = ProjectAndroidScaffoldTheme.dark;

      test('.primary returns #222222', () {
        expect(dark.backgroundColor.value, 0xFF222222);
      });
    });
  });
}
