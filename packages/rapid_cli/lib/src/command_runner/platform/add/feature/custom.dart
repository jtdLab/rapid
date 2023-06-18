import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner/util/dart_package_name_rest.dart';
import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../../../base.dart';

class PlatformAddFeatureCustomCommand extends RapidLeafCommand
    with DartPackageNameGetter {
  PlatformAddFeatureCustomCommand(this.platform, super.project) {
    argParser
      ..addSeparator('')
      ..addOption(
        'desc',
        help: 'The description of the new feature.',
      )
      // TODO maybe add a option to specify features that want a dependency before melos bs runs
      ..addFlag(
        'routing',
        help: 'Wheter the new feature has routes.',
        negatable: false,
      )
      ..addFlag(
        'navigator',
        help: 'Wheter to generate a navigator for the new feature.',
        negatable: false,
      );
  }

  final Platform platform;

  @override
  String get name => 'custom';

  @override
  String get invocation =>
      'rapid ${platform.name} add feature custom <name> [arguments]';

  @override
  String get description =>
      'Add a custom feature to the ${platform.prettyName} part of an existing Rapid project.';

  @override
  Future<void> run() {
    final name = super.dartPackageName;
    final description = argResults['desc'] ?? 'The ${name.pascalCase} feature.';
    final routing = argResults['routing'] ?? false;
    final navigator = argResults['navigator'] ?? false;

    if (!routing && navigator) {
      throw UsageException(
        'The option "navigator" can not be "true" when "routing" is "false".',
        usage,
      );
    }

    return rapid.platformAddFeatureCustom(
      platform,
      name: name,
      description: description,
      routing: routing,
      navigator: navigator,
    );
  }
}
