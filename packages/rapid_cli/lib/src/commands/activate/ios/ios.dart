import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

import 'ios_bundle.dart';

/// {@template activate_ios_command}
/// `rapid activate ios` command adds support for iOS to an existing Rapid project.
/// {@endtemplate}
class ActivateIosCommand extends ActivatePlatformCommand with OrgNameGetter {
  /// {@macro activate_ios_command}
  ActivateIosCommand({
    super.logger,
    required super.project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableIos,
    super.flutterPubGetCommand,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.melosBootstrap,
    super.melosClean,
    super.flutterFormatFix,
    super.generator,
  }) : super(
          platform: Platform.ios,
          platformBundle: iosBundle,
          flutterConfigEnablePlatform: flutterConfigEnableIos,
        ) {
    argParser.addOrgNameOption(
      help: 'The organization for the native iOS project.',
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
