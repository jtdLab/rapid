import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

List<String> expectedUsage(String subDomainPackage) => [
      'Work with the subdomain $subDomainPackage.\n'
          '\n'
          'Usage: rapid domain $subDomainPackage <subcommand>\n'
          '-h, --help    Print this usage information.\n'
          '\n'
          'Available subcommands:\n'
          '  add      Add a component to the subdomain $subDomainPackage.\n'
          '  remove   Remove a component from the subdomain $subDomainPackage.\n'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  group('domain <sub_domain>', () {
    setUpAll(() {
      registerFallbackValues();
    });

    test(
      'help',
      withRunner(
        (commandRunner, project, __, printLogs) async {
          await commandRunner.run(['domain', 'package_a', '--help']);
          expect(printLogs, equals(expectedUsage('package_a')));

          printLogs.clear();

          await commandRunner.run(['domain', 'package_a', '-h']);
          expect(printLogs, equals(expectedUsage('package_a')));
        },
        setupProject: (project) {
          final domainPackageA = MockDomainPackage();
          when(() => domainPackageA.name).thenReturn('package_a');
          final domainDirectory = MockDomainDirectory();
          when(() => domainDirectory.domainPackages())
              .thenReturn([domainPackageA]);
          when(() => project.domainDirectory).thenReturn(domainDirectory);
        },
      ),
    );
  });
}
