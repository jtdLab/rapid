@Tags(['e2e'])
import 'dart:io';

import 'package:test/test.dart';

import 'common.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      setUp(() async {
        Directory.current = getTempDir();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      Future<void> performTest({
        required String subDomain,
        String? outputDir,
      }) async {
        // Arrange
        await setupProject();
        if (subDomain != 'default') {
          await runRapidCommand([
            'domain',
            'add',
            'sub_domain',
            subDomain,
          ]);
        }
        final name = 'FooBar';

        // Act
        await runRapidCommand([
          'domain',
          subDomain,
          'add',
          'entity',
          name,
          if (outputDir != null) '--output-dir',
          if (outputDir != null) outputDir,
        ]);

        // Assert
        await verifyNoAnalyzerIssues();
        await verifyNoFormattingIssues();
        verifyDoExist({
          ...entityFiles(
            name: name,
            subDomainName: subDomain,
            outputDir: outputDir,
          ),
        });
        await verifyTestsPassWith100PercentCoverage({
          domainPackage(subDomain),
        });
      }

      test(
        'domain default add entity',
        () => performTest(
          subDomain: 'default',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'domain default add entity (with output dir)',
        () => performTest(
          subDomain: 'default',
          outputDir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'domain <sub_domain> add entity',
        () => performTest(
          subDomain: 'foo_bar',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'domain <sub_domain> add entity (with output dir)',
        () => performTest(
          subDomain: 'foo_bar',
          outputDir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );
    },
  );
}
