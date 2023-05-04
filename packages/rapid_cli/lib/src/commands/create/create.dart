import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/language_option.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/core/validate_dart_package_name.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/project.dart';

/// The default description.
const _defaultDescription = 'A Rapid app.';

/// {@template create_command}
/// `rapid create` command creates a new Rapid project in the specified directory.
/// {@endtemplate}
class CreateCommand extends RapidCommand
    with OutputDirGetter, OrgNameGetter, LanguageGetter {
  /// {@macro create_command}
  CreateCommand({
    super.logger,
    FlutterInstalledCommand? flutterInstalled,
    MelosInstalledCommand? melosInstalled,
    MelosExecFlutterPubGetCommand? melosExecFlutterPubGet,
    FlutterGenl10nCommand? flutterGenl10n,
    DartFormatFixCommand? dartFormatFix,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableAndroid,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableIos,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableLinux,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableMacos,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWeb,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWindows,
    ProjectBuilder? project,
  })  : _flutterInstalled = flutterInstalled ?? Flutter.installed,
        _melosInstalled = melosInstalled ?? Melos.installed,
        _melosExecFlutterPubGet =
            melosExecFlutterPubGet ?? Melos.execFlutterPubGet,
        _flutterGenl10n = flutterGenl10n ?? Flutter.genl10n,
        _dartFormatFix = dartFormatFix ?? Dart.formatFix,
        _flutterConfigEnableAndroid =
            flutterConfigEnableAndroid ?? Flutter.configEnableAndroid,
        _flutterConfigEnableIos =
            flutterConfigEnableIos ?? Flutter.configEnableIos,
        _flutterConfigEnableLinux =
            flutterConfigEnableLinux ?? Flutter.configEnableLinux,
        _flutterConfigEnableMacos =
            flutterConfigEnableMacos ?? Flutter.configEnableMacos,
        _flutterConfigEnableWeb =
            flutterConfigEnableWeb ?? Flutter.configEnableWeb,
        _flutterConfigEnableWindows =
            flutterConfigEnableWindows ?? Flutter.configEnableWindows,
        _project = project ?? (({String path = '.'}) => Project(path: path)) {
    argParser
      ..addSeparator('')
      ..addOutputDirOption(
        help: 'The directory where to generate the new project',
      )
      ..addOption(
        'desc',
        help: 'The description of the new project.',
        defaultsTo: _defaultDescription,
      )
      ..addOrgNameOption(
        help: 'The organization of the new project.',
      )
      ..addLanguageOption(
        help: 'The language of the new project',
      )
      ..addSeparator('')
      ..addFlag(
        'android',
        help: 'Wheter the new project supports the Android platform.',
        negatable: false,
      )
      ..addFlag(
        'ios',
        help: 'Wheter the new project supports the iOS platform.',
        negatable: false,
      )
      ..addFlag(
        'linux',
        help: 'Wheter the new project supports the Linux platform.',
        negatable: false,
      )
      ..addFlag(
        'macos',
        help: 'Wheter the new project supports the macOS platform.',
        negatable: false,
      )
      ..addFlag(
        'web',
        help: 'Wheter the new project supports the Web platform.',
        negatable: false,
      )
      ..addFlag(
        'windows',
        help: 'Wheter the new project supports the Windows platform.',
        negatable: false,
      )
      ..addFlag(
        'mobile',
        help: 'Wheter the new project supports the Android and iOS platforms.',
        negatable: false,
      )
      ..addFlag(
        'desktop',
        help:
            'Wheter the new project supports the Linux, macOS and Windows platforms.',
        negatable: false,
      )
      ..addFlag(
        'all',
        help: 'Wheter the new project supports all platforms.',
        negatable: false,
      );
  }

  final FlutterInstalledCommand _flutterInstalled;
  final MelosInstalledCommand _melosInstalled;
  final MelosExecFlutterPubGetCommand _melosExecFlutterPubGet;
  final FlutterGenl10nCommand _flutterGenl10n;
  final DartFormatFixCommand _dartFormatFix;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableAndroid;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableIos;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableLinux;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableMacos;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableWeb;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableWindows;
  final ProjectBuilder _project;

  @override
  String get name => 'create';

  @override
  List<String> get aliases => ['c'];

  @override
  String get invocation => 'rapid create <project name> [arguments]';

  @override
  String get description => 'Create a new Rapid project.';

  @override
  Future<int> run() => runWhen(
        [
          flutterIsInstalled(_flutterInstalled, logger: logger),
          melosIsInstalled(_melosInstalled, logger: logger),
        ],
        logger,
        () async {
          final outputDir = super.outputDir;
          final project = _project(path: outputDir);
          if (project.exists() && !project.isEmpty) {
            logger
              ..info('')
              ..err('Output directory must be empty.');

            return ExitCode.config.code;
          }

          final projectName = _projectName;
          final description = _description;
          final orgName = super.orgName;
          final language = super.language;
          final android = _android || _mobile || _all;
          final ios = _ios || _mobile || _all;
          final linux = _linux || _desktop || _all;
          final macos = _macos || _desktop || _all;
          final web = _web || _all;
          final windows = _windows || _desktop || _all;

          logger.info('Creating Rapid App ...');

          final platforms = {
            if (android) Platform.android,
            if (ios) Platform.ios,
            if (linux) Platform.linux,
            if (macos) Platform.macos,
            if (web) Platform.web,
            if (windows) Platform.windows,
          };

          await project.create(
            projectName: projectName,
            description: description,
            orgName: orgName,
            language: language,
            platforms: platforms,
          );

          await _melosExecFlutterPubGet(cwd: project.path, logger: logger);
          for (final platform in platforms) {
            final platformDirectory = project.platformDirectory(
              platform: platform,
            );
            final featuresDirectory = platformDirectory.featuresDirectory;
            final appFeaturePackage = featuresDirectory
                .featurePackage<PlatformAppFeaturePackage>(name: 'app');
            final homePageFeaturePackage =
                featuresDirectory.featurePackage(name: 'home_page');

            await _flutterGenl10n(cwd: appFeaturePackage.path, logger: logger);
            await _flutterGenl10n(
              cwd: homePageFeaturePackage.path,
              logger: logger,
            );
          }
          await _dartFormatFix(cwd: project.path, logger: logger);

          if (android) {
            await _flutterConfigEnableAndroid(logger: logger);
          }
          if (ios) {
            await _flutterConfigEnableIos(logger: logger);
          }
          if (linux) {
            await _flutterConfigEnableLinux(logger: logger);
          }
          if (macos) {
            await _flutterConfigEnableMacos(logger: logger);
          }
          if (web) {
            await _flutterConfigEnableWeb(logger: logger);
          }
          if (windows) {
            await _flutterConfigEnableWindows(logger: logger);
          }

          logger
            ..info('')
            ..success('Created a Rapid App!');

          return ExitCode.success.code;
        },
      );

  /// Gets the project name specified by the user.
  String get _projectName => _validateProjectNameArg(argResults.rest);

  /// Gets the description for the project specified by the user.
  String get _description => argResults['desc'] ?? _defaultDescription;

  /// Whether the user specified that the project supports Android.
  bool get _android => (argResults['android'] ?? false);

  /// Whether the user specified that the project supports iOS.
  bool get _ios => (argResults['ios'] ?? false);

  /// Whether the user specified that the project supports Linux.
  bool get _linux => (argResults['linux'] ?? false);

  /// Whether the user specified that the project supports macOS.
  bool get _macos => (argResults['macos'] ?? false);

  /// Whether the user specified that the project supports Web.
  bool get _web => (argResults['web'] ?? false);

  /// Whether the user specified that the project supports Windows.
  bool get _windows => (argResults['windows'] ?? false);

  /// Whether the user specified that the project supports mobile platforms.
  bool get _mobile => (argResults['mobile'] ?? false);

  /// Whether the user specified that the project supports desktop platforms.
  bool get _desktop => (argResults['desktop'] ?? false);

  /// Whether the user specified that the project supports all platforms.
  bool get _all => (argResults['all'] ?? false);

  /// Validates whether [args] contains ONLY a valid project name.
  ///
  /// Returns the first element when valid.
  String _validateProjectNameArg(List<String> args) {
    if (args.isEmpty) {
      throw UsageException(
        'No option specified for the project name.',
        usage,
      );
    }

    if (args.length > 1) {
      throw UsageException('Multiple project names specified.', usage);
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
