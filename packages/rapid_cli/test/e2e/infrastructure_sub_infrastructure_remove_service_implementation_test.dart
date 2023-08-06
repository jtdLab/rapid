@Tags(['e2e'])
import 'package:test/test.dart';

import 'common.dart';

dynamic Function() performTest({
  required String subInfrastructure,
  String? dir,
}) =>
    withTempDir((root) async {
      // Arrange
      final tester = await RapidE2ETester.withProject(root);
      if (subInfrastructure != 'default') {
        await tester.runRapidCommand([
          'domain',
          'add',
          'sub_domain',
          subInfrastructure,
        ]);
      }
      const name = 'Fake';
      const service = 'FooBar';
      const outputDir = 'foo';
      await tester.runRapidCommand([
        'domain',
        subInfrastructure,
        'add',
        'service_interface',
        service,
        if (dir != null) '--output-dir',
        if (dir != null) outputDir,
      ]);
      await tester.runRapidCommand([
        'infrastructure',
        subInfrastructure,
        'add',
        'service_implementation',
        name,
        '--service',
        service,
        if (dir != null) '--output-dir',
        if (dir != null) outputDir,
      ]);

      // Act
      await tester.runRapidCommand([
        'infrastructure',
        subInfrastructure,
        'remove',
        'service_implementation',
        name,
        '--service',
        service,
        if (dir != null) '--dir',
        if (dir != null) outputDir
      ]);

      // Assert
      await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      verifyDoNotExist({
        ...tester.serviceImplementationFiles(
          name: name,
          serviceName: service,
          subInfrastructureName: subInfrastructure,
          outputDir: outputDir,
        ),
      });
    });

void main() {
  group(
    'E2E',
    () {
      test(
        'infrastructure default remove service_implementation',
        performTest(
          subInfrastructure: 'default',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

/*       test(
        'infrastructure default remove service_implementation (with dir)',
        performTest(
          subInfrastructure: 'default',
          dir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      ); */

      test(
        'infrastructure <sub_infrastructure> remove service_implementation',
        performTest(
          subInfrastructure: 'foo_bar',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

/*       test(
        'infrastructure <sub_infrastructure> remove service_implementation (with dir)',
        performTest(
          subInfrastructure: 'foo_bar',
          dir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      ); */
    },
  );
}
