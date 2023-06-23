import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../common.dart';
import '../mocks.dart';

List<String> expectedUsage(List<String> subInfrastructurePackages) => [
      'Work with the infrastructure part of an existing Rapid project.\n'
          '\n'
          'Usage: rapid infrastructure <subcommand>\n'
          '-h, --help    Print this usage information.\n'
          '\n'
          'Available subcommands:\n'
          '${subInfrastructurePackages.map((e) => '  $e   Work with the subinfrastructure $e.\n').join()}'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  group('infrastructure', () {
    setUpAll(() {
      registerFallbackValues();
    });

    test(
      'help',
      withRunner(
        (commandRunner, project, __, printLogs) async {
          await commandRunner.run(['infrastructure', '--help']);
          expect(printLogs, equals(expectedUsage(['package_a', 'package_b'])));

          printLogs.clear();

          await commandRunner.run(['infrastructure', '-h']);
          expect(printLogs, equals(expectedUsage(['package_a', 'package_b'])));
        },
        setupProject: (project) {
          final infrastructurePackageA = MockInfrastructurePackage();
          when(() => infrastructurePackageA.name).thenReturn('package_a');
          final infrastructurePackageB = MockInfrastructurePackage();
          when(() => infrastructurePackageB.name).thenReturn('package_b');
          final infrastructureDirectory = MockInfrastructureDirectory();
          when(() => infrastructureDirectory.infrastructurePackages())
              .thenReturn([infrastructurePackageA, infrastructurePackageB]);
          when(() => project.infrastructureDirectory)
              .thenReturn(infrastructureDirectory);
        },
      ),
    );
  });
}
