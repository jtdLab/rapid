import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';
import '../../utils.dart';

const expectedUsage = [
  'Add subdomains to the domain part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid domain add <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  sub_domain   Add subdomains of the domain part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('domain add', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final project = MockRapidProject(
          appModule: MockAppModule(
            domainDirectory: MockDomainDirectory(
              domainPackages: [
                FakeDomainPackage(name: 'package_a'),
              ],
            ),
          ),
        );
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
