import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/android/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/android/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/add/add.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/project.dart';

/// {@template android_feature_add_command}
/// `rapid android remove` command add components to features of the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidFeatureAddCommand extends PlatformFeatureAddCommand {
  /// {@macro android_feature_add_command}
  AndroidFeatureAddCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.android,
          blocCommand:
              AndroidFeatureAddBlocCommand(logger: logger, project: project),
          cubitCommand:
              AndroidFeatureAddCubitCommand(logger: logger, project: project),
        );
}
