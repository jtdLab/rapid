part of '../project.dart';

class AppModule extends Directory {
  AppModule({
    required String path,
    required this.diPackage,
    required this.domainDirectory,
    required this.infrastructureDirectory,
    required this.loggingPackage,
    required this.platformDirectory,
  }) : super(path);

  factory AppModule.resolve({
    required String projectName,
    required String projectPath,
  }) {
    final path = p.join(projectPath, 'packages', projectName);
    final diPackage = DiPackage.resolve(
      projectName: projectName,
      projectPath: projectPath,
    );
    final domainDirectory = DomainDirectory.resolve(
      projectName: projectName,
      projectPath: projectPath,
    );
    final infrastructureDirectory = InfrastructureDirectory.resolve(
      projectName: projectName,
      projectPath: projectPath,
    );
    final loggingPackage = LoggingPackage.resolve(
      projectName: projectName,
      projectPath: projectPath,
    );
    platformDirectory({required Platform platform}) =>
        PlatformDirectory.resolve(
          projectName: projectName,
          projectPath: projectPath,
          platform: platform,
        );

    return AppModule(
      path: path,
      diPackage: diPackage,
      domainDirectory: domainDirectory,
      infrastructureDirectory: infrastructureDirectory,
      loggingPackage: loggingPackage,
      platformDirectory: platformDirectory,
    );
  }

  final DiPackage diPackage;

  final DomainDirectory domainDirectory;

  final InfrastructureDirectory infrastructureDirectory;

  final LoggingPackage loggingPackage;

  final PlatformDirectory Function({required Platform platform})
      platformDirectory;
}
