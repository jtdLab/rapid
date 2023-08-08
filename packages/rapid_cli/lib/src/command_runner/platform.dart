import '../project/project.dart';
import '../utils.dart';
import 'base.dart';
import 'platform/add.dart';
import 'platform/feature.dart';
import 'platform/remove.dart';
import 'platform/set.dart';

/// {@template platform_command}
/// `rapid <platform>` work with a platform part of a Rapid environment.
/// {@endtemplate}
class PlatformCommand extends RapidPlatformBranchCommand {
  /// {@macro platform_command}
  PlatformCommand(super.project, {required super.platform}) {
    addSubcommand(PlatformAddCommand(project, platform: platform));

    final featurePackages = project?.appModule
        .platformDirectory(platform: platform)
        .featuresDirectory
        .featurePackages();
    for (final featurePackage
        in featurePackages ?? <PlatformFeaturePackage>[]) {
      addSubcommand(
        PlatformFeatureCommand(
          project,
          platform: platform,
          featureName: featurePackage.name,
        ),
      );
    }

    addSubcommand(PlatformRemoveCommand(project, platform: platform));
    addSubcommand(PlatformSetCommand(project, platform: platform));
  }

  @override
  String get name => platform.name;

  @override
  List<String> get aliases => platform.aliases;

  @override
  String get invocation => 'rapid ${platform.name} <subcommand>';

  @override
  String get description =>
      'Work with the ${platform.prettyName} part of a Rapid project.';
}
