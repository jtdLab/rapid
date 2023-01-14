import 'package:flutter_test/flutter_test.dart';
import 'package:project_android_ui/src/colors.dart';

void main() {
  group('ProjectAndroidColors', () {
    test('.primary returns #A10213', () {
      expect(ProjectAndroidColors.primary.value, 0xFFA10213);
    });

    test('.secondary returns #C19213', () {
      expect(ProjectAndroidColors.secondary.value, 0xFFC19213);
    });
  });
}
