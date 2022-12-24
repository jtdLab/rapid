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
class MainFile extends ProjectFile {
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
/*     final projectName = appPackage.project.melosFile.name;
    final platformName = platform.name;
    // TODO impl
    // 1. add import
    final import =
        'import \'package:${projectName}_${platformName}_app/${projectName}_${platformName}_app.dart\' as $platformName;';
    // 2. add platform method to run onPlatform
    // 3. add platform method impl */
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
