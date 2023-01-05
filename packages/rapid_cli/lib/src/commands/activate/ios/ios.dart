import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/activate_platform_command.dart';
import 'package:rapid_cli/src/commands/activate/ios/ios_bundle.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

/// {@template activate_ios_command}
/// `rapid activate ios` command adds support for iOS to an existing Rapid project.
/// {@endtemplate}
class ActivateIosCommand extends ActivatePlatformCommand with OrgNameGetters {
  /// {@macro activate_ios_command}
  ActivateIosCommand({
    Logger? logger,
    required Project project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableIos,
    FlutterPubGetCommand? flutterPubGetCommand,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    MelosBootstrapCommand? melosBootstrap,
    MelosCleanCommand? melosClean,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super(
          platform: Platform.ios,
          logger: logger ?? Logger(),
          project: project,
          flutterConfigEnablePlatform:
              flutterConfigEnableIos ?? Flutter.configEnableIos,
          flutterPubGetCommand: flutterPubGetCommand ?? Flutter.pubGet,
          flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
              flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                  Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
          melosBootstrap: melosBootstrap ?? Melos.bootstrap,
          melosClean: melosClean ?? Melos.clean,
        ) {
    argParser.addOrgNameOption(
      help: 'The organization for the native iOS project.',
    );
  }

  final GeneratorBuilder _generator;

  @override
  Future<List<GeneratedFile>> generate({
    required Logger logger,
    required Project project,
  }) async {
    final projectName = project.melosFile.name();

    final generator = await _generator(iosBundle);

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
