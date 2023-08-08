import 'package:test/test.dart';

import '../mocks.dart';
import '../utils.dart';

List<String> expectedUsage(List<String> infrastructurePackages) => [
      'Work with the infrastructure part of a Rapid project.',
      '',
      'Usage: rapid infrastructure <subcommand>',
      '-h, --help    Print this usage information.',
      '',
      'Available subcommands:',
      ...infrastructurePackages.map(
        (infrastructurePackage) =>
            '''  $infrastructurePackage   Work with the subinfrastructure $infrastructurePackage.''',
      ),
      '',
      'Run "rapid help" to see global options.'
    ];

void main() {
  setUpAll(registerFallbackValues);

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
