import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

import 'project.dart';

/// The environments a Rapid project might run in.
enum Environment { development, test, production }

/// {@template app_package}
/// Abstraction of the app package of a Rapid project.
/// {@endtemplate}
class AppPackage {
  /// {@macro app_package}
  AppPackage({required this.project})
      : _package = DartPackage(
          path: p.join(
              'packages', project.melosFile.name(), project.melosFile.name()),
        );

  final DartPackage _package;

  final Project project;

  /// The main files.
  ///
  /// These are the entry points for a Rapid application.
  /// Every environment has one related main file that provides
  /// the possibility to run the app in correspond environment.
  late final Set<MainFile> mainFiles = {
    MainFile(Environment.development, appPackage: this),
    MainFile(Environment.test, appPackage: this),
    MainFile(Environment.production, appPackage: this),
  };

  String get path => _package.path;

  late final PubspecFile pubspecFile = PubspecFile(path: path);

  /// The directory containing native setup for [platform].
  Directory platformDirectory(Platform platform) => Directory(
        p.join(path, platform.name),
      );

  /// The directory containing driver setup needed for web integration tests.
  Directory testDriverDirectory() => Directory(p.join(path, 'test_driver'));
}

/// {@template main_file}
/// Abstraction of a main file in the app package of a Rapid project.
/// {@endtemplate}
class MainFile {
  /// {@macro main_file}
  MainFile(
    this.env, {
    required AppPackage appPackage,
  })  : _appPackage = appPackage,
        _file = DartFile(
            path: p.join(appPackage.path, 'lib'), name: 'main_${env.name}');

  final AppPackage _appPackage;

  final DartFile _file;

  final Environment env;

  String get path => _file.path;

  void addSetupForPlatform(Platform platform) {
    final projectName = _appPackage.project.melosFile.name();
    final platformName = platform.name;
    final envName = env == Environment.development
        ? 'dev'
        : env == Environment.test
            ? 'test'
            : 'prod';

    final imports = _file.readImports();
    if (imports.length == 1 && imports.first == 'package:rapid/rapid.dart') {
      _file.addImport('package:flutter/widgets.dart');
      _file.addImport('package:${projectName}_di/${projectName}_di.dart');
      _file.addImport(
          'package:${projectName}_logging/${projectName}_logging.dart');
      _file.addImport('bootstrap.dart');
      _file.addImport('router_observer.dart');
    }

    _file.addImport(
      'package:${projectName}_${platformName}_app/${projectName}_${platformName}_app.dart',
      alias: platformName,
    );

    if (platform == Platform.web) {
      _file.addImport('package:url_strategy/url_strategy.dart');
    }

    final functionName = 'run${platformName.pascalCase}App';
    _file.addTopLevelFunction(
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

    _file.addNamedParamToMethodCallInTopLevelFunctionBody(
      paramName: platformName,
      paramValue: functionName,
      functionName: 'main',
      functionToCallName: 'runOnPlatform',
    );
  }

  void removeSetupForPlatform(Platform platform) {
    final projectName = _appPackage.project.melosFile.name();
    final platformName = platform.name;

    _file.removeImport(
      'package:${projectName}_${platformName}_app/${projectName}_${platformName}_app.dart',
    );

    if (platform == Platform.web) {
      _file.removeImport('package:url_strategy/url_strategy.dart');
    }

    _file.removeTopLevelFunction('run${platformName.pascalCase}App');

    _file.removeNamedParamFromMethodCallInTopLevelFunctionBody(
      paramName: platformName,
      functionName: 'main',
      functionToCallName: 'runOnPlatform',
    );

    final functions = _file.readTopLevelFunctionNames();
    if (functions.length == 1 && functions.first == 'main') {
      _file.removeImport('package:flutter/widgets.dart');
      _file.removeImport('package:${projectName}_di/${projectName}_di.dart');
      _file.removeImport(
          'package:${projectName}_logging/${projectName}_logging.dart');
      _file.removeImport('bootstrap.dart');
      _file.removeImport('router_observer.dart');
    }

    // TODO improvment remove unesessary imports if possible
  }
}
