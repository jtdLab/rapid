import 'package:test/test.dart';

import '../mocks.dart';
import '../utils.dart';

List<String> expectedUsage(List<String> domainPackages) => [
      'Work with the domain part of an existing Rapid project.\n'
          '\n'
          'Usage: rapid domain <subcommand>\n'
          '-h, --help    Print this usage information.\n'
          '\n'
          'Available subcommands:\n'
          '  add         Add subdomains to the domain part of an existing Rapid project.\n'
          '${domainPackages.map((domainPackage) => '  $domainPackage   Work with the subdomain $domainPackage.\n').join()}'
          '  remove      Remove subdomains from the domain part of an existing Rapid project.\n'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  setUpAll(registerFallbackValues);

  group('domain', () {
    test(
      'help',
      overridePrint(
        (printLogs) async {
          final project = MockRapidProject(
            appModule: MockAppModule(
              domainDirectory: MockDomainDirectory(
                domainPackages: [
                  FakeDomainPackage(name: 'package_a'),
                  FakeDomainPackage(name: 'package_b'),
                ],
              ),
            ),
          );
          final commandRunner = getCommandRunner(project: project);

          await commandRunner.run(['domain', '--help']);
          expect(printLogs, equals(expectedUsage(['package_a', 'package_b'])));

          printLogs.clear();

          await commandRunner.run(['domain', '-h']);
          expect(printLogs, equals(expectedUsage(['package_a', 'package_b'])));
        },
      ),
    );
  });
}
