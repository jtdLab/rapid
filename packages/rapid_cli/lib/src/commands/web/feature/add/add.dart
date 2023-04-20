import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/web/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/web/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/add/add.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template web_feature_add_command}
/// `rapid web remove` command add components to features of the Web part of an existing Rapid project.
/// {@endtemplate}
class WebFeatureAddCommand extends PlatformFeatureAddCommand {
  /// {@macro web_feature_add_command}
  WebFeatureAddCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.web,
          blocCommand:
              WebFeatureAddBlocCommand(logger: logger, project: project),
          cubitCommand:
              WebFeatureAddCubitCommand(logger: logger, project: project),
        );
}
