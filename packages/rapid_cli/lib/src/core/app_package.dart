import 'package:dart_style/dart_style.dart';
import 'package:recase/recase.dart';

import 'platform.dart';
import 'project_file.dart';
import 'project_package.dart';

/// {@template app_package}
/// Abstraction of the `packages/<NAME>/<NAME>` package in a Rapid project.
/// {@endtemplate}
class AppPackage extends ProjectPackage {
  /// {@macro app_package}
  AppPackage({
    required super.project,
  }) : super('packages/${project.melosFile.name}/${project.melosFile.name}');

  Set<MainFile> get mainFiles => {
        MainFile(Environment.development, appPackage: this),
        MainFile(Environment.test, appPackage: this),
        MainFile(Environment.production, appPackage: this),
      };
}

enum Environment { development, test, production }

/// {@template app_package_main_file}
/// Abstraction of the `lib/main_<ENVIRONMENT>.dart` file in a the app package of a Rapid project.
/// {@endtemplate}
class MainFile extends ProjectFile with DartFile {
  /// {@macro app_package_main_file}
  MainFile(
    this.environment, {
    required this.appPackage,
  }) : super(
          '${appPackage.path}/lib/main_${environment.name}.dart',
        );

  final AppPackage appPackage;
  final Environment environment;

  // TODO better name ?

  /// Adds all required code to run the application on [platform].
  void addPlatform(Platform platform) {
    // 1. Add import to platform app package
    final projectName = appPackage.project.melosFile.name;
    final platformName = platform.name;
    final envName = environment == Environment.development
        ? 'dev'
        : environment == Environment.test
            ? 'test'
            : 'prod';
    addImport(
      'package:${projectName}_${platformName}_app/${projectName}_${platformName}_app.dart',
      platformName,
    );
    if (platform == Platform.web) {
      addImport('package:url_strategy/url_strategy.dart', null);
    }

    var content = file.readAsStringSync();

    // 2. Add platform to main method
    const mainStartToken = 'void main() => runOnPlatform(';
    final mainMethodStartIndex = content.indexOf(mainStartToken);

    final mainMethodEndIndex = content.indexOf(');', mainMethodStartIndex);

    final presentPlatformMethodCallsString = content.substring(
        mainMethodStartIndex + mainStartToken.length, mainMethodEndIndex);

    if (presentPlatformMethodCallsString.isEmpty) {
      content = content.replaceRange(
          mainMethodStartIndex + mainStartToken.length,
          mainMethodEndIndex,
          '      $platformName: run${platformName.pascalCase}App,');
    } else {
      final presentPlatformMethodCalls =
          presentPlatformMethodCallsString.replaceAll('\n', '').split(',');
      presentPlatformMethodCalls
          .removeWhere((element) => element.trim().isEmpty);

      final presentPlatforms =
          presentPlatformMethodCalls.map((e) => e.split(':').first.trim());

      if (!presentPlatforms.contains(platformName)) {
        final updatedPlatformMethodCalls = [
          ...presentPlatformMethodCalls.map((e) => e.endsWith(',') ? e : '$e,'),
          '      $platformName: run${platformName.pascalCase}App,'
        ];
        updatedPlatformMethodCalls.sort();

        content = content.replaceRange(
          mainMethodStartIndex + mainStartToken.length,
          mainMethodEndIndex,
          updatedPlatformMethodCalls.join('\n'),
        );
      }
    }

    // 3. add platform method impl
    // TODO sort it alphabetically
    final platformMethodStartIndex =
        content.indexOf('Future<void> run${platformName.pascalCase}App()');

    if (platformMethodStartIndex == -1) {
      content += [
        '',
        'Future<void> run${platformName.pascalCase}App() async {',
        '  configureDependencies(Environment.$envName, Platform.$platformName);',
        if (platform == Platform.web) '  setPathUrlStrategy();',
        '  WidgetsFlutterBinding.ensureInitialized();',
        '  // TODO: add more $platformName ${environment.name} setup here',
        '',
        '  final logger = getIt<${projectName.pascalCase}Logger>();',
        '  final app = $platformName.App(',
        '    navigatorObserverBuilder: () => [',
        '      ${projectName.pascalCase}RouterObserver(logger),',
        '    ],',
        '  );',
        '  await bootstrap(app, logger);',
        '}',
      ].join('\n');
    }

    content += '\n';

    final output = DartFormatter().format(content);

    file.writeAsStringSync(output, flush: true);
  }

  // TODO better name ?

  /// Removes all required code to run the application on [platform].
  void removePlatform(Platform platform) {
/*     final projectName = appPackage.project.melosFile.name;
    final platformName = platform.name;
    // TODO impl
    // 1. remove import
    final import =
        'import \'package:${projectName}_${platformName}_app/${projectName}_${platformName}_app.dart\' as $platformName;';
    // 2. remove platform method from run onPlatform
    // 3. remove platform method impl */
  }
}
