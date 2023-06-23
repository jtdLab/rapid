import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner/util/dart_package_name_rest.dart';
import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../../../base.dart';

const _defaultLocalization = true;

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
      ..addFlag(
        'tab',
        help: 'Wheter the new feature is a tabflow.',
        negatable: false,
      )
      // TODO maybe add a option to specify features that want a dependency before melos bs runs
      ..addFlag(
        'navigator',
        help: 'Wheter to generate a navigator for the new feature.',
        negatable: false,
      )
      ..addFlag(
        'localization',
        help: 'Wether the new feature as localizations.',
        defaultsTo: _defaultLocalization,
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
    final tab = argResults['tab'] ?? false;
    final description =
        argResults['desc'] ?? 'The ${name.pascalCase} flow feature.';
    final navigator = argResults['navigator'] ?? false;
    final localization = argResults['localization'] ?? _defaultLocalization;
    final features = tab ? _validateSubFeatures(argResults['features']) : null;

    return rapid.platformAddFeatureFlow(
      platform,
      name: name,
      tab: tab,
      description: description,
      navigator: navigator,
      localization: localization,
      features: features,
    );
  }

  Set<String> _validateSubFeatures(String? features) {
    if (features == null) {
      throw UsageException(
        'No option specified for the features.',
        usage,
      );
    }

    return features.split(',').map((e) => e.trim()).toSet();
  }
}
