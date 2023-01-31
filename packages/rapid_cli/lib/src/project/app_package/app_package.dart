import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package/platform_native_directory/platform_native_directory.dart';
import 'package:rapid_cli/src/project/project.dart';
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
    required this.project,
    PlatformNativeDirectoryBuilder? platformNativeDirectory,
    Set<MainFile>? mainFiles,
    GeneratorBuilder? generator,
  }) : _generator = generator ?? MasonGenerator.fromBundle {
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

  final Project project;
  late final PlatformNativeDirectoryBuilder _platformNativeDirectory;
  late final Set<MainFile> _mainFiles;
  final GeneratorBuilder _generator;

  @override
  String get path => p.join(
        project.path,
        'packages',
        project.name(),
        project.name(),
      );

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
    final projectName = project.name();

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
    final platformDirectory = project.platformDirectory(platform: platform);
    final appFeaturePackage = platformDirectory.appFeaturePackage;
    pubspecFile.setDependency(appFeaturePackage.packageName());

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
    // TODO maybe make get feature/s for platform getter
    // in project can be used for doctor command
    final platformDirectory = project.platformDirectory(platform: platform);
    final appFeaturePackage = platformDirectory.appFeaturePackage;
    pubspecFile.removeDependency(appFeaturePackage.packageName());

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
  }) : _appPackage = appPackage;

  final AppPackage _appPackage;

  DartFile get _dartFile => DartFile(
        path: p.join(_appPackage.path, 'lib'),
        name: 'main_${env.name}',
      );

  @override
  String get path => _dartFile.path;

  final Environment env;

  @override
  bool exists() => _dartFile.exists();

  void addSetupForPlatform(Platform platform) {
    final projectName = _appPackage.project.name();
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
    final projectName = _appPackage.project.name();
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
