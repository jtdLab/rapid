@Tags(['e2e'])
import 'package:test/test.dart';

import 'common.dart';

dynamic Function() performTest() => withTempDir((root) async {
      // Arrange
      final tester = await RapidE2ETester.withProject(root);
      const name = 'FooBar';

      // Act
      await tester.runRapidCommand([
        'ui',
        'add',
        'widget',
        name,
      ]);

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      verifyDoExist({
        ...tester.widgetFiles(name: name),
      });
      await verifyTestsPassWith100PercentCoverage([tester.uiPackage]);
    });

void main() {
  group('E2E', () {
    test(
      'ui add widget',
      performTest(),
      timeout: const Timeout(Duration(minutes: 4)),
    );
  });
}
