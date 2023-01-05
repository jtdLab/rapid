import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ios/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/ios/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/add/add.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template android_feature_add_command}
/// `rapid ios remove` command add components to features of the iOS part of an existing Rapid project.
/// {@endtemplate}
class AndroidFeatureAddCommand extends PlatformFeatureAddCommand {
  /// {@macro android_feature_add_command}
  AndroidFeatureAddCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.ios,
          blocCommand:
              AndroidFeatureAddBlocCommand(logger: logger, project: project),
          cubitCommand:
              AndroidFeatureAddCubitCommand(logger: logger, project: project),
        );
}
