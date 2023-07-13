import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/project/platform.dart';

import 'base.dart';
import 'platform/add.dart';
import 'platform/feature.dart';
import 'platform/remove.dart';
import 'platform/set.dart';

class PlatformCommand extends RapidBranchCommand {
  PlatformCommand(this.platform, super.project) {
    addSubcommand(PlatformAddCommand(platform, project));

    final featurePackages = project?.appModule
        .platformDirectory(platform: platform)
        .featuresDirectory
        .featurePackages();
    for (final featurePackage in featurePackages ?? []) {
      addSubcommand(
        PlatformFeatureCommand(
          platform,
          featurePackage.name,
          project,
        ),
      );
    }

    addSubcommand(PlatformRemoveCommand(platform, project));
    addSubcommand(PlatformSetCommand(platform, project));
  }

  final Platform platform;

  @override
  String get name => platform.name;

  @override
  List<String> get aliases => platform.aliases;

  @override
  String get invocation => 'rapid ${platform.name} <subcommand>';

  @override
  String get description =>
      'Work with the ${platform.prettyName} part of an existing Rapid project.';
}
