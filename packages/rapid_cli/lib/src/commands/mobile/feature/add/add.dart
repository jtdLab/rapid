import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/add/add.dart';
import 'package:rapid_cli/src/commands/mobile/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/mobile/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template mobile_feature_add_command}
/// `rapid mobile remove` command add components to features of the Mobile part of an existing Rapid project.
/// {@endtemplate}
class MobileFeatureAddCommand extends PlatformFeatureAddCommand {
  /// {@macro mobile_feature_add_command}
  MobileFeatureAddCommand({
    Logger? logger,
    Project? project,
    required super.featurePackage,
  }) : super(
          platform: Platform.mobile,
          blocCommand: MobileFeatureAddBlocCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
          cubitCommand: MobileFeatureAddCubitCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
        );
}
