import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:recase/recase.dart';

import 'project.dart';

/// The environments a Rapid project might run in.
enum Environment { development, test, production }

/// {@template app_package}
/// Abstraction of the app package of a Rapid project.
/// {@endtemplate}
class AppPackage {
  /// {@macro app_package}
  AppPackage({required Project project})
      : _project = project,
        _package = DartPackage(
          path: p.join(
              'packages', project.melosFile.name(), project.melosFile.name()),
        );

  final DartPackage _package;

  final Project _project;

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

  void addPlatform(Platform platform) {
    final projectName = _appPackage._project.melosFile.name();
    final platformName = platform.name;
    final envName = env == Environment.development
        ? 'dev'
        : env == Environment.test
            ? 'test'
            : 'prod';

    _file.addImport(
      'package:${projectName}_${platformName}_app/${projectName}_${platformName}_app.dart',
      alias: platformName,
    );

    if (platform == Platform.web) {
      _file.addImport('package:url_strategy/url_strategy.dart');
    }

    // TODO rethink the procces of adding/inserting code / method is it the same?
    _file.insertCode(
      '${platform.name}: run${platform.name.pascalCase}App,',
      start: 'TODO'.indexOf('runOnPlatform('), // TODO use contents
    );

    _file.addMethod(
      Method(
        (m) => m
          ..returns = refer('Future<void>')
          ..name = 'run${platformName.pascalCase}App'
          ..modifier = MethodModifier.async
          ..body = Code([
            'configureDependencies(Environment.$envName, Platform.$platformName);',
            if (platform == Platform.web) 'setPathUrlStrategy();',
            'WidgetsFlutterBinding.ensureInitialized();',
            '// TODO: add more $platformName ${env.name} setup here',
            '',
            'final logger = getIt<${projectName.pascalCase}Logger>();',
            'final app = $platformName.App(',
            '  navigatorObserverBuilder: () => [',
            '    ${projectName.pascalCase}RouterObserver(logger),',
            '  ],',
            ');',
            'await bootstrap(app, logger);',
          ].join('\n')),
      ),
    );
  }

  void removePlatform(Platform platform) {
    final projectName = 'TODO'; // TODO
    final platformName = platform.name;

    _file.removeImport(
      'package:${projectName}_${platformName}_app/${projectName}_${platformName}_app.dart',
    );

    if (platform == Platform.web) {
      _file.removeImport('package:url_strategy/url_strategy.dart');
    }

    // TODO rethink the procces of removing code / method is it the same?
    final token = '${platform.name}: run${platform.name.pascalCase}App';
    final start = 'TODO'.indexOf(token); // TODO file content
    final end = start + token.length;
    _file.removeCode(start, end);

    _file.removeMethod('run${platformName.pascalCase}App');
  }
}
