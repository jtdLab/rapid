import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/remove/remove.dart';
import 'package:rapid_cli/src/commands/mobile/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/mobile/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template mobile_feature_remove_command}
/// `rapid mobile remove` command remove components to features of the Mobile part of an existing Rapid project.
/// {@endtemplate}
class MobileFeatureRemoveCommand extends PlatformFeatureRemoveCommand {
  /// {@macro mobile_feature_remove_command}
  MobileFeatureRemoveCommand({
    Logger? logger,
    Project? project,
    required super.featurePackage,
  }) : super(
          platform: Platform.mobile,
          blocCommand: MobileFeatureRemoveBlocCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
          cubitCommand: MobileFeatureRemoveCubitCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
        );
}
