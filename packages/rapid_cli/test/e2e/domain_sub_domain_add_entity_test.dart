@Tags(['e2e'])
import 'package:test/test.dart';

import 'common.dart';

// TODO output-dir

void main() {
  group(
    'E2E',
    () {
      dynamic performTest({
        required String subDomain,
        String? outputDir,
      }) =>
          withTempDir((root) async {
            // Arrange
            final tester = await RapidE2ETester.withProject(root);
            if (subDomain != 'default') {
              await tester.runRapidCommand([
                'domain',
                'add',
                'sub_domain',
                subDomain,
              ]);
            }
            final name = 'FooBar';

            // Act
            await tester.runRapidCommand([
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
              ...tester.entityFiles(
                name: name,
                subDomainName: subDomain,
                outputDir: outputDir,
              ),
            });
            await verifyTestsPassWith100PercentCoverage({
              tester.domainPackage(subDomain),
            });
          });

      test(
        'domain default add entity',
        performTest(
          subDomain: 'default',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

/*       test(
        'domain default add entity (with output dir)',
        performTest(
          subDomain: 'default',
          outputDir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      ); */

      test(
        'domain <sub_domain> add entity',
        performTest(
          subDomain: 'foo_bar',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

/*       test(
        'domain <sub_domain> add entity (with output dir)',
        performTest(
          subDomain: 'foo_bar',
          outputDir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      ); */
    },
  );
}
