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
              await verifyNoAnalyzerIssues();
              await verifyNoFormattingIssues();
              print(tester.dotRapidToolGroupFile.absolute.path);
              verifyDoExist({tester.dotRapidToolGroupFile});
            });

        test(
          '',
          performTest(),
          timeout: const Timeout(Duration(minutes: 4)),
        );
      });
    },
  );
}
