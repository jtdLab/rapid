import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/remove/remove.dart';
import 'package:rapid_cli/src/commands/macos/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/macos/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template macos_feature_remove_command}
/// `rapid macos remove` command remove components to features of the macOS part of an existing Rapid project.
/// {@endtemplate}
class MacosFeatureRemoveCommand extends PlatformFeatureRemoveCommand {
  /// {@macro macos_feature_remove_command}
  MacosFeatureRemoveCommand({
    Logger? logger,
    Project? project,
    required super.featurePackage,
  }) : super(
          platform: Platform.macos,
          blocCommand: MacosFeatureRemoveBlocCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
          cubitCommand: MacosFeatureRemoveCubitCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
        );
}
