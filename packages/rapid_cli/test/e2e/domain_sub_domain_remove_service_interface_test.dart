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
        String? dir,
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
        await runRapidCommand([
          'domain',
          subDomain,
          'add',
          'service_interface',
          name,
          if (dir != null) '--output-dir',
          if (dir != null) dir,
        ]);

        // Act
        await runRapidCommand([
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
          ...serviceInterfaceFiles(
            name: name,
            subDomainName: subDomain,
            outputDir: dir,
          ),
        });
        verifyDoNotHaveTests({
          domainPackage(subDomain),
        });
      }

      test(
        'domain default remove entity',
        () => performTest(
          subDomain: 'default',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'domain default remove entity (with dir)',
        () => performTest(
          subDomain: 'default',
          dir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'domain <sub_domain> remove entity',
        () => performTest(
          subDomain: 'foo_bar',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'domain <sub_domain> remove entity (with dir)',
        () => performTest(
          subDomain: 'foo_bar',
          dir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );
    },
  );
}
