import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/infrastructure/sub_infrastructure/add/data_transfer_object.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';
import '../../../../utils.dart';

List<String> expectedUsage(String subInfrastructurePackage) => [
      'Add a data transfer object to the subinfrastructure $subInfrastructurePackage.\n'
          '\n'
          'Usage: rapid infrastructure $subInfrastructurePackage add data_transfer_object [arguments]\n'
          '-h, --help          Print this usage information.\n'
          '\n'
          '\n'
          '-e, --entity        The name of the entity the data transfer object is related to.\n'
          '-o, --output-dir    The output directory relative to <infrastructure_package>/lib/src .\n'
          '                    (defaults to ".")\n'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  group('infrastructure <sub_infrastructure> add data_transfer_object', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final infrastructurePackage =
            MockInfrastructurePackage(name: 'package_a');
        final project =
            getProject(infrastructurePackages: [infrastructurePackage]);
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

    test('completes', () async {
      final rapid = MockRapid();
      when(
        () => rapid.infrastructureSubInfrastructureAddDataTransferObject(
          subInfrastructureName: any(named: 'subInfrastructureName'),
          entityName: any(named: 'entityName'),
        ),
      ).thenAnswer((_) async {});
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
