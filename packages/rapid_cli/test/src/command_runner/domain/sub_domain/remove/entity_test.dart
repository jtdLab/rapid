import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/domain/sub_domain/remove/entity.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';

List<String> expectedUsage(String subDomainPackage) => [
      'Remove an entity from the subdomain $subDomainPackage.\n'
          '\n'
          'Usage: rapid domain $subDomainPackage remove entity <name> [arguments]\n'
          '-h, --help    Print this usage information.\n'
          '\n'
          '\n'
          '-d, --dir     The directory relative to <domain_package>/lib/ .\n'
          '              (defaults to ".")\n'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  group('domain <sub_domain> remove entity', () {
    setUpAll(() {
      registerFallbackValues();
    });

    test(
      'help',
      withRunner(
        (commandRunner, project, __, printLogs) async {
          await commandRunner
              .run(['domain', 'package_a', 'remove', 'entity', '--help']);
          expect(printLogs, equals(expectedUsage('package_a')));

          printLogs.clear();

          await commandRunner
              .run(['domain', 'package_a', 'remove', 'entity', '-h']);
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

    test('completes', () async {
      final rapid = MockRapid();
      when(
        () => rapid.domainSubDomainRemoveEntity(
          name: any(named: 'name'),
          subDomainName: any(named: 'subDomainName'),
          dir: any(named: 'dir'),
        ),
      ).thenAnswer((_) async {});
      final argResults = MockArgResults();
      when(() => argResults['dir']).thenReturn('some');
      when(() => argResults.rest).thenReturn(['Foo']);
      final command = DomainSubDomainRemoveEntityCommand('package_a', null)
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.domainSubDomainRemoveEntity(
          name: 'Foo',
          subDomainName: 'package_a',
          dir: 'some',
        ),
      ).called(1);
    });
  });
}