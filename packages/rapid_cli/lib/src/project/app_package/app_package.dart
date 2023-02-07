import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/environment.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package/platform_native_directory/platform_native_directory.dart';
import 'package:rapid_cli/src/project/project.dart';

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
class AppPackage extends DartPackage {
  /// {@macro app_package}
  AppPackage({
    required this.project,
    super.pubspecFile,
    PlatformNativeDirectoryBuilder? platformNativeDirectory,
    Set<MainFile>? mainFiles,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            project.name(),
          ),
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

  late final PlatformNativeDirectoryBuilder _platformNativeDirectory;
  late final Set<MainFile> _mainFiles;
  final GeneratorBuilder _generator;

  final Project project;

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
    final platformDirectory = project.platformDirectory(platform: platform);
    final appFeaturePackage = platformDirectory.appFeaturePackage;
    pubspecFile.removeDependency(appFeaturePackage.packageName());

    final platformNativeDirectory = _platformNativeDirectory(
      platform: platform,
    );
    platformNativeDirectory.delete(logger: logger);

    final mainFiles = _mainFiles;
    for (final mainFile in mainFiles) {
      mainFile.removeSetupForPlatform(platform);
    }
  }
}

/// {@template main_file}
/// Abstraction of a main file in the app package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>/lib/main_<env>.dart`
/// {@endtemplate}
class MainFile extends DartFile {
  /// {@macro main_file}
  MainFile(
    this.environment, {
    required AppPackage appPackage,
  })  : _appPackage = appPackage,
        super(
          path: p.join(appPackage.path, 'lib'),
          name: 'main_${environment.name}',
        );

  final AppPackage _appPackage;

  final Environment environment;

  void addSetupForPlatform(Platform platform) {
    final projectName = _appPackage.project.name();
    final platformName = platform.name;
    final envName = environment.shortName;

    final imports = readImports();
    if (imports.length == 1 && imports.first == 'package:rapid/rapid.dart') {
      addImport('package:flutter/widgets.dart');
      addImport('package:${projectName}_di/${projectName}_di.dart');
      addImport('package:${projectName}_logging/${projectName}_logging.dart');
      addImport('bootstrap.dart');
      addImport('router_observer.dart');
    }

    addImport(
      'package:${projectName}_${platformName}_app/${projectName}_${platformName}_app.dart',
      alias: platformName,
    );

    if (platform == Platform.web) {
      addImport('package:url_strategy/url_strategy.dart');
    }

    final functionName = 'run${platformName.pascalCase}App';
    addTopLevelFunction(
      Method(
        (m) => m
          ..returns = refer('Future<void>')
          ..name = functionName
          ..modifier = MethodModifier.async
          ..body = Code([
            'configureDependencies(Environment.$envName, Platform.$platformName);',
            if (platform == Platform.web) 'setPathUrlStrategy();',
            'WidgetsFlutterBinding.ensureInitialized();',
            '  // TODO: add more $platformName ${environment.name} setup here',
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

    addNamedParamToMethodCallInTopLevelFunctionBody(
      paramName: platformName,
      paramValue: functionName,
      functionName: 'main',
      functionToCallName: 'runOnPlatform',
    );
  }

  void removeSetupForPlatform(Platform platform) {
    final projectName = _appPackage.project.name();
    final platformName = platform.name;

    removeImport(
      'package:${projectName}_${platformName}_app/${projectName}_${platformName}_app.dart',
    );

    if (platform == Platform.web) {
      removeImport('package:url_strategy/url_strategy.dart');
    }

    removeTopLevelFunction('run${platformName.pascalCase}App');

    removeNamedParamFromMethodCallInTopLevelFunctionBody(
      paramName: platformName,
      functionName: 'main',
      functionToCallName: 'runOnPlatform',
    );

    final functions = readTopLevelFunctionNames();
    if (functions.length == 1 && functions.first == 'main') {
      removeImport('package:flutter/widgets.dart');
      removeImport('package:${projectName}_di/${projectName}_di.dart');
      removeImport(
          'package:${projectName}_logging/${projectName}_logging.dart');
      removeImport('bootstrap.dart');
      removeImport('router_observer.dart');
    }

    // TODO improvment remove unesessary imports if possible
  }
}

extension EnvironmentX on Environment {
  String get shortName {
    switch (this) {
      case Environment.development:
        return 'dev';
      case Environment.test:
        return 'test';
      case Environment.production:
        return 'prod';
    }
  }
}
