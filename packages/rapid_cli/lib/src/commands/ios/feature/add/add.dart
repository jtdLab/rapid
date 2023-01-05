import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ios/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/ios/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/add/add.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ios_feature_add_command}
/// `rapid ios remove` command add components to features of the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosFeatureAddCommand extends PlatformFeatureAddCommand {
  /// {@macro ios_feature_add_command}
  IosFeatureAddCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.ios,
          blocCommand:
              IosFeatureAddBlocCommand(logger: logger, project: project),
          cubitCommand:
              IosFeatureAddCubitCommand(logger: logger, project: project),
        );
}
