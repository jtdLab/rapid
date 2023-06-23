import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/domain/sub_domain/add/entity.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';

List<String> expectedUsage(String subDomainPackage) => [
      'Add an entity to the subdomain $subDomainPackage.\n'
          '\n'
          'Usage: rapid domain $subDomainPackage add entity <name> [arguments]\n'
          '-h, --help          Print this usage information.\n'
          '\n'
          '\n'
          '-o, --output-dir    The output directory relative to <domain_package>/lib/ .\n'
          '                    (defaults to ".")\n'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  group('domain <sub_domain> add entity', () {
    setUpAll(() {
      registerFallbackValues();
    });

    test(
      'help',
      withRunner(
        (commandRunner, project, __, printLogs) async {
          await commandRunner
              .run(['domain', 'package_a', 'add', 'entity', '--help']);
          expect(printLogs, equals(expectedUsage('package_a')));

          printLogs.clear();

          await commandRunner
              .run(['domain', 'package_a', 'add', 'entity', '-h']);
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
        () => rapid.domainSubDomainAddEntity(
          name: any(named: 'name'),
          subDomainName: any(named: 'subDomainName'),
          outputDir: any(named: 'outputDir'),
        ),
      ).thenAnswer((_) async {});
      final argResults = MockArgResults();
      when(() => argResults['output-dir']).thenReturn('some');
      when(() => argResults.rest).thenReturn(['Foo']);
      final command = DomainSubDomainAddEntityCommand('package_a', null)
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.domainSubDomainAddEntity(
          name: 'Foo',
          subDomainName: 'package_a',
          outputDir: 'some',
        ),
      ).called(1);
    });
  });
}
