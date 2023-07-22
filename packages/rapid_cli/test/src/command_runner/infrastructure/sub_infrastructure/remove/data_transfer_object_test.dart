import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/infrastructure/sub_infrastructure/remove/data_transfer_object.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../matchers.dart';
import '../../../../mocks.dart';
import '../../../../utils.dart';

List<String> expectedUsage(String subInfrastructurePackage) => [
      'Remove a data transfer object from the subinfrastructure $subInfrastructurePackage.\n'
          '\n'
          'Usage: rapid infrastructure $subInfrastructurePackage remove data_transfer_object <name> [arguments]\n'
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

  group('infrastructure <sub_infrastructure> remove data_transfer_object', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final infrastructurePackage =
            FakeInfrastructurePackage(name: 'package_a');
        final project = MockRapidProject(
          appModule: MockAppModule(
            infrastructureDirectory: MockInfrastructureDirectory(
              infrastructurePackages: [infrastructurePackage],
            ),
          ),
        );
        final commandRunner = getCommandRunner(project: project);

        await commandRunner.run([
          'infrastructure',
          'package_a',
          'remove',
          'data_transfer_object',
          '--help'
        ]);
        expect(printLogs, equals(expectedUsage('package_a')));

        printLogs.clear();

        await commandRunner.run([
          'infrastructure',
          'package_a',
          'remove',
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
          final infrastructurePackage =
              FakeInfrastructurePackage(name: 'package_a');
          final project = MockRapidProject(
            appModule: MockAppModule(
              infrastructureDirectory: MockInfrastructureDirectory(
                infrastructurePackages: [infrastructurePackage],
              ),
            ),
          );
          final commandRunner = getCommandRunner(project: project);

          expect(
            () => commandRunner.run([
              'infrastructure',
              'package_a',
              'remove',
              'data_transfer_object',
            ]),
            throwsUsageException(
              message: 'No option specified for the entity.',
            ),
          );
        }),
      );

      test(
        'when entity is not a valid dart class name',
        overridePrint((printLogs) async {
          final infrastructurePackage =
              FakeInfrastructurePackage(name: 'package_a');
          final project = MockRapidProject(
            appModule: MockAppModule(
              infrastructureDirectory: MockInfrastructureDirectory(
                infrastructurePackages: [infrastructurePackage],
              ),
            ),
          );
          final commandRunner = getCommandRunner(project: project);

          expect(
            () => commandRunner.run([
              'infrastructure',
              'package_a',
              'remove',
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
      when(
        () => rapid.infrastructureSubInfrastructureRemoveDataTransferObject(
          subInfrastructureName: any(named: 'subInfrastructureName'),
          entityName: any(named: 'entityName'),
        ),
      ).thenAnswer((_) async {});
      final argResults = MockArgResults();
      when(() => argResults['entity']).thenReturn('Foo');
      final command =
          InfrastructureSubInfrastructureRemoveDataTransferObjectCommand(
              'package_a', null)
            ..argResultOverrides = argResults
            ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.infrastructureSubInfrastructureRemoveDataTransferObject(
          subInfrastructureName: 'package_a',
          entityName: 'Foo',
        ),
      ).called(1);
    });
  });
}
