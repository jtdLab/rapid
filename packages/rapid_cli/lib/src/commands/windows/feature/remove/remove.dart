import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/remove/remove.dart';
import 'package:rapid_cli/src/commands/windows/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/windows/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template windows_feature_remove_command}
/// `rapid windows remove` command remove components to features of the Windows part of an existing Rapid project.
/// {@endtemplate}
class WindowsFeatureRemoveCommand extends PlatformFeatureRemoveCommand {
  /// {@macro windows_feature_remove_command}
  WindowsFeatureRemoveCommand({
    Logger? logger,
    Project? project,
    required super.featurePackage,
  }) : super(
          platform: Platform.windows,
          blocCommand: WindowsFeatureRemoveBlocCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
          cubitCommand: WindowsFeatureRemoveCubitCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
        );
}
