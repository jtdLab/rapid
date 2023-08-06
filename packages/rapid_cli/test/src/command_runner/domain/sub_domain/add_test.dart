import 'package:test/test.dart';

import '../../../mocks.dart';
import '../../../utils.dart';

List<String> expectedUsage(String subDomainPackage) => [
      'Add a component to the subdomain $subDomainPackage.\n'
          '\n'
          'Usage: rapid domain $subDomainPackage add <component>\n'
          '-h, --help    Print this usage information.\n'
          '\n'
          'Available subcommands:\n'
          '  entity              Add an entity to the subdomain $subDomainPackage.\n'
          '  service_interface   Add a service interface to the subdomain $subDomainPackage.\n'
          '  value_object        Add a value object to the subdomain $subDomainPackage.\n'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  setUpAll(registerFallbackValues);

  group('domain <sub_domain> add', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final project = setupProjectWithDomainPackage('package_a');
        final commandRunner = getCommandRunner(project: project);

        await commandRunner.run(['domain', 'package_a', 'add', '--help']);
        expect(printLogs, equals(expectedUsage('package_a')));

        printLogs.clear();

        await commandRunner.run(['domain', 'package_a', 'add', '-h']);
        expect(printLogs, equals(expectedUsage('package_a')));
      }),
    );
  });
}
