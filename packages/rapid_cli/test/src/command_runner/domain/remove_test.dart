import 'package:test/test.dart';

import '../../mocks.dart';
import '../../utils.dart';

const expectedUsage = [
  'Remove subdomains from the domain part of a Rapid project.',
  '',
  'Usage: rapid domain remove <subcommand>',
  '-h, --help    Print this usage information.',
  '',
  'Available subcommands:',
  '  sub_domain   Remove a subdomain from the domain part of a Rapid project.',
  '',
  'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(registerFallbackValues);

  group('domain remove', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final project = setupProjectWithDomainPackage('package_a');
        final commandRunner = getCommandRunner(project: project);

        await commandRunner.run(['domain', 'remove', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['domain', 'remove', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );
  });
}
