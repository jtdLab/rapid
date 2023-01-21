import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template activate_android_command}
/// `rapid activate android` command adds support for Android to an existing Rapid project.
/// {@endtemplate}
class ActivateAndroidCommand extends ActivatePlatformCommand
    with OrgNameGetter {
  /// {@macro activate_android_command}
  ActivateAndroidCommand({
    super.logger,
    required super.project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableAndroid,
    super.melosBootstrap,
    super.melosClean,
    super.flutterFormatFix,
  }) : super(
          platform: Platform.android,
          flutterConfigEnablePlatform: flutterConfigEnableAndroid,
        ) {
    argParser.addOrgNameOption(
      help: 'The organization for the native Android project.',
    );
  }

  @override
  Future<void> activatePlatform(
    Platform platform, {
    required Project project,
    required Logger logger,
  }) =>
      project.activatePlatform(platform, orgName: orgName, logger: logger);
}
