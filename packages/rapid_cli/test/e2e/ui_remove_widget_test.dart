@Tags(['e2e'])
import 'dart:io';

import 'package:test/test.dart';

import 'common.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      setUp(() {
        Directory.current = getTempDir();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      Future<void> performTest() async {
        // Arrange
        await setupProject();
        final name = 'FooBar';
        await runRapidCommand([
          'ui',
          'add',
          'widget',
          name,
        ]);

        // Act
        await runRapidCommand([
          'ui',
          'remove',
          'widget',
          name,
        ]);

        // Assert
        await verifyNoAnalyzerIssues();
        await verifyNoFormattingIssues();
        verifyDoNotExist({
          ...widgetFiles(name: name),
        });
        await verifyTestsPassWith100PercentCoverage([uiPackage]);
      }

      test(
        'ui add widget',
        () => performTest(),
        timeout: const Timeout(Duration(minutes: 4)),
      );
    },
  );
}
