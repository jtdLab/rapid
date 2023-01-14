import 'package:flutter_test/flutter_test.dart';
import 'package:project_linux_ui/src/colors.dart';

void main() {
  group('ProjectLinuxColors', () {
    test('.primary returns #A10213', () {
      expect(ProjectLinuxColors.primary.value, 0xFFA10213);
    });

    test('.secondary returns #C19213', () {
      expect(ProjectLinuxColors.secondary.value, 0xFFC19213);
    });
  });
}
