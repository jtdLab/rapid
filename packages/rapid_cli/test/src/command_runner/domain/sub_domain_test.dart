import 'package:test/test.dart';

import '../../mocks.dart';
import '../../utils.dart';

List<String> expectedUsage(String subDomainPackage) => [
      'Work with the subdomain $subDomainPackage.',
      '',
      'Usage: rapid domain $subDomainPackage <command>',
      '-h, --help    Print this usage information.',
      '',
      'Available subcommands:',
      '  add      Add a component to the subdomain $subDomainPackage.',
      '  remove   Remove a component from the subdomain $subDomainPackage.',
      '',
      'Run "rapid help" to see global options.'
    ];

void main() {
  setUpAll(registerFallbackValues);

  group('domain <sub_domain>', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final project = setupProjectWithDomainPackage('package_a');
        final commandRunner = getCommandRunner(project: project);

        await commandRunner.run(['domain', 'package_a', '--help']);
        expect(printLogs, equals(expectedUsage('package_a')));

        printLogs.clear();

        await commandRunner.run(['domain', 'package_a', '-h']);
        expect(printLogs, equals(expectedUsage('package_a')));
      }),
    );
  });
}
