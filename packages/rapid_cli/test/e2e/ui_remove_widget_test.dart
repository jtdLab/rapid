@Tags(['e2e'])
import 'package:test/test.dart';

import 'common.dart';

dynamic Function() performTest() => withTempDir((root) async {
      // Arrange
      final tester = await RapidE2ETester.withProject(root);
      final name = 'FooBar';
      await tester.runRapidCommand([
        'ui',
        'add',
        'widget',
        name,
      ]);

      // Act
      await tester.runRapidCommand([
        'ui',
        'remove',
        'widget',
        name,
      ]);

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      verifyDoNotExist({
        ...tester.widgetFiles(name: name),
      });
      await verifyTestsPassWith100PercentCoverage([tester.uiPackage]);
    });

void main() {
  group(
    'E2E',
    () {
      test(
        'ui add widget',
        performTest(),
        timeout: const Timeout(Duration(minutes: 4)),
      );
    },
  );
}
