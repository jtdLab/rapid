import '../project/platform.dart';
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
class PlatformCommand extends RapidBranchCommand {
  /// {@macro platform_command}
  PlatformCommand(this.platform, super.project) {
    addSubcommand(PlatformAddCommand(platform, project));

    final featurePackages = project?.appModule
        .platformDirectory(platform: platform)
        .featuresDirectory
        .featurePackages();
    for (final featurePackage
        in featurePackages ?? <PlatformFeaturePackage>[]) {
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
      'Work with the ${platform.prettyName} part of a Rapid project.';
}
