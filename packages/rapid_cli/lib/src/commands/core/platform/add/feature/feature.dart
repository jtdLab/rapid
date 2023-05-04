import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/add/feature/feature.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/dart_package_name_rest.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ios/add/feature/feature.dart';
import 'package:rapid_cli/src/commands/linux/add/feature/feature.dart';
import 'package:rapid_cli/src/commands/macos/add/feature/feature.dart';
import 'package:rapid_cli/src/commands/web/add/feature/feature.dart';
import 'package:rapid_cli/src/commands/windows/add/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';

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
abstract class PlatformAddFeatureCommand extends RapidRootCommand
    with DartPackageNameGetter, GroupableMixin, BootstrapMixin, CodeGenMixin {
  /// {@macro platform_add_feature_command}
  PlatformAddFeatureCommand({
    required Platform platform,
    super.logger,
    super.project,
    MelosBootstrapCommand? melosBootstrap,
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    FlutterGenl10nCommand? flutterGenl10n,
    DartFormatFixCommand? dartFormatFix,
  })  : _platform = platform,
        melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _flutterGenl10n = flutterGenl10n ?? Flutter.genl10n,
        _dartFormatFix = dartFormatFix ?? Dart.formatFix {
    argParser
      ..addSeparator('')
      ..addOption(
        'desc',
        help:
            'The description of this new feature.', // TODO rename to the might be the case in other descriptions too
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
  @override
  final MelosBootstrapCommand melosBootstrap;
  @override
  final FlutterPubGetCommand flutterPubGet;
  @override
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final FlutterGenl10nCommand _flutterGenl10n;
  final DartFormatFixCommand _dartFormatFix;

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
          projectExistsAll(project),
          platformIsActivated(
            _platform,
            project,
            '${_platform.prettyName} is not activated.',
          ),
        ],
        logger,
        () async {
          final name = super.dartPackageName;
          final description = _description;
          final routing = _routing;

          logger.info('Adding Feature ...');

          final platformDirectory =
              project.platformDirectory(platform: _platform);
          final featuresDirectory = platformDirectory.featuresDirectory;
          final featurePackage = featuresDirectory.featurePackage(name: name);
          if (!featurePackage.exists()) {
            final rootPackage = platformDirectory.rootPackage;
            await featurePackage.create(
              description: description,
              routing: routing,
              // TODO default lang from featurs or from roots supported langs
              defaultLanguage: rootPackage.defaultLanguage(),
              languages: rootPackage.supportedLanguages(),
            );

            // TODO if routing add router to root router list
            await rootPackage.registerFeaturePackage(featurePackage);

            await bootstrap(
              packages: [rootPackage, featurePackage],
              logger: logger,
            );
            await codeGen(
              packages: [rootPackage],
              logger: logger,
            );

            await _flutterGenl10n(cwd: featurePackage.path, logger: logger);

            await _dartFormatFix(cwd: project.path, logger: logger);

            // TODO add link doc to navigation and routing approach
            logger
              ..info('')
              ..success('Added ${_platform.prettyName} feature $name.');

            return ExitCode.success.code;
          } else {
            // TODO test
            logger
              ..info('')
              ..err(
                'The feature "$name" does already on ${_platform.prettyName}.',
              );

            return ExitCode.config.code;
          }
        },
      );

  /// Gets the description for the project specified by the user.
  String get _description => argResults['desc'] ?? _defaultDescription;

  /// Whether the user specified that the feature can be registered in the routing package.
  bool get _routing => argResults['routing'] ?? false;
}
