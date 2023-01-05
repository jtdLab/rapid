import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/activate_platform_command.dart';
import 'package:rapid_cli/src/commands/activate/web/web_bundle.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

/// {@template activate_web_command}
/// `rapid activate web` command adds support for Web to an existing Rapid project.
/// {@endtemplate}
class ActivateWebCommand extends ActivatePlatformCommand {
  /// {@macro activate_web_command}
  ActivateWebCommand({
    Logger? logger,
    required Project project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWeb,
    FlutterPubGetCommand? flutterPubGetCommand,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    MelosBootstrapCommand? melosBootstrap,
    MelosCleanCommand? melosClean,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super(
          platform: Platform.web,
          logger: logger ?? Logger(),
          project: project,
          flutterConfigEnablePlatform:
              flutterConfigEnableWeb ?? Flutter.configEnableWeb,
          flutterPubGetCommand: flutterPubGetCommand ?? Flutter.pubGet,
          flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
              flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                  Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
          melosBootstrap: melosBootstrap ?? Melos.bootstrap,
          melosClean: melosClean ?? Melos.clean,
        );

  final GeneratorBuilder _generator;

  @override
  Future<List<GeneratedFile>> generate({
    required Logger logger,
    required Project project,
  }) async {
    final projectName = project.melosFile.name();

    final generator = await _generator(webBundle);
    return generator.generate(
      DirectoryGeneratorTarget(Directory('.')),
      vars: {
        'project_name': projectName,
      },
      logger: logger,
    );
  }
}
