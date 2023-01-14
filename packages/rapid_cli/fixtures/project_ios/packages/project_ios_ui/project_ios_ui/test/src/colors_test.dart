import 'package:flutter_test/flutter_test.dart';
import 'package:project_ios_ui/src/colors.dart';

void main() {
  group('ProjectIosColors', () {
    test('.primary returns #A10213', () {
      expect(ProjectIosColors.primary.value, 0xFFA10213);
    });

    test('.secondary returns #C19213', () {
      expect(ProjectIosColors.secondary.value, 0xFFC19213);
    });
  });
}
