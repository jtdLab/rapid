@Tags(['e2e'])
library;

import 'package:test/test.dart';

import 'common.dart';

dynamic Function() performTest() => withTempDir((root) async {
      // Arrange
      final tester = await RapidE2ETester.withProject(root);
      await tester.runRapidCommand(['begin']);

      // Act
      await tester.runRapidCommand(['end']);

      // Assert
      verifyDoExist({tester.dotRapidToolGroupFile});
    });

void main() {
  group(
    'E2E',
    () {
      test(
        'end',
        performTest(),
        timeout: const Timeout(Duration(minutes: 2)),
      );
    },
  );
}
