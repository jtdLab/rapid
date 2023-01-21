import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/windows/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/windows/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/add/add.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template windows_feature_add_command}
/// `rapid windows remove` command add components to features of the Windows part of an existing Rapid project.
/// {@endtemplate}
class WindowsFeatureAddCommand extends PlatformFeatureAddCommand {
  /// {@macro windows_feature_add_command}
  WindowsFeatureAddCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.windows,
          blocCommand:
              WindowsFeatureAddBlocCommand(logger: logger, project: project),
          cubitCommand:
              WindowsFeatureAddCubitCommand(logger: logger, project: project),
        );
}
