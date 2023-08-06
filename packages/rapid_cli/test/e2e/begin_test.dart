@Tags(['e2e'])
library;

import 'package:test/test.dart';

import 'common.dart';

dynamic Function() performTest() => withTempDir((root) async {
      // Arrange
      final tester = await RapidE2ETester.withProject(root);

      // Act
      await tester.runRapidCommand(['begin']);

      // Assert
      verifyDoExist({tester.dotRapidToolGroupFile});
    });

void main() {
  group(
    'E2E',
    () {
      test(
        'begin',
        performTest(),
        timeout: const Timeout(Duration(minutes: 2)),
      );
    },
  );
}
