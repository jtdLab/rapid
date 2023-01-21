import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/add/feature/feature.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/platform/add/feature/feature_bundle.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/core/validate_dart_package_name.dart';
import 'package:rapid_cli/src/commands/ios/add/feature/feature.dart';
import 'package:rapid_cli/src/commands/linux/add/feature/feature.dart';
import 'package:rapid_cli/src/commands/macos/add/feature/feature.dart';
import 'package:rapid_cli/src/commands/web/add/feature/feature.dart';
import 'package:rapid_cli/src/commands/windows/add/feature/feature.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/project.dart';
import 'package:universal_io/io.dart';

/// The default description.
const _defaultDescription = 'A Rapid feature.';

/// {@template platform_add_feature_command}
/// Base class for:
///
///  * [AndroidAddFeatureCommand]
///
///  * [IosAddFeatureCommand]
///
///  * [LinuxAddFeatureCommand]
///
///  * [MacosAddFeatureCommand]
///
///  * [WebAddFeatureCommand]
///
///  * [WindowsAddFeatureCommand]
/// {@endtemplate}
abstract class PlatformAddFeatureCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro platform_add_feature_command}
  PlatformAddFeatureCommand({
    required Platform platform,
    Logger? logger,
    required Project project,
    MelosBootstrapCommand? melosBootstrap,
    MelosCleanCommand? melosClean,
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    FlutterFormatFixCommand? flutterFormatFix,
    GeneratorBuilder? generator,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project,
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _melosClean = melosClean ?? Melos.clean,
        _flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _flutterFormatFix = flutterFormatFix ?? Flutter.formatFix,
        _generator = generator ?? MasonGenerator.fromBundle {
    argParser
      ..addSeparator('')
      ..addOption(
        'desc',
        help:
            'The description of this new feature.', // TODO rename to the might be the cas in other descriptions too
        defaultsTo: _defaultDescription,
      )
      // TODO maybe add a option to specify features that want a dependency before melos bs runs
      ..addFlag(
        'routing',
        help:
            'Wheter the new feature can be registered in the routing package.',
        negatable: false,
      );
  }

  final Platform _platform;
  final Logger _logger;
  final Project _project;
  final MelosBootstrapCommand _melosBootstrap;
  final MelosCleanCommand _melosClean;
  final FlutterPubGetCommand _flutterPubGet;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final FlutterFormatFixCommand _flutterFormatFix;

  final GeneratorBuilder _generator;

  @override
  String get name => 'feature';

  @override
  List<String> get aliases => ['feat'];

  @override
  String get invocation =>
      'rapid ${_platform.name} add feature <name> [arguments]';

  @override
  String get description =>
      'Add a feature to the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [
          isProjectRoot(_project),
          platformIsActivated(_platform, _project),
        ],
        _logger,
        () async {
          // TODO add a application layer to the feature template

          final platformDir = _project.platformDirectory(_platform);

          final exists = platformDir.featureExists(name);
          if (!exists) {
            final projectName = _project.melosFile.name();
            final name = _name;
            final description = _description;
            final routing = _routing;

            final generateProgress = _logger.progress('Generating files');
            final generator = await _generator(featureBundle);
            final files = await generator.generate(
              DirectoryGeneratorTarget(Directory('.')),
              vars: <String, dynamic>{
                'project_name': projectName,
                'name': name,
                'description': description,
                'platform': _platform.name,
                _platform.name: true
              },
              logger: _logger,
            );
            generateProgress.complete('Generated ${files.length} file(s)');

            final featurePackageName = '${projectName}_${_platform.name}_$name';

            // TODO add localizations to app package

            if (routing) {
              final routingFeature = platformDir.findFeature('routing');

              routingFeature.pubspecFile.setDependency(featurePackageName);
            }

            final diPackage = _project.diPackage;
            diPackage.pubspecFile.setDependency(featurePackageName);
            final injectionFile = diPackage.injectionFile;
            injectionFile.addPackage(featurePackageName);

            await _melosClean(logger: _logger);

            await _melosBootstrap(logger: _logger);

            await _flutterPubGet(cwd: diPackage.path, logger: _logger);
            await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
              cwd: diPackage.path,
              logger: _logger,
            );

            await _flutterFormatFix(logger: _logger);

            _logger.success(
              'Added ${_platform.prettyName} feature $name.',
            );

            // TODO maybe add hint how to register a page in the routing feature

            return ExitCode.success.code;
          } else {
            // TODO test
            _logger.err(
              'The feature "$name" does not exist on ${_platform.prettyName}.',
            );

            return ExitCode.config.code;
          }
        },
      );

  String get _name => _validateNameArg(argResults.rest);

  /// Gets the description for the project specified by the user.
  String get _description => argResults['desc'] ?? _defaultDescription;

  /// Whether the user specified that the feature can be registered in the routing package.
  bool get _routing => argResults['routing'] ?? false;

  /// Validates whether [name] is valid feature name.
  ///
  /// Returns [name] when valid.
  String _validateNameArg(List<String> args) {
    if (args.isEmpty) {
      throw UsageException(
        'No option specified for the name.',
        usage,
      );
    }

    if (args.length > 1) {
      throw UsageException('Multiple names specified.', usage);
    }

    final name = args.first;
    final isValid = isValidPackageName(name);
    if (!isValid) {
      throw UsageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
        usage,
      );
    }

    return name;
  }
}
