import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';
import '../../utils.dart';

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
  setUpAll(() {
    registerFallbackValues();
  });

  group('infrastructure <sub_infrastructure>', () {
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

        await commandRunner.run(['infrastructure', 'package_a', '--help']);
        expect(printLogs, equals(expectedUsage('package_a')));

        printLogs.clear();

        await commandRunner.run(['infrastructure', 'package_a', '-h']);
        expect(printLogs, equals(expectedUsage('package_a')));
      }),
    );
  });
}
