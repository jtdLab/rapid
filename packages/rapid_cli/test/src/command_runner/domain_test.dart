import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../common.dart';
import '../mocks.dart';

List<String> expectedUsage(List<String> subDomainPackages) => [
      'Work with the domain part of an existing Rapid project.\n'
          '\n'
          'Usage: rapid domain <subcommand>\n'
          '-h, --help    Print this usage information.\n'
          '\n'
          'Available subcommands:\n'
          '  add         Add subdomains to the domain part of an existing Rapid project.\n'
          '${subDomainPackages.map((e) => '  $e   Work with the subdomain $e.\n').join()}'
          '  remove      Remove subdomains from the domain part of an existing Rapid project.\n'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  group('domain', () {
    setUpAll(() {
      registerFallbackValues();
    });

    test(
      'help',
      withRunner(
        (commandRunner, project, __, printLogs) async {
          await commandRunner.run(['domain', '--help']);
          expect(printLogs, equals(expectedUsage(['package_a', 'package_b'])));

          printLogs.clear();

          await commandRunner.run(['domain', '-h']);
          expect(printLogs, equals(expectedUsage(['package_a', 'package_b'])));
        },
        setupProject: (project) {
          final domainPackageA = MockDomainPackage();
          when(() => domainPackageA.name).thenReturn('package_a');
          final domainPackageB = MockDomainPackage();
          when(() => domainPackageB.name).thenReturn('package_b');
          final domainDirectory = MockDomainDirectory();
          when(() => domainDirectory.domainPackages())
              .thenReturn([domainPackageA, domainPackageB]);
          when(() => project.domainDirectory).thenReturn(domainDirectory);
        },
      ),
    );
  });
}
