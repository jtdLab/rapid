import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../../base.dart';
import '../../util/dart_package_name_rest.dart';

class PlatformAddFeatureCommand extends RapidLeafCommand
    with DartPackageNameGetter {
  PlatformAddFeatureCommand(this.platform, super.project) {
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
      );
  }

  final Platform platform;

  @override
  String get name => 'feature';

  @override
  List<String> get aliases => ['feat'];

  @override
  String get invocation =>
      'rapid ${platform.name} add feature <name> [arguments]';

  @override
  String get description =>
      'Add a feature to the ${platform.prettyName} part of an existing Rapid project.';

  @override
  Future<void> run() {
    final name = super.dartPackageName;
    final description = argResults['desc'] ?? 'The ${name.pascalCase} feature.';
    final routing = argResults['routing'] ?? false;

    return rapid.platformAddFeature(
      platform,
      name: name,
      description: description,
      routing: routing,
    );
  }
}
