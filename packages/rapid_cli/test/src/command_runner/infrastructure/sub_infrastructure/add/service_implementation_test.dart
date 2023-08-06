import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/infrastructure/sub_infrastructure/add/service_implementation.dart';
import 'package:test/test.dart';

import '../../../../matchers.dart';
import '../../../../mocks.dart';
import '../../../../utils.dart';

List<String> expectedUsage(String subInfrastructurePackage) => [
      'Add a service implementation to the subinfrastructure $subInfrastructurePackage.\n'
          '\n'
          'Usage: rapid infrastructure $subInfrastructurePackage add service_implementation <name> [arguments]\n'
          '-h, --help       Print this usage information.\n'
          '\n'
          '\n'
          '-s, --service    The name of the service interface the service implementation is related to.\n'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('infrastructure <sub_infrastructure> add service_implementation', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final project = setupProjectWithInfrastructurePackage('package_a');
        final commandRunner = getCommandRunner(project: project);

        await commandRunner.run([
          'infrastructure',
          'package_a',
          'add',
          'service_implementation',
          '--help'
        ]);
        expect(printLogs, equals(expectedUsage('package_a')));

        printLogs.clear();

        await commandRunner.run([
          'infrastructure',
          'package_a',
          'add',
          'service_implementation',
          '-h'
        ]);
        expect(printLogs, equals(expectedUsage('package_a')));
      }),
    );

    group('throws UsageException', () {
      test(
        'when service is missing',
        overridePrint((printLogs) async {
          final project = setupProjectWithInfrastructurePackage('package_a');
          final commandRunner = getCommandRunner(project: project);

          expect(
            () => commandRunner.run([
              'infrastructure',
              'package_a',
              'add',
              'service_implementation',
              'Foo'
            ]),
            throwsUsageException(
              message: 'No option specified for the service.',
            ),
          );
        }),
      );

      test(
        'when service is not a valid dart class name',
        overridePrint((printLogs) async {
          final project = setupProjectWithInfrastructurePackage('package_a');
          final commandRunner = getCommandRunner(project: project);

          expect(
            () => commandRunner.run([
              'infrastructure',
              'package_a',
              'add',
              'service_implementation',
              'Foo',
              '--service',
              'foo'
            ]),
            throwsUsageException(
              message: '"foo" is not a valid dart class name.',
            ),
          );
        }),
      );

      test(
        'when name is missing',
        overridePrint((printLogs) async {
          final project = setupProjectWithInfrastructurePackage('package_a');
          final commandRunner = getCommandRunner(project: project);

          expect(
            () => commandRunner.run([
              'infrastructure',
              'package_a',
              'add',
              'service_implementation',
            ]),
            throwsUsageException(message: 'No option specified for the name.'),
          );
        }),
      );

      test(
        'when multiple names are provided',
        overridePrint((printLogs) async {
          final project = setupProjectWithInfrastructurePackage('package_a');
          final commandRunner = getCommandRunner(project: project);

          expect(
            () => commandRunner.run([
              'infrastructure',
              'package_a',
              'add',
              'service_implementation',
              'Foo',
              'Bar'
            ]),
            throwsUsageException(message: 'Multiple names specified.'),
          );
        }),
      );

      test(
        'when name is not a valid dart class name',
        overridePrint((printLogs) async {
          final project = setupProjectWithInfrastructurePackage('package_a');
          final commandRunner = getCommandRunner(project: project);

          expect(
            () => commandRunner.run([
              'infrastructure',
              'package_a',
              'add',
              'service_implementation',
              'foo'
            ]),
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
      when(() => argResults['service']).thenReturn('Foo');
      when(() => argResults.rest).thenReturn(['My']);
      final command =
          InfrastructureSubInfrastructureAddServiceImplementationCommand(
              'package_a', null)
            ..argResultOverrides = argResults
            ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.infrastructureSubInfrastructureAddServiceImplementation(
          name: 'My',
          subInfrastructureName: 'package_a',
          serviceInterfaceName: 'Foo',
        ),
      ).called(1);
    });
  });
}
