import 'package:test/test.dart';

import '../../../mocks.dart';
import '../../../utils.dart';

List<String> expectedUsage(String subDomainPackage) => [
      'Remove a component from the subdomain $subDomainPackage.',
      '',
      'Usage: rapid domain $subDomainPackage remove <component>',
      '-h, --help    Print this usage information.',
      '',
      'Available subcommands:',
      '''  entity              Remove an entity from the subdomain $subDomainPackage.''',
      '''  service_interface   Remove a service interface from the subdomain $subDomainPackage.''',
      '''  value_object        Remove a value object from the subdomain $subDomainPackage.''',
      '',
      'Run "rapid help" to see global options.'
    ];

void main() {
  setUpAll(registerFallbackValues);

  group('domain <sub_domain> remove', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final project = setupProjectWithDomainPackage('package_a');
        final commandRunner = getCommandRunner(project: project);

        await commandRunner.run(['domain', 'package_a', 'remove', '--help']);
        expect(printLogs, equals(expectedUsage('package_a')));

        printLogs.clear();

        await commandRunner.run(['domain', 'package_a', 'remove', '-h']);
        expect(printLogs, equals(expectedUsage('package_a')));
      }),
    );
  });
}
