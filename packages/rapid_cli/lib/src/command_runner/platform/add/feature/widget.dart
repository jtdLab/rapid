import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner/util/dart_package_name_rest.dart';
import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../../../base.dart';

const _defaultLocalization = true;

class PlatformAddFeatureWidgetCommand extends RapidLeafCommand
    with DartPackageNameGetter {
  PlatformAddFeatureWidgetCommand(this.platform, super.project) {
    argParser
      ..addSeparator('')
      ..addOption(
        'desc',
        help: 'The description of the new feature.',
      )
      ..addFlag(
        'localization',
        help: 'Wether the new feature as localizations.',
        defaultsTo: _defaultLocalization,
      );
    // TODO maybe add a option to specify features that want a dependency before melos bs runs
  }

  final Platform platform;

  @override
  String get name => 'widget';

  @override
  String get invocation =>
      'rapid ${platform.name} add feature widget <name> [arguments]';

  @override
  String get description =>
      'Add a widget feature to the ${platform.prettyName} part of an existing Rapid project.';

  @override
  Future<void> run() {
    final name = super.dartPackageName;
    final description =
        argResults['desc'] ?? 'The ${name.pascalCase} widget feature.';
    final localization = argResults['localization'] ?? _defaultLocalization;

    return rapid.platformAddFeatureWidget(
      platform,
      name: name,
      description: description,
      localization: localization,
    );
  }
}
