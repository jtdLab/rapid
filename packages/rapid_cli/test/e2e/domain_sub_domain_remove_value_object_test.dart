@Tags(['e2e'])
import 'dart:io';

import 'package:test/test.dart';

import 'common.dart';

// TODO test sub-domain

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

      group('domain <sub_domain> remove value_object', () {
        Future<void> performTest({
          required String subDomain,
          String? dir,
          TestType type = TestType.normal,
        }) async {
          // Arrange
          if (subDomain != 'default') {
            await runRapidCommand([
              'domain',
              'add',
              'sub_domain',
              subDomain,
            ]);
          }
          final name = 'FooBar';
          await runRapidCommand([
            'domain',
            subDomain,
            'add',
            'value_object',
            name,
            if (dir != null) '--output-dir',
            if (dir != null) dir,
          ]);

          // Act
          await runRapidCommand([
            'domain',
            subDomain,
            'remove',
            'value_object',
            name,
            if (dir != null) '--dir',
            if (dir != null) dir
          ]);

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoNotExist({
            ...valueObjectFiles(
              name: name,
              subDomainName: subDomain,
              outputDir: dir,
            ),
          });
          if (type != TestType.fast) {
            verifyDoNotHaveTests({
              domainPackage(subDomain),
            });
          }
        }

        group('(default)', () {
          test(
            '(fast) ',
            () => performTest(
              subDomain: 'default',
              type: TestType.fast,
            ),
            timeout: const Timeout(Duration(minutes: 4)),
            tags: ['fast'],
          );

          test(
            'with dir (fast) ',
            () => performTest(
              subDomain: 'default',
              dir: 'foo',
              type: TestType.fast,
            ),
            timeout: const Timeout(Duration(minutes: 4)),
            tags: ['fast'],
          );

          test(
            '',
            () => performTest(
              subDomain: 'default',
            ),
            timeout: const Timeout(Duration(minutes: 4)),
          );

          test(
            'with dir',
            () => performTest(
              subDomain: 'default',
              dir: 'foo',
            ),
            timeout: const Timeout(Duration(minutes: 4)),
          );
        });

        test(
          '(fast) ',
          () => performTest(
            subDomain: 'foo_bar',
            type: TestType.fast,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          'with dir (fast) ',
          () => performTest(
            subDomain: 'foo_bar',
            dir: 'foo',
            type: TestType.fast,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          '',
          () => performTest(
            subDomain: 'foo_bar',
          ),
          timeout: const Timeout(Duration(minutes: 4)),
        );

        test(
          'with dir',
          () => performTest(
            subDomain: 'foo_bar',
            dir: 'foo',
          ),
          timeout: const Timeout(Duration(minutes: 4)),
        );
      });
    },
  );
}
