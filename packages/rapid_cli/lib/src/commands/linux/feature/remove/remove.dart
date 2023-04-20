import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/remove/remove.dart';
import 'package:rapid_cli/src/commands/linux/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/linux/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template linux_feature_remove_command}
/// `rapid linux remove` command remove components to features of the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxFeatureRemoveCommand extends PlatformFeatureRemoveCommand {
  /// {@macro linux_feature_remove_command}
  LinuxFeatureRemoveCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.linux,
          blocCommand:
              LinuxFeatureRemoveBlocCommand(logger: logger, project: project),
          cubitCommand:
              LinuxFeatureRemoveCubitCommand(logger: logger, project: project),
        );
}
