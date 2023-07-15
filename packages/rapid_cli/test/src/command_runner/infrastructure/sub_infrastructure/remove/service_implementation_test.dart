import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/infrastructure/sub_infrastructure/remove/service_implementation.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';
import '../../../../utils.dart';

List<String> expectedUsage(String subInfrastructurePackage) => [
      'Remove a service implementation from the subinfrastructure $subInfrastructurePackage.\n'
          '\n'
          'Usage: rapid infrastructure $subInfrastructurePackage remove service_implementation <name> [arguments]\n'
          '-h, --help       Print this usage information.\n'
          '\n'
          '\n'
          '-s, --service    The name of the service interface the service implementation is related to.\n'
          '-d, --dir        The directory relative to <infrastructure_package>/lib/ .\n'
          '                 (defaults to ".")\n'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  group('infrastructure <sub_infrastructure> remove service_implementation',
      () {
    test(
      'help',
      overridePrint((printLogs) async {
        final infrastructurePackage =
            FakeInfrastructurePackage(name: 'package_a');
        final project =
            getProject(infrastructurePackages: [infrastructurePackage]);
        final commandRunner = getCommandRunner(project: project);

        await commandRunner.run([
          'infrastructure',
          'package_a',
          'remove',
          'service_implementation',
          '--help'
        ]);
        expect(printLogs, equals(expectedUsage('package_a')));

        printLogs.clear();

        await commandRunner.run([
          'infrastructure',
          'package_a',
          'remove',
          'service_implementation',
          '-h'
        ]);
        expect(printLogs, equals(expectedUsage('package_a')));
      }),
    );

    test('completes', () async {
      final rapid = MockRapid();
      when(
        () => rapid.infrastructureSubInfrastructureRemoveServiceImplementation(
          subInfrastructureName: any(named: 'subInfrastructureName'),
          serviceInterfaceName: any(named: 'serviceInterfaceName'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async {});
      final argResults = MockArgResults();
      when(() => argResults['service']).thenReturn('Foo');
      when(() => argResults.rest).thenReturn(['My']);
      final command =
          InfrastructureSubInfrastructureRemoveServiceImplementationCommand(
              'package_a', null)
            ..argResultOverrides = argResults
            ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.infrastructureSubInfrastructureRemoveServiceImplementation(
          name: 'My',
          subInfrastructureName: 'package_a',
          serviceInterfaceName: 'Foo',
        ),
      ).called(1);
    });
  });
}
