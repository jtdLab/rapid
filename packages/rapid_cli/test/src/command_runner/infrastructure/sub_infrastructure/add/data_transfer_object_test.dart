import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/infrastructure/sub_infrastructure/add/data_transfer_object.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';

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
    setUpAll(() {
      registerFallbackValues();
    });

    test(
      'help',
      withRunner(
        (commandRunner, project, __, printLogs) async {
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
        },
        setupProject: (project) {
          final infrastructurePackageA = MockInfrastructurePackage();
          when(() => infrastructurePackageA.name).thenReturn('package_a');
          final infrastructureDirectory = MockInfrastructureDirectory();
          when(() => infrastructureDirectory.infrastructurePackages())
              .thenReturn([infrastructurePackageA]);
          when(() => project.infrastructureDirectory)
              .thenReturn(infrastructureDirectory);
        },
      ),
    );

    test('completes', () async {
      final rapid = MockRapid();
      when(
        () => rapid.infrastructureSubInfrastructureAddDataTransferObject(
          subInfrastructureName: any(named: 'subInfrastructureName'),
          entityName: any(named: 'entityName'),
          outputDir: any(named: 'outputDir'),
        ),
      ).thenAnswer((_) async {});
      final argResults = MockArgResults();
      when(() => argResults['entity']).thenReturn('Foo');
      when(() => argResults['output-dir']).thenReturn('some');
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
          outputDir: 'some',
        ),
      ).called(1);
    });
  });
}
