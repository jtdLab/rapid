import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/remove/remove.dart';
import 'package:rapid_cli/src/commands/web/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/web/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template web_feature_remove_command}
/// `rapid web remove` command remove components to features of the Web part of an existing Rapid project.
/// {@endtemplate}
class WebFeatureRemoveCommand extends PlatformFeatureRemoveCommand {
  /// {@macro web_feature_remove_command}
  WebFeatureRemoveCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.web,
          blocCommand:
              WebFeatureRemoveBlocCommand(logger: logger, project: project),
          cubitCommand:
              WebFeatureRemoveCubitCommand(logger: logger, project: project),
        );
}
