@Tags(['e2e'])
import 'package:test/test.dart';

import 'common.dart';

void main() {
  group(
    'E2E',
    () {
      group('end', () {
        dynamic performTest() => withTempDir((root) async {
              // Arrange
              final tester = await RapidE2ETester.withProject(root);
              await tester.runRapidCommand(['begin']);

              // Act
              await tester.runRapidCommand(['end']);

              // Assert
              verifyDoExist({tester.dotRapidToolGroupFile});
            });

        test(
          '',
          performTest(),
          timeout: const Timeout(Duration(minutes: 2)),
        );
      });
    },
  );
}
