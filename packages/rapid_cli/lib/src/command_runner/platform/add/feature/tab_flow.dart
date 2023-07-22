import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner/util/dart_package_name_rest.dart';
import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/project/platform.dart';

import '../../../base.dart';

class PlatformAddFeatureTabFlowCommand extends RapidLeafCommand
    with DartPackageNameGetter {
  PlatformAddFeatureTabFlowCommand(this.platform, super.project) {
    argParser
      ..addSeparator('')
      ..addOption(
        'sub-features',
        help: 'The features that have this tab flow as a parent.',
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
  String get name => 'tab_flow';

  @override
  String get invocation =>
      'rapid ${platform.name} add feature tab_flow <name> [arguments]';

  @override
  String get description =>
      'Add a tab flow feature to the ${platform.prettyName} part of an existing Rapid project.';

  @override
  Future<void> run() {
    final name = super.dartPackageName;
    final description =
        argResults['desc'] ?? 'The ${name.pascalCase} flow feature.';
    final navigator = argResults['navigator'] ?? false;
    final subFeatures = _validateSubFeatures(argResults['sub-features']);

    return rapid.platformAddFeatureTabFlow(
      platform,
      name: name,
      description: description,
      navigator: navigator,
      subFeatures: subFeatures,
    );
  }

  Set<String> _validateSubFeatures(String? subFeatures) {
    if (subFeatures == null) {
      throw UsageException(
        'No option specified for the sub-features.',
        usage,
      );
    }

    return subFeatures.split(',').map((e) => e.trim()).toSet();
  }
}
