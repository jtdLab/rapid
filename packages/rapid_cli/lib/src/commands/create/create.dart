import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/language_option.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/core/validate_dart_package_name.dart';
import 'package:rapid_cli/src/project/project.dart';

/// The default description.
const _defaultDescription = 'A Rapid app.';

/// {@template create_command}
/// `rapid create` command creates a new Rapid project in the specified directory.
/// {@endtemplate}
class CreateCommand extends Command<int>
    with OverridableArgResults, OutputDirGetter, OrgNameGetter, LanguageGetter {
  /// {@macro create_command}
  CreateCommand({
    Logger? logger,
    FlutterInstalledCommand? flutterInstalled,
    MelosInstalledCommand? melosInstalled,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableAndroid,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableIos,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableLinux,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableMacos,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWeb,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWindows,
    ProjectBuilder? project,
  })  : _logger = logger ?? Logger(),
        _flutterInstalled = flutterInstalled ?? Flutter.installed,
        _melosInstalled = melosInstalled ?? Melos.installed,
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
      ..addFlag(
        'example',
        help:
            'Wheter the new project contains example features and their tests.',
        negatable: false,
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

  final Logger _logger;
  final FlutterInstalledCommand _flutterInstalled;
  final MelosInstalledCommand _melosInstalled;
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
          flutterIsInstalled(_flutterInstalled, logger: _logger),
          melosIsInstalled(_melosInstalled, logger: _logger),
        ],
        _logger,
        () async {
          final outputDir = super.outputDir;
          final project = _project(path: outputDir);
          if (!project.isEmpty) {
            _logger
              ..info('')
              ..err('Output directory must be empty.');

            return ExitCode.config.code;
          }
          final projectName = _projectName;
          final description = _description;
          final orgName = super.orgName;
          final language = super.language;
          final example = _example;
          final android = _android || _mobile || _all;
          final ios = _ios || _mobile || _all;
          final linux = _linux || _desktop || _all;
          final macos = _macos || _desktop || _all;
          final web = _web || _all;
          final windows = _windows || _desktop || _all;

          _logger.info('Creating Rapid project ...');

          await project.create(
            projectName: projectName,
            description: description,
            orgName: orgName,
            language: language,
            example: example,
            android: android,
            ios: ios,
            linux: linux,
            macos: macos,
            web: web,
            windows: windows,
            logger: _logger,
          );

          if (android) {
            await _flutterConfigEnableAndroid(logger: _logger);
          }
          if (ios) {
            await _flutterConfigEnableIos(logger: _logger);
          }
          if (linux) {
            await _flutterConfigEnableLinux(logger: _logger);
          }
          if (macos) {
            await _flutterConfigEnableMacos(logger: _logger);
          }
          if (web) {
            await _flutterConfigEnableWeb(logger: _logger);
          }
          if (windows) {
            await _flutterConfigEnableWindows(logger: _logger);
          }

          _logger
            ..info('')
            ..success('Created a Rapid App!');

          return ExitCode.success.code;
        },
      );

  /// Gets the project name specified by the user.
  String get _projectName => _validateProjectNameArg(argResults.rest);

  /// Gets the description for the project specified by the user.
  String get _description => argResults['desc'] ?? _defaultDescription;

  /// Whether the user specified that the project will contain example features.
  bool get _example => argResults['example'] ?? false;

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
