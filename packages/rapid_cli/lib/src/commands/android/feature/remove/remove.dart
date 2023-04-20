import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/remove/remove.dart';
import 'package:rapid_cli/src/commands/android/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/android/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template android_feature_remove_command}
/// `rapid android remove` command remove components to features of the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidFeatureRemoveCommand extends PlatformFeatureRemoveCommand {
  /// {@macro android_feature_remove_command}
  AndroidFeatureRemoveCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.android,
          blocCommand:
              AndroidFeatureRemoveBlocCommand(logger: logger, project: project),
          cubitCommand: AndroidFeatureRemoveCubitCommand(
              logger: logger, project: project),
        );
}
