import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/infrastructure/sub_infrastructure/remove/service_implementation.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';

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
        () => rapid.infrastructureSubInfrastructureRemoveServiceImplementation(
          subInfrastructureName: any(named: 'subInfrastructureName'),
          serviceName: any(named: 'serviceName'),
          dir: any(named: 'dir'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async {});
      final argResults = MockArgResults();
      when(() => argResults['service']).thenReturn('Foo');
      when(() => argResults['dir']).thenReturn('some');
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
          serviceName: 'Foo',
          dir: 'some',
        ),
      ).called(1);
    });
  });
}
