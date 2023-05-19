import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/remove/remove.dart';
import 'package:rapid_cli/src/commands/ios/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/ios/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ios_feature_remove_command}
/// `rapid ios remove` command remove components to features of the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosFeatureRemoveCommand extends PlatformFeatureRemoveCommand {
  /// {@macro ios_feature_remove_command}
  IosFeatureRemoveCommand({
    Logger? logger,
    Project? project,
    required super.featurePackage,
  }) : super(
          platform: Platform.ios,
          blocCommand: IosFeatureRemoveBlocCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
          cubitCommand: IosFeatureRemoveCubitCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
        );
}
