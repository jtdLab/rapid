import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner/util/dart_package_name_rest.dart';
import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/project/platform.dart';

import '../../../base.dart';

class PlatformAddFeatureFlowCommand extends RapidLeafCommand
    with DartPackageNameGetter {
  PlatformAddFeatureFlowCommand(this.platform, super.project) {
    argParser
      ..addSeparator('')
      ..addOption(
        'features',
        help: 'The features that have this flow as a parent.',
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
    final description = argResults['desc'] ??
        'The ${name.pascalCase} flow feature.'; // TODO share
    final navigator = argResults['navigator'] ?? false; // TODO share?

    return rapid.platformAddFeatureFlow(
      platform,
      name: name,
      description: description,
      navigator: navigator,
    );
  }
}
