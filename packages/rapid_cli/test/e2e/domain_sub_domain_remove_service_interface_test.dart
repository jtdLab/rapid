@Tags(['e2e'])
import 'package:test/test.dart';

import 'common.dart';

// TODO dir

void main() {
  group(
    'E2E',
    () {
      dynamic performTest({
        required String subDomain,
        String? dir,
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
            await tester.runRapidCommand([
              'domain',
              subDomain,
              'add',
              'service_interface',
              name,
              if (dir != null) '--output-dir',
              if (dir != null) dir,
            ]);

            // Act
            await tester.runRapidCommand([
              'domain',
              subDomain,
              'remove',
              'service_interface',
              name,
              if (dir != null) '--dir',
              if (dir != null) dir,
            ]);

            // Assert
            await verifyNoAnalyzerIssues();
            await verifyNoFormattingIssues();
            verifyDoNotExist({
              ...tester.serviceInterfaceFiles(
                name: name,
                subDomainName: subDomain,
                outputDir: dir,
              ),
            });
          });

      test(
        'domain default remove entity',
        performTest(
          subDomain: 'default',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

/*       test(
        'domain default remove entity (with dir)',
        performTest(
          subDomain: 'default',
          dir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      ); */

      test(
        'domain <sub_domain> remove entity',
        performTest(
          subDomain: 'foo_bar',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

/*       test(
        'domain <sub_domain> remove entity (with dir)',
        performTest(
          subDomain: 'foo_bar',
          dir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      ); */
    },
  );
}
