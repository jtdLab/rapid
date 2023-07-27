import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../common.dart';
import '../../../mocks.dart';
import '../../../utils.dart';

List<String> expectedUsage(
  String featurePackage, {
  required Platform platform,
}) {
  return [
    'Remove components from $featurePackage of the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} $featurePackage remove <component>\n'
        '-h, --help    Print this usage information.\n'
        '\n'
        'Available subcommands:\n'
        '  bloc    Removes a bloc from $featurePackage of the ${platform.prettyName} part of an existing Rapid project.\n'
        '  cubit   Removes a cubit from $featurePackage of the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  for (final platform in Platform.values) {
    group('${platform.name} <feature> remove', () {
      test(
        'help',
        overridePrint((printLogs) async {
          final project = MockRapidProject(
            appModule: MockAppModule(
              platformDirectory: ({required Platform platform}) =>
                  MockPlatformDirectory(
                featuresDirectory: MockPlatformFeaturesDirectory(
                  featurePackages: [
                    FakePlatformFeaturePackage(name: 'package_a'),
                  ],
                ),
              ),
            ),
          );
          final commandRunner = getCommandRunner(project: project);

          await commandRunner
              .run([platform.name, 'package_a', 'remove', '--help']);
          expect(
            printLogs,
            equals(expectedUsage('package_a', platform: platform)),
          );

          printLogs.clear();

          await commandRunner.run([platform.name, 'package_a', 'remove', '-h']);
          expect(
            printLogs,
            equals(expectedUsage('package_a', platform: platform)),
          );
        }),
      );
    });
  }
}
