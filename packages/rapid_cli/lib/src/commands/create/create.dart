import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/create/app_bundle.dart';
import 'package:universal_io/io.dart';

/// The default description.
const _defaultDescription = 'A Rapid app.';

/// The default value for enabling example features.
const _defaultExample = false;

// The regex for a dart package name, i.e. no capital letters.
// https://dart.dev/guides/language/language-tour#important-concepts
final _packageRegExp = RegExp('[a-z_][a-z0-9_]*');

/// {@template create_command}
/// `rapid create` command creates a new Rapid project in the specified directory.
/// {@endtemplate}
class CreateCommand extends Command<int>
    with OverridableArgResults, OrgNameGetters {
  /// {@macro create_command}
  CreateCommand({
    Logger? logger,
    FlutterInstalledCommand? flutterInstalled,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableAndroid,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableIos,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableLinux,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableMacos,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWeb,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWindows,
    GeneratorBuilder? generator,
    MelosBootstrapCommand? melosBootstrap,
  })  : _logger = logger ?? Logger(),
        _flutterInstalled = flutterInstalled ?? Flutter.installed,
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
        _generator = generator ?? MasonGenerator.fromBundle,
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap {
    argParser
      ..addSeparator('')
      ..addOption(
        'project-name',
        help: 'The name of this new project. '
            'This must be a valid dart package name.',
      )
      ..addOption(
        'desc',
        help: 'The description of this new project.',
        defaultsTo: _defaultDescription,
      )
      ..addOrgNameOption(
        help: 'The organization of this new project.',
      )
      ..addFlag(
        'example',
        help:
            'Wheter this new project contains example features and their tests.',
        negatable: false,
        defaultsTo: _defaultExample,
      )
      ..addSeparator('')
      ..addFlag(
        'android',
        help: 'Wheter this new project supports the Android platform.',
        negatable: false,
      )
      ..addFlag(
        'ios',
        help: 'Wheter this new project supports the iOS platform.',
        negatable: false,
      )
      ..addFlag(
        'linux',
        help: 'Wheter this new project supports the Linux platform.',
        negatable: false,
      )
      ..addFlag(
        'macos',
        help: 'Wheter this new project supports the macOS platform.',
        negatable: false,
      )
      ..addFlag(
        'web',
        help: 'Wheter this new project supports the Web platform.',
        negatable: false,
      )
      ..addFlag(
        'windows',
        help: 'Wheter this new project supports the Windows platform.',
        negatable: false,
      );
  }

  final Logger _logger;
  final FlutterInstalledCommand _flutterInstalled;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableAndroid;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableIos;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableLinux;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableMacos;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableWeb;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableWindows;
  final GeneratorBuilder _generator;
  final MelosBootstrapCommand _melosBootstrap;

  @override
  String get name => 'create';

  @override
  String get description =>
      'Creates a new Rapid project in the specified directory.';

  @override
  String get invocation => 'rapid create <output directory>';

  @override
  List<String> get aliases => ['c'];

  @override
  Future<int> run() async {
    final isFlutterInstalled = await _flutterInstalled();
    if (!isFlutterInstalled) {
      _logger.err('Flutter not installed.');

      return ExitCode.unavailable.code;
    }

    final android = _android;
    final ios = _ios;
    final linux = _linux;
    final macos = _macos;
    final web = _web;
    final windows = _windows;

    if (android) {
      final enableAndroidProgress = _logger.progress(
        'Running "flutter config --enable-android"',
      );
      await _flutterConfigEnableAndroid();
      enableAndroidProgress.complete();
    }
    if (ios) {
      final enableIosProgress = _logger.progress(
        'Running "flutter config --enable-ios"',
      );
      await _flutterConfigEnableIos();
      enableIosProgress.complete();
    }
    if (linux) {
      final enableLinuxProgress = _logger.progress(
        'Running "flutter config --enable-linux-desktop"',
      );
      await _flutterConfigEnableLinux();
      enableLinuxProgress.complete();
    }
    if (macos) {
      final enableMacosProgress = _logger.progress(
        'Running "flutter config --enable-macos-desktop"',
      );
      await _flutterConfigEnableMacos();
      enableMacosProgress.complete();
    }
    if (web) {
      final enableWebProgress = _logger.progress(
        'Running "flutter config --enable-web"',
      );
      await _flutterConfigEnableWeb();
      enableWebProgress.complete();
    }
    if (windows) {
      final enableWindowsProgress = _logger.progress(
        'Running "flutter config --enable-windows-desktop"',
      );
      await _flutterConfigEnableWindows();
      enableWindowsProgress.complete();
    }

    final outputDirectory = _outputDirectory;
    final projectName = _projectName;
    final description = _description;
    final orgName = super.orgName;
    final example = _example;

    final generateProgress = _logger.progress('Bootstrapping');
    final generator = await _generator(appBundle);
    final files = await generator.generate(
      DirectoryGeneratorTarget(outputDirectory),
      vars: <String, dynamic>{
        'project_name': projectName,
        'description': description,
        'org_name': orgName,
        'example': example,
        'android': android,
        'ios': ios,
        'linux': linux,
        'macos': macos,
        'web': web,
        'windows': windows,
      },
      logger: _logger,
    );
    generateProgress.complete('Generated ${files.length} file(s)');

    final melosBootstrapProgress = _logger.progress(
      'Running "melos bootstrap" in ${outputDirectory.path} ',
    );
    await _melosBootstrap(cwd: outputDirectory.path);
    melosBootstrapProgress.complete();

    _logger
      ..info('\n')
      ..alert('Created a Rapid App!')
      ..info('\n');

    return ExitCode.success.code;
  }

  /// Whether the user specified that the project supports Android.
  ///
  /// Defaults to `false` when the user did not specify any platform.
  bool get _android => _any ? argResults['android'] : false;

  /// Whether the user specified that the project supports iOS.
  ///
  /// Defaults to `false` when the user did not specify any platform.
  bool get _ios => _any ? argResults['ios'] : false;

  /// Whether the user specified that the project supports Linux.
  ///
  /// Defaults to `false` when the user did not specify any platform.
  bool get _linux => _any ? argResults['linux'] : false;

  /// Whether the user specified that the project supports macOS.
  ///
  /// Defaults to `false` when the user did not specify any platform.
  bool get _macos => _any ? argResults['macos'] : false;

  /// Whether the user specified that the project supports Web.
  ///
  /// Defaults to `false` when the user did not specify any platform.
  bool get _web => _any ? argResults['web'] : false;

  /// Whether the user specified that the project supports Windows.
  ///
  /// Defaults to `false` when the user did not specify any platform.
  bool get _windows => _any ? argResults['windows'] : false;

  /// Gets the directory where the project will be generated in specified by the user.
  Directory get _outputDirectory =>
      _validateOutputDirectoryArg(argResults.rest);

  /// Gets the project name specified by the user.
  ///
  /// Uses the current directory path name
  /// if the `--project-name` option is not explicitly specified.
  String get _projectName => _validateProjectName(argResults['project-name'] ??
      p.basename(p.normalize(_outputDirectory.absolute.path)));

  /// Gets the description for the project specified by the user.
  String get _description => argResults['desc'] ?? _defaultDescription;

  /// Whether the user specified that the project will contain example features.
  bool get _example => argResults['example'] ?? _defaultExample;

  /// Whether the user specified that the project supports any platform.
  bool get _any =>
      (argResults['android'] ?? false) ||
      (argResults['ios'] ?? false) ||
      (argResults['linux'] ?? false) ||
      (argResults['macos'] ?? false) ||
      (argResults['web'] ?? false) ||
      (argResults['windows'] ?? false);

  /// Validates wheter [args] contains exactly one path to a directory.
  ///
  /// Returns the directory.
  Directory _validateOutputDirectoryArg(List<String> args) {
    if (args.isEmpty) {
      throw UsageException(
        'No option specified for the output directory.',
        usage,
      );
    }

    if (args.length > 1) {
      throw UsageException('Multiple output directories specified.', usage);
    }

    return Directory(args.first);
  }

  /// Validates whether [name] is valid project name.
  ///
  /// Returns [name] when valid.
  String _validateProjectName(String name) {
    final isValid = _isValidPackageName(name);
    if (!isValid) {
      throw UsageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
        usage,
      );
    }
    return name;
  }

  /// Whether [name] is valid project name.
  bool _isValidPackageName(String name) {
    final match = _packageRegExp.matchAsPrefix(name);
    return match != null && match.end == name.length;
  }
}
