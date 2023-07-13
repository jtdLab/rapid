import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../common.dart';
import '../mocks.dart';
import '../utils.dart';

List<String> expectedUsage(List<DomainPackage> domainPackages) => [
      'Work with the domain part of an existing Rapid project.\n'
          '\n'
          'Usage: rapid domain <subcommand>\n'
          '-h, --help    Print this usage information.\n'
          '\n'
          'Available subcommands:\n'
          '  add         Add subdomains to the domain part of an existing Rapid project.\n'
          '${domainPackages.map((e) => '  ${e.name}   Work with the subdomain ${e.name}.\n').join()}'
          '  remove      Remove subdomains from the domain part of an existing Rapid project.\n'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  group('domain', () {
    test(
      'help',
      overridePrint(
        (printLogs) async {
          final domainPackages = [
            MockDomainPackage(name: 'package_a'),
            MockDomainPackage(name: 'package_b'),
          ];
          final project = getProject(domainPackages: domainPackages);
          final commandRunner = getCommandRunner(project: project);

          await commandRunner.run(['domain', '--help']);
          expect(printLogs, equals(expectedUsage(domainPackages)));

          printLogs.clear();

          await commandRunner.run(['domain', '-h']);
          expect(printLogs, equals(expectedUsage(domainPackages)));
        },
      ),
    );
  });
}
