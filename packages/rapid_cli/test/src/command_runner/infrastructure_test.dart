import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../common.dart';
import '../mocks.dart';
import '../utils.dart';

List<String> expectedUsage(
  List<InfrastructurePackage> infrastructurePackages,
) =>
    [
      'Work with the infrastructure part of an existing Rapid project.\n'
          '\n'
          'Usage: rapid infrastructure <subcommand>\n'
          '-h, --help    Print this usage information.\n'
          '\n'
          'Available subcommands:\n'
          '${infrastructurePackages.map((e) => '  ${e.name}   Work with the subinfrastructure ${e.name}.\n').join()}'
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
          final infrastructurePackages = [
            FakeInfrastructurePackage(name: 'package_a'),
            FakeInfrastructurePackage(name: 'package_b'),
          ];
          final project = MockRapidProject(
            appModule: MockAppModule(
              infrastructureDirectory: MockInfrastructureDirectory(
                infrastructurePackages: infrastructurePackages,
              ),
            ),
          );
          final commandRunner = getCommandRunner(project: project);

          await commandRunner.run(['infrastructure', '--help']);
          expect(printLogs, equals(expectedUsage(infrastructurePackages)));

          printLogs.clear();

          await commandRunner.run(['infrastructure', '-h']);
          expect(printLogs, equals(expectedUsage(infrastructurePackages)));
        },
      ),
    );
  });
}
