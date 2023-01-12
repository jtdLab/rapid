import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

import 'android_bundle.dart';

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
    super.flutterPubGetCommand,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.melosBootstrap,
    super.melosClean,
    super.flutterFormatFix,
    super.generator,
  }) : super(
          platform: Platform.android,
          platformBundle: androidBundle,
          flutterConfigEnablePlatform: flutterConfigEnableAndroid,
        ) {
    argParser.addOrgNameOption(
      help: 'The organization for the native Android project.',
    );
  }

  @override
  Future<List<GeneratedFile>> generate({
    required MasonGenerator generator,
    required Logger logger,
    required Project project,
  }) async {
    final projectName = project.melosFile.name();

    return generator.generate(
      DirectoryGeneratorTarget(Directory('.')),
      vars: {
        'project_name': projectName,
        'org_name': orgName,
      },
      logger: logger,
    );
  }
}
