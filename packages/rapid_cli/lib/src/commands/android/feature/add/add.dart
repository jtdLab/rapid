import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/android/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/android/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/add/add.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template android_feature_add_command}
/// `rapid android remove` command add components to features of the Android part of an existing Rapid project.
/// {@endtemplate}
class AddCommand extends PlatformFeatureAddCommand {
  /// {@macro android_feature_add_command}
  AddCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.android,
          blocCommand: BlocCommand(logger: logger, project: project),
          cubitCommand: CubitCommand(logger: logger, project: project),
        );
}
