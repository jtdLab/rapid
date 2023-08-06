import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/domain/sub_domain/remove/entity.dart';
import 'package:test/test.dart';

import '../../../../matchers.dart';
import '../../../../mocks.dart';
import '../../../../utils.dart';

List<String> expectedUsage(String subDomainPackage) => [
      'Remove an entity from the subdomain $subDomainPackage.\n'
          '\n'
          'Usage: rapid domain $subDomainPackage remove entity <name> [arguments]\n'
          '-h, --help    Print this usage information.\n'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('domain <sub_domain> remove entity', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final project = setupProjectWithDomainPackage('package_a');
        final commandRunner = getCommandRunner(project: project);

        await commandRunner
            .run(['domain', 'package_a', 'remove', 'entity', '--help']);
        expect(printLogs, equals(expectedUsage('package_a')));

        printLogs.clear();

        await commandRunner
            .run(['domain', 'package_a', 'remove', 'entity', '-h']);
        expect(printLogs, equals(expectedUsage('package_a')));
      }),
    );

    group('throws UsageException', () {
      test(
        'when name is missing',
        overridePrint((printLogs) async {
          final project = setupProjectWithDomainPackage('package_a');
          final commandRunner = getCommandRunner(project: project);

          expect(
            () =>
                commandRunner.run(['domain', 'package_a', 'remove', 'entity']),
            throwsUsageException(message: 'No option specified for the name.'),
          );
        }),
      );

      test(
        'when multiple names are provided',
        overridePrint((printLogs) async {
          final project = setupProjectWithDomainPackage('package_a');
          final commandRunner = getCommandRunner(project: project);

          expect(
            () => commandRunner
                .run(['domain', 'package_a', 'remove', 'entity', 'Foo', 'Bar']),
            throwsUsageException(message: 'Multiple names specified.'),
          );
        }),
      );

      test(
        'when name is not a valid dart class name',
        overridePrint((printLogs) async {
          final project = setupProjectWithDomainPackage('package_a');
          final commandRunner = getCommandRunner(project: project);

          expect(
            () => commandRunner
                .run(['domain', 'package_a', 'remove', 'entity', 'foo']),
            throwsUsageException(
              message: '"foo" is not a valid dart class name.',
            ),
          );
        }),
      );
    });

    test('completes', () async {
      final rapid = MockRapid();
      final argResults = MockArgResults();
      when(() => argResults.rest).thenReturn(['Foo']);
      final command = DomainSubDomainRemoveEntityCommand('package_a', null)
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.domainSubDomainRemoveEntity(
          name: 'Foo',
          subDomainName: 'package_a',
        ),
      ).called(1);
    });
  });
}
