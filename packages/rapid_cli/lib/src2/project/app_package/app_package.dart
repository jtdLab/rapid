import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src2/core/dart_file.dart';
import 'package:rapid_cli/src2/core/generator_builder.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/app_package/platform_native_directory_bundle.dart';
import 'package:rapid_cli/src2/project/project.dart';
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

import 'app_package_bundle.dart';

/// Signature for method that returns the [PlatformNativeDirectory] for [platform].
typedef PlatformNativeDirectoryBuilder = PlatformNativeDirectory Function({
  required Platform platform,
});

/// {@template app_package}
/// Abstraction of the app package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>`
/// {@endtemplate}
class AppPackage extends ProjectPackage {
  /// {@macro app_package}
  AppPackage({
    required Project project,
    PlatformNativeDirectoryBuilder? platformNativeDirectory,
    Set<MainFile>? mainFiles,
    GeneratorBuilder? generator,
  })  : _project = project,
        _generator = generator ?? MasonGenerator.fromBundle,
        path = p.join(
          project.path,
          'packages',
          project.name(),
          project.name(),
        ) {
    _platformNativeDirectory = platformNativeDirectory ??
        (({required platform}) =>
            PlatformNativeDirectory(platform, appPackage: this));
    _mainFiles = mainFiles ??
        {
          MainFile(Environment.development, appPackage: this),
          MainFile(Environment.test, appPackage: this),
          MainFile(Environment.production, appPackage: this),
        };
  }

  final Project _project;
  late final PlatformNativeDirectoryBuilder _platformNativeDirectory;
  late final Set<MainFile> _mainFiles;
  final GeneratorBuilder _generator;

  @override
  final String path;

  Future<void> create({
    required String description,
    required String orgName,
    required bool android,
    required bool ios,
    required bool linux,
    required bool macos,
    required bool web,
    required bool windows,
    required Logger logger,
  }) async {
    final projectName = _project.name();

    final generator = await _generator(appPackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'description': description,
        'android': android,
        'ios': ios,
        'linux': linux,
        'macos': macos,
        'web': web,
        'windows': windows,
        'none': !(android || ios || linux || macos || web || windows),
      },
      logger: logger,
    );

    final platforms = [
      if (android) Platform.android,
      if (ios) Platform.ios,
      if (linux) Platform.linux,
      if (macos) Platform.macos,
      if (web) Platform.web,
      if (windows) Platform.windows,
    ];

    for (final platform in platforms) {
      final platformNativeDirectory =
          _platformNativeDirectory(platform: platform);
      platformNativeDirectory.create(
        description: description,
        orgName: orgName,
        logger: logger,
      );
    }
  }

  Future<void> addPlatform(
    Platform platform, {
    String? description,
    String? orgName,
    required Logger logger,
  }) async {
    final platformNativeDirectory = _platformNativeDirectory(
      platform: platform,
    );
    await platformNativeDirectory.create(
      description: description,
      orgName: orgName,
      logger: logger,
    );

    final mainFiles = _mainFiles;
    for (final mainFile in mainFiles) {
      mainFile.addSetupForPlatform(platform);
    }
  }

  Future<void> removePlatform(
    Platform platform, {
    required Logger logger,
  }) async {
    final platformNativeDirectory = _platformNativeDirectory(
      platform: platform,
    );
    await platformNativeDirectory.delete(logger: logger);

    final mainFiles = _mainFiles;
    for (final mainFile in mainFiles) {
      mainFile.removeSetupForPlatform(platform);
    }
  }
}

/// {@template platform_native_directory}
/// Abstraction of a platform native directory of the app package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>/<platform>`
/// {@endtemplate}
class PlatformNativeDirectory extends ProjectDirectory {
  /// {@macro platform_native_directory}
  PlatformNativeDirectory(
    this.platform, {
    required AppPackage appPackage,
    GeneratorBuilder? generator,
  })  : _appPackage = appPackage,
        _generator = generator ?? MasonGenerator.fromBundle,
        path = p.join(appPackage.path, platform.name);

  final AppPackage _appPackage;
  final GeneratorBuilder _generator;

  final Platform platform;

  @override
  final String path;

  Future<void> create({
    String? description,
    String? orgName,
    required Logger logger,
  }) async {
    final projectName = _appPackage._project.name();

    final generator = await _generator(platformNativeDirectoryBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        if (description != null) 'description': description,
        if (orgName != null) 'org_name': orgName,
        'android': platform == Platform.android,
        'ios': platform == Platform.ios,
        'linux': platform == Platform.linux,
        'macos': platform == Platform.macos,
        'web': platform == Platform.web,
        'windows': platform == Platform.windows,
      },
      logger: logger,
    );
  }
}

/// The environments a Rapid project might run in.
enum Environment { development, test, production }

/// {@template main_file}
/// Abstraction of a main file in the app package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>/lib/main_<env>.dart`
/// {@endtemplate}
class MainFile extends ProjectEntity {
  /// {@macro main_file}
  MainFile(
    this.env, {
    required AppPackage appPackage,
  })  : _appPackage = appPackage,
        _dartFile = DartFile(
          path: p.join(appPackage.path, 'lib'),
          name: 'main_${env.name}',
        ) {
    path = _dartFile.path;
  }

  final AppPackage _appPackage;
  final DartFile _dartFile;

  @override
  late final String path;

  final Environment env;

  @override
  bool exists() => _dartFile.exists();

  void addSetupForPlatform(Platform platform) {
    final projectName = _appPackage._project.name();
    final platformName = platform.name;
    final envName = env == Environment.development
        ? 'dev'
        : env == Environment.test
            ? 'test'
            : 'prod';

    final imports = _dartFile.readImports();
    if (imports.length == 1 && imports.first == 'package:rapid/rapid.dart') {
      _dartFile.addImport('package:flutter/widgets.dart');
      _dartFile.addImport('package:${projectName}_di/${projectName}_di.dart');
      _dartFile.addImport(
          'package:${projectName}_logging/${projectName}_logging.dart');
      _dartFile.addImport('bootstrap.dart');
      _dartFile.addImport('router_observer.dart');
    }

    _dartFile.addImport(
      'package:${projectName}_${platformName}_app/${projectName}_${platformName}_app.dart',
      alias: platformName,
    );

    if (platform == Platform.web) {
      _dartFile.addImport('package:url_strategy/url_strategy.dart');
    }

    final functionName = 'run${platformName.pascalCase}App';
    _dartFile.addTopLevelFunction(
      Method(
        (m) => m
          ..returns = refer('Future<void>')
          ..name = functionName
          ..modifier = MethodModifier.async
          ..body = Code([
            'configureDependencies(Environment.$envName, Platform.$platformName);',
            if (platform == Platform.web) 'setPathUrlStrategy();',
            'WidgetsFlutterBinding.ensureInitialized();',
            '  // TODO: add more $platformName ${env.name} setup here',
            '',
            'final logger = getIt<${projectName.pascalCase}Logger>();',
            'final app = $platformName.App(',
            '  routerObserverBuilder: () => [',
            '    ${projectName.pascalCase}RouterObserver(logger),',
            '  ],',
            ');',
            'await bootstrap(app, logger);',
          ].join('\n')),
      ),
    );

    _dartFile.addNamedParamToMethodCallInTopLevelFunctionBody(
      paramName: platformName,
      paramValue: functionName,
      functionName: 'main',
      functionToCallName: 'runOnPlatform',
    );
  }

  void removeSetupForPlatform(Platform platform) {
    final projectName = _appPackage._project.name();
    final platformName = platform.name;

    _dartFile.removeImport(
      'package:${projectName}_${platformName}_app/${projectName}_${platformName}_app.dart',
    );

    if (platform == Platform.web) {
      _dartFile.removeImport('package:url_strategy/url_strategy.dart');
    }

    _dartFile.removeTopLevelFunction('run${platformName.pascalCase}App');

    _dartFile.removeNamedParamFromMethodCallInTopLevelFunctionBody(
      paramName: platformName,
      functionName: 'main',
      functionToCallName: 'runOnPlatform',
    );

    final functions = _dartFile.readTopLevelFunctionNames();
    if (functions.length == 1 && functions.first == 'main') {
      _dartFile.removeImport('package:flutter/widgets.dart');
      _dartFile
          .removeImport('package:${projectName}_di/${projectName}_di.dart');
      _dartFile.removeImport(
          'package:${projectName}_logging/${projectName}_logging.dart');
      _dartFile.removeImport('bootstrap.dart');
      _dartFile.removeImport('router_observer.dart');
    }

    // TODO improvment remove unesessary imports if possible
  }
}
