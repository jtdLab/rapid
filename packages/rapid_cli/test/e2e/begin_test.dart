@Tags(['e2e'])
import 'package:test/test.dart';

import 'common.dart';

void main() {
  group(
    'E2E',
    () {
      group('begin', () {
        dynamic performTest() => withTempDir((root) async {
              // Arrange
              final tester = await RapidE2ETester.withProject(root);

              // Act
              await tester.runRapidCommand(['begin']);

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
