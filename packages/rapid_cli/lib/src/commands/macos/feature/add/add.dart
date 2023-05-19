import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/macos/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/macos/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/add/add.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template macos_feature_add_command}
/// `rapid macos remove` command add components to features of the macOS part of an existing Rapid project.
/// {@endtemplate}
class MacosFeatureAddCommand extends PlatformFeatureAddCommand {
  /// {@macro macos_feature_add_command}
  MacosFeatureAddCommand({
    Logger? logger,
    Project? project,
    required super.featurePackage,
  }) : super(
          platform: Platform.macos,
          blocCommand: MacosFeatureAddBlocCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
          cubitCommand: MacosFeatureAddCubitCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
        );
}
