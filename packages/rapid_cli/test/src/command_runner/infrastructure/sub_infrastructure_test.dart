import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

List<String> expectedUsage(String subInfrastructurePackage) => [
      'Work with the subinfrastructure $subInfrastructurePackage.\n'
          '\n'
          'Usage: rapid infrastructure $subInfrastructurePackage <subcommand>\n'
          '-h, --help    Print this usage information.\n'
          '\n'
          'Available subcommands:\n'
          '  add      Add a component to the subinfrastructure $subInfrastructurePackage.\n'
          '  remove   Remove a component from the subinfrastructure $subInfrastructurePackage.\n'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  group('infrastructure <sub_infrastructure>', () {
    setUpAll(() {
      registerFallbackValues();
    });

    test(
      'help',
      withRunner(
        (commandRunner, project, __, printLogs) async {
          await commandRunner.run(['infrastructure', 'package_a', '--help']);
          expect(printLogs, equals(expectedUsage('package_a')));

          printLogs.clear();

          await commandRunner.run(['infrastructure', 'package_a', '-h']);
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
  });
}
