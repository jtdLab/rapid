import 'package:test/test.dart';

import '../../../mocks.dart';
import '../../../utils.dart';

List<String> expectedUsage(String subDomainPackage) => [
      'Remove a component from the subdomain $subDomainPackage.\n'
          '\n'
          'Usage: rapid domain $subDomainPackage remove <component>\n'
          '-h, --help    Print this usage information.\n'
          '\n'
          'Available subcommands:\n'
          '  entity              Remove an entity from the subdomain $subDomainPackage.\n'
          '  service_interface   Remove a service interface from the subdomain $subDomainPackage.\n'
          '  value_object        Remove a value object from the subdomain $subDomainPackage.\n'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

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
