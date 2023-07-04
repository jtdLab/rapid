import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner/util/dart_package_name_rest.dart';
import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/project/platform.dart';

import '../../../base.dart';

class PlatformAddFeaturePageCommand extends RapidLeafCommand
    with DartPackageNameGetter {
  PlatformAddFeaturePageCommand(this.platform, super.project) {
    argParser
      ..addSeparator('')
      ..addOption(
        'desc',
        help: 'The description of the new feature.',
      )
      // TODO maybe add a option to specify features that want a dependency before melos bs runs
      ..addFlag(
        'navigator',
        help: 'Whether to generate a navigator for the new feature.',
        negatable: false,
      );
  }

  final Platform platform;

  @override
  String get name => 'page';

  @override
  String get invocation =>
      'rapid ${platform.name} add feature page <name> [arguments]';

  @override
  String get description =>
      'Add a page feature to the ${platform.prettyName} part of an existing Rapid project.';

  @override
  Future<void> run() {
    final name = super.dartPackageName;
    final description =
        argResults['desc'] ?? 'The ${name.pascalCase} page feature.';
    final navigator = argResults['navigator'] ?? false;

    return rapid.platformAddFeaturePage(
      platform,
      name: name,
      description: description,
      navigator: navigator,
    );
  }
}
