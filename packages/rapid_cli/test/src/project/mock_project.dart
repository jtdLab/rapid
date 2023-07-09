import 'package:rapid_cli/src/io.dart';
import 'package:rapid_cli/src/io.dart' as io;
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/project_config.dart';

import '../mock_fs.dart';

RapidProject createProject({
  String projectName = 'test_app',
}) {
  assert(
    IOOverrides.current is MockFs,
    'Mock project can only be created inside a mock filesystem',
  );

  final projectRoot =
      io.Platform.isWindows ? r'C:\rapid_project' : '/rapid_project';

  return RapidProject.fromConfig(
    RapidProjectConfig(
      path: projectRoot,
      name: projectName,
    ),
  );
}

/// Creates a mock project at [projectRoot], containing a `melos.yaml` and a
/// set of package folders as described by [packages].
///
/// The returned directory represents the project root.
Future<Directory> createProjectFs({
  String projectName = 'test_app',
  String? projectRoot,
  Language language = const Language(languageCode: 'en'),
  bool setCwdToWorkspace = true,
}) async {
  assert(
    IOOverrides.current is MockFs,
    'Mock project can only be created inside a mock filesystem',
  );

  projectRoot = io.Platform.isWindows ? r'C:\rapid_project' : '/rapid_project';

  final config = RapidProjectConfig(
    path: projectRoot,
    name: projectName,
  );
  final project = RapidProject.fromConfig(config);
  await project.rootPackage.generate();
  await project.appModule.diPackage.generate();
  await project.appModule.domainDirectory.domainPackage().generate();
  await project.appModule.infrastructureDirectory
      .infrastructurePackage()
      .generate();
  await project.appModule.loggingPackage.generate();
  await project.uiModule.uiPackage.generate();

  for (final platform in Platform.values) {
    final rootPackage =
        project.appModule.platformDirectory(platform: platform).rootPackage;
    switch (platform) {
      case Platform.ios:
        await (rootPackage as IosRootPackage).generate(
          orgName: 'com.example.com',
          language: language,
        );
      case Platform.macos:
        await (rootPackage as MacosRootPackage).generate(
          orgName: 'com.example.com',
        );
      case Platform.mobile:
        await (rootPackage as MobileRootPackage).generate(
          orgName: 'com.example.com',
          description: 'Foo bar',
          language: language,
        );
      default:
        await (rootPackage as NoneIosRootPackage).generate(
          orgName: 'com.example.com',
          description: 'Foo bar',
        );
    }
    await project.appModule
        .platformDirectory(platform: platform)
        .localizationPackage
        .generate(defaultLanguage: language);
    await project.appModule
        .platformDirectory(platform: platform)
        .navigationPackage
        .generate();
    await project.appModule
        .platformDirectory(platform: platform)
        .featuresDirectory
        .appFeaturePackage
        .generate();
    await project.appModule
        .platformDirectory(platform: platform)
        .featuresDirectory
        .featurePackage<PlatformPageFeaturePackage>(name: 'home_page')
        .generate();

    await project.uiModule.platformUiPackage(platform: platform).generate();
  }

  final rootDir = Directory(projectRoot);
  if (setCwdToWorkspace) {
    Directory.current = rootDir;
  }

  return rootDir;
}

/// Used to generate a dart package's on-disk representation via
/// [createProjectFs].
class MockDartPackageFs {}
