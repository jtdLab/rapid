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

      group('infrastructure <sub_infrastructure> add data_transfer_object', () {
        Future<void> performTest({
          required String subInfrastructure,
          String? outputDir,
          TestType type = TestType.normal,
        }) async {
          // Arrange
          if (subInfrastructure != 'default') {
            await runRapidCommand([
              'domain',
              'add',
              'sub_domain',
              subInfrastructure,
            ]);
          }
          final entity = 'FooBar';
          await runRapidCommand([
            'domain',
            subInfrastructure,
            'add',
            'entity',
            entity,
            if (outputDir != null) '--output-dir',
            if (outputDir != null) outputDir,
          ]);

          // Act
          await runRapidCommand([
            'infrastructure',
            subInfrastructure,
            'add',
            'data_transfer_object',
            '--entity',
            entity,
            if (outputDir != null) '--output-dir',
            if (outputDir != null) outputDir
          ]);

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...dataTransferObjectFiles(
              entity: entity,
              subInfrastructureName: subInfrastructure,
              outputDir: outputDir,
            ),
          });
          if (type != TestType.fast) {
            await verifyTestsPassWith100PercentCoverage({
              infrastructurePackage(subInfrastructure),
            });
          }
        }

        group('(default)', () {
          test(
            '(fast) ',
            () => performTest(
              subInfrastructure: 'default',
              type: TestType.fast,
            ),
            timeout: const Timeout(Duration(minutes: 4)),
            tags: ['fast'],
          );

          test(
            'with output dir (fast) ',
            () => performTest(
              subInfrastructure: 'default',
              outputDir: 'foo',
              type: TestType.fast,
            ),
            timeout: const Timeout(Duration(minutes: 4)),
            tags: ['fast'],
          );

          test(
            '',
            () => performTest(
              subInfrastructure: 'default',
            ),
            timeout: const Timeout(Duration(minutes: 8)),
          );

          test(
            'with output dir',
            () => performTest(
              subInfrastructure: 'default',
              outputDir: 'foo',
            ),
            timeout: const Timeout(Duration(minutes: 8)),
          );
        });

        test(
          '(fast) ',
          () => performTest(
            subInfrastructure: 'foo_bar',
            type: TestType.fast,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          'with output dir (fast) ',
          () => performTest(
            subInfrastructure: 'foo_bar',
            outputDir: 'foo',
            type: TestType.fast,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          '',
          () => performTest(
            subInfrastructure: 'foo_bar',
          ),
          timeout: const Timeout(Duration(minutes: 8)),
        );

        test(
          'with output dir',
          () => performTest(
            subInfrastructure: 'foo_bar',
            outputDir: 'foo',
          ),
          timeout: const Timeout(Duration(minutes: 8)),
        );
      });
    },
  );
}
