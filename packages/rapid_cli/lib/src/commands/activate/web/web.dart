import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// The default description.
const _defaultDescription = 'A Rapid app.';

/// {@template activate_web_command}
/// `rapid activate web` command adds support for Web to an existing Rapid project.
/// {@endtemplate}
class ActivateWebCommand extends ActivatePlatformCommand with OrgNameGetter {
  /// {@macro activate_web_command}
  ActivateWebCommand({
    super.logger,
    required super.project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWeb,
  }) : super(
          platform: Platform.web,
          flutterConfigEnablePlatform:
              flutterConfigEnableWeb ?? Flutter.configEnableWeb,
        ) {
    argParser.addOption(
      'desc',
      help: 'The description of the project.',
      defaultsTo: _defaultDescription,
    );
  }

  @override
  Future<void> activatePlatform({
    required Project project,
    required Logger logger,
  }) =>
      project.activatePlatform(
        Platform.web,
        description: _description,
        logger: logger,
      );

  // TODO shareable with create ?

  /// Gets the description for the project specified by the user.
  String get _description => argResults['desc'] ?? _defaultDescription;
}
