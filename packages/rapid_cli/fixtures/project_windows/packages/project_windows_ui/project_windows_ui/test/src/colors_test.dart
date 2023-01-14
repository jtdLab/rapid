import 'package:flutter_test/flutter_test.dart';
import 'package:project_windows_ui/src/colors.dart';

void main() {
  group('ProjectWindowsColors', () {
    test('.primary returns #A10213', () {
      expect(ProjectWindowsColors.primary.value, 0xFFA10213);
    });

    test('.secondary returns #C19213', () {
      expect(ProjectWindowsColors.secondary.value, 0xFFC19213);
    });
  });
}
