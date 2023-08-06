import 'package:test/test.dart';

import '../../mocks.dart';
import '../../utils.dart';

const expectedUsage = [
  'Add subdomains to the domain part of a Rapid project.',
  '',
  'Usage: rapid domain add <subcommand>',
  '-h, --help    Print this usage information.',
  '',
  'Available subcommands:',
  '  sub_domain   Add a subdomain to the domain part of a Rapid project.',
  '',
  'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(registerFallbackValues);

  group('domain add', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final project = setupProjectWithDomainPackage('package_a');
        final commandRunner = getCommandRunner(project: project);

        await commandRunner.run(['domain', 'add', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['domain', 'add', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );
  });
}
