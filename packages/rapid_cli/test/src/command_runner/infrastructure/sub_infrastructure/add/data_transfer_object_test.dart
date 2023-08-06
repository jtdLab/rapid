import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/infrastructure/sub_infrastructure/add/data_transfer_object.dart';
import 'package:test/test.dart';

import '../../../../matchers.dart';
import '../../../../mocks.dart';
import '../../../../utils.dart';

List<String> expectedUsage(String subInfrastructurePackage) => [
      'Add a data transfer object to the subinfrastructure $subInfrastructurePackage.\n'
          '\n'
          'Usage: rapid infrastructure $subInfrastructurePackage add data_transfer_object [arguments]\n'
          '-h, --help      Print this usage information.\n'
          '\n'
          '\n'
          '-e, --entity    The name of the entity the data transfer object is related to.\n'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('infrastructure <sub_infrastructure> add data_transfer_object', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final project = setupProjectWithInfrastructurePackage('package_a');
        final commandRunner = getCommandRunner(project: project);

        await commandRunner.run([
          'infrastructure',
          'package_a',
          'add',
          'data_transfer_object',
          '--help'
        ]);
        expect(printLogs, equals(expectedUsage('package_a')));

        printLogs.clear();

        await commandRunner.run([
          'infrastructure',
          'package_a',
          'add',
          'data_transfer_object',
          '-h'
        ]);
        expect(printLogs, equals(expectedUsage('package_a')));
      }),
    );

    group('throws UsageException', () {
      test(
        'when entity is missing',
        overridePrint((printLogs) async {
          final project = setupProjectWithInfrastructurePackage('package_a');
          final commandRunner = getCommandRunner(project: project);

          expect(
            () => commandRunner.run(
                ['infrastructure', 'package_a', 'add', 'data_transfer_object']),
            throwsUsageException(
              message: 'No option specified for the entity.',
            ),
          );
        }),
      );

      test(
        'when entity is not a valid dart class name',
        overridePrint((printLogs) async {
          final project = setupProjectWithInfrastructurePackage('package_a');
          final commandRunner = getCommandRunner(project: project);

          expect(
            () => commandRunner.run([
              'infrastructure',
              'package_a',
              'add',
              'data_transfer_object',
              '--entity',
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
      when(() => argResults['entity']).thenReturn('Foo');
      final command =
          InfrastructureSubInfrastructureAddDataTransferObjectCommand(
              'package_a', null)
            ..argResultOverrides = argResults
            ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.infrastructureSubInfrastructureAddDataTransferObject(
          subInfrastructureName: 'package_a',
          entityName: 'Foo',
        ),
      ).called(1);
    });
  });
}
