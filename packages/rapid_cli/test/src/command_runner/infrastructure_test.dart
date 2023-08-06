import 'package:test/test.dart';

import '../mocks.dart';
import '../utils.dart';

List<String> expectedUsage(List<String> infrastructurePackages) => [
      'Work with the infrastructure part of an existing Rapid project.\n'
          '\n'
          'Usage: rapid infrastructure <subcommand>\n'
          '-h, --help    Print this usage information.\n'
          '\n'
          'Available subcommands:\n'
          '${infrastructurePackages.map((infrastructurePackage) => '  $infrastructurePackage   Work with the subinfrastructure $infrastructurePackage.\n').join()}'
          '\n'
          'Run "rapid help" to see global options.'
    ];

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('infrastructure', () {
    test(
      'help',
      overridePrint(
        (printLogs) async {
          final project = MockRapidProject(
            appModule: MockAppModule(
              infrastructureDirectory: MockInfrastructureDirectory(
                infrastructurePackages: [
                  FakeInfrastructurePackage(name: 'package_a'),
                  FakeInfrastructurePackage(name: 'package_b'),
                ],
              ),
            ),
          );
          final commandRunner = getCommandRunner(project: project);

          await commandRunner.run(['infrastructure', '--help']);
          expect(printLogs, equals(expectedUsage(['package_a', 'package_b'])));

          printLogs.clear();

          await commandRunner.run(['infrastructure', '-h']);
          expect(printLogs, equals(expectedUsage(['package_a', 'package_b'])));
        },
      ),
    );
  });
}
