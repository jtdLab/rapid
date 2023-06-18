import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner/util/dart_package_name_rest.dart';
import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../../../base.dart';

class PlatformAddFeatureFlowCommand extends RapidLeafCommand
    with DartPackageNameGetter {
  PlatformAddFeatureFlowCommand(this.platform, super.project) {
    argParser
      ..addSeparator('')
      ..addFlag(
        'tabs',
        help: 'Wheter the new feature is a tabflow.',
        negatable: false,
      )
      ..addOption(
        'desc',
        help: 'The description of the new feature.',
      )
      // TODO maybe add a option to specify features that want a dependency before melos bs runs
      ..addFlag(
        'navigator',
        help: 'Wheter to generate a navigator for the new feature.',
        negatable: false,
      );
  }

  final Platform platform;

  @override
  String get name => 'flow';

  @override
  String get invocation =>
      'rapid ${platform.name} add feature flow <name> [arguments]';

  @override
  String get description =>
      'Add a flow feature to the ${platform.prettyName} part of an existing Rapid project.';

  @override
  Future<void> run() {
    final name = super.dartPackageName;
    final tabs = argResults['tabs'] ?? false;
    final description =
        argResults['desc'] ?? 'The ${name.pascalCase} flow feature.';
    final navigator = argResults['navigator'] ?? false;

    return rapid.platformAddFeatureFlow(
      platform,
      name: name,
      tabs: tabs,
      description: description,
      navigator: navigator,
    );
  }
}
