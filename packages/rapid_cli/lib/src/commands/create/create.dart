import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/core/validate_dart_package_name.dart';
import 'package:rapid_cli/src2/project/project.dart';

/// The default description.
const _defaultDescription = 'A Rapid app.';

/// {@template create_command}
/// `rapid create` command creates a new Rapid project in the specified directory.
/// {@endtemplate}
class CreateCommand extends Command<int>
    with OverridableArgResults, OutputDirGetter, OrgNameGetter {
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
          final projectName = _projectName;
          final description = _description;
          final orgName = super.orgName;
          final example = _example;
          final android = _android;
          final ios = _ios;
          final linux = _linux;
          final macos = _macos;
          final web = _web;
          final windows = _windows;

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

          final project = _project(path: outputDir);
          await project.create(
            projectName: projectName,
            description: description,
            orgName: orgName,
            example: example,
            android: android,
            ios: ios,
            linux: linux,
            macos: macos,
            web: web,
            windows: windows,
            logger: _logger,
          );

          _logger
            ..info('\n')
            ..success('Created a Rapid App!')
            ..info('\n');

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
  ///
  /// Defaults to `false` when the user did not specify any platform.
  bool get _android => _any ? (argResults['android'] ?? false) : false;

  /// Whether the user specified that the project supports iOS.
  ///
  /// Defaults to `false` when the user did not specify any platform.
  bool get _ios => _any ? (argResults['ios'] ?? false) : false;

  /// Whether the user specified that the project supports Linux.
  ///
  /// Defaults to `false` when the user did not specify any platform.
  bool get _linux => _any ? (argResults['linux'] ?? false) : false;

  /// Whether the user specified that the project supports macOS.
  ///
  /// Defaults to `false` when the user did not specify any platform.
  bool get _macos => _any ? (argResults['macos'] ?? false) : false;

  /// Whether the user specified that the project supports Web.
  ///
  /// Defaults to `false` when the user did not specify any platform.
  bool get _web => _any ? (argResults['web'] ?? false) : false;

  /// Whether the user specified that the project supports Windows.
  ///
  /// Defaults to `false` when the user did not specify any platform.
  bool get _windows => _any ? (argResults['windows'] ?? false) : false;

  /// Whether the user specified that the project supports any platform.
  bool get _any =>
      (argResults['android'] ?? false) ||
      (argResults['ios'] ?? false) ||
      (argResults['linux'] ?? false) ||
      (argResults['macos'] ?? false) ||
      (argResults['web'] ?? false) ||
      (argResults['windows'] ?? false);

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
