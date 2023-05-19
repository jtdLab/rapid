import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/add/add.dart';
import 'package:rapid_cli/src/commands/linux/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/linux/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template linux_feature_add_command}
/// `rapid linux remove` command add components to features of the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxFeatureAddCommand extends PlatformFeatureAddCommand {
  /// {@macro linux_feature_add_command}
  LinuxFeatureAddCommand({
    Logger? logger,
    Project? project,
    required super.featurePackage,
  }) : super(
          platform: Platform.linux,
          blocCommand: LinuxFeatureAddBlocCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
          cubitCommand: LinuxFeatureAddCubitCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
        );
}
