@Tags(['e2e'])
import 'dart:io';

import 'package:test/test.dart';

import 'common.dart';

void main() {
  group('E2E', () {
    cwd = Directory.current;

    setUp(() {
      Directory.current = getTempDir();
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group(
      'ui add widget',
      () {
        Future<void> performTest({
          TestType type = TestType.normal,
        }) async {
          // Arrange
          await setupProject();
          final name = 'FooBar';

          // Act
          await runRapidCommand([
            'ui',
            'add',
            'widget',
            name,
          ]);

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...widgetFiles(name: name),
          });
          if (type != TestType.fast) {
            await verifyTestsPassWith100PercentCoverage([uiPackage]);
          }
        }

        test(
          '(fast)',
          () => performTest(
            type: TestType.fast,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          '',
          () => performTest(),
          timeout: const Timeout(Duration(minutes: 4)),
        );
      },
    );
  });
}
