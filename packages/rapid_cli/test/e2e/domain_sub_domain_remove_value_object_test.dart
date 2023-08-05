@Tags(['e2e'])
import 'package:test/test.dart';

import 'common.dart';

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
        'value_object',
        name,
        if (dir != null) '--output-dir',
        if (dir != null) dir,
      ]);

      // Act
      await tester.runRapidCommand([
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
        ...tester.valueObjectFiles(
          name: name,
          subDomainName: subDomain,
          outputDir: dir,
        ),
      });
    });

void main() {
  group(
    'E2E',
    () {
      test(
        'domain default remove value_object',
        performTest(
          subDomain: 'default',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

/*       test(
        'domain default remove value_object (with dir)',
        performTest(
          subDomain: 'default',
          dir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      ); */

      test(
        'domain <sub_domain> remove value_object',
        performTest(
          subDomain: 'foo_bar',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

/*       test(
        'domain <sub_domain> remove value_object (with dir)',
        performTest(
          subDomain: 'foo_bar',
          dir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      ); */
    },
  );
}
