@Tags(['e2e'])
import 'dart:io';

import 'package:test/test.dart';

import 'common.dart';

// TODO test sub-infrastructure

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      setUp(() async {
        Directory.current = getTempDir();

        await setupProject();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      group('infrastructure <sub_infrastructure> remove data_transfer_object',
          () {
        Future<void> performTest({
          String? dir,
          TestType type = TestType.normal,
        }) async {
          // Arrange
          await setupProject();
          final entity = 'FooBar';
          await runRapidCommand([
            'domain',
            'default',
            'add',
            'entity',
            entity,
            if (dir != null) '--output-dir',
            if (dir != null) dir,
          ]);
          await runRapidCommand([
            'infrastructure',
            'default',
            'add',
            'data_transfer_object',
            '--entity',
            entity,
            if (dir != null) '--output-dir',
            if (dir != null) dir,
          ]);

          // Act
          await runRapidCommand([
            'infrastructure',
            'default',
            'remove',
            'data_transfer_object',
            '--entity',
            entity,
            if (dir != null) '--dir',
            if (dir != null) dir
          ]);

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...dataTransferObjectFiles(entity: entity, outputDir: dir),
          });
          if (type != TestType.fast) {
            verifyDoNotHaveTests({
              infrastructurePackage(),
            });
          }
        }

        test(
          '(fast) ',
          () => performTest(
            type: TestType.fast,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          'with dir (fast) ',
          () => performTest(
            dir: 'foo',
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

        test(
          'with dir',
          () => performTest(
            dir: 'foo',
          ),
          timeout: const Timeout(Duration(minutes: 4)),
        );
      });
    },
  );
}
