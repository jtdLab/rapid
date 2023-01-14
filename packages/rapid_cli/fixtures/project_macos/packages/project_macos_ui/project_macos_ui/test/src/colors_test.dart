import 'package:flutter_test/flutter_test.dart';
import 'package:project_macos_ui/src/colors.dart';

void main() {
  group('ProjectMacosColors', () {
    test('.primary returns #A10213', () {
      expect(ProjectMacosColors.primary.value, 0xFFA10213);
    });

    test('.secondary returns #C19213', () {
      expect(ProjectMacosColors.secondary.value, 0xFFC19213);
    });
  });
}
