import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template activate_ios_command}
/// `rapid activate ios` command adds support for iOS to an existing Rapid project.
/// {@endtemplate}
class ActivateIosCommand extends ActivatePlatformCommand with OrgNameGetter {
  /// {@macro activate_ios_command}
  ActivateIosCommand({
    super.logger,
    required super.project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableIos,
  }) : super(
          platform: Platform.ios,
          flutterConfigEnablePlatform:
              flutterConfigEnableIos ?? Flutter.configEnableIos,
        ) {
    argParser.addOrgNameOption(
      help: 'The organization for the native iOS project.',
    );
  }

  @override
  Future<void> activatePlatform({
    required Project project,
    required Logger logger,
  }) =>
      project.activatePlatform(Platform.ios, orgName: orgName, logger: logger);
}
