import 'package:flutter_test/flutter_test.dart';
import 'package:project_none_ui/src/colors.dart';

void main() {
  group('ProjectNoneColors', () {
    test('.primary returns #A10213', () {
      expect(ProjectNoneColors.primary.value, 0xFFA10213);
    });

    test('.secondary returns #C19213', () {
      expect(ProjectNoneColors.secondary.value, 0xFFC19213);
    });
  });
}
