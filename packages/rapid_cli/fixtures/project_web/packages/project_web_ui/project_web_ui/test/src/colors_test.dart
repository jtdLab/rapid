import 'package:flutter_test/flutter_test.dart';
import 'package:project_web_ui/src/colors.dart';

void main() {
  group('ProjectWebColors', () {
    test('.primary returns #A10213', () {
      expect(ProjectWebColors.primary.value, 0xFFA10213);
    });

    test('.secondary returns #C19213', () {
      expect(ProjectWebColors.secondary.value, 0xFFC19213);
    });
  });
}
