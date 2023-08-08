part of '../project.dart';

/// {@template app_module}
/// Abstraction of the app module of a Rapid project.
///
// TODO(jtdLab): more docs
/// {@endtemplate}
class AppModule extends Directory {
  /// {@macro app_module}
  AppModule({
    required String path,
    required this.diPackage,
    required this.domainDirectory,
    required this.infrastructureDirectory,
    required this.loggingPackage,
    required this.platformDirectory,
  }) : super(path);

  /// Returns a [AppModule] from given [projectName] and [projectPath].
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
    PlatformDirectory platformDirectory({required Platform platform}) =>
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

  /// The di package.
  final DiPackage diPackage;

  /// The domain directory.
  final DomainDirectory domainDirectory;

  /// The infrastructure directory.
  final InfrastructureDirectory infrastructureDirectory;

  /// The logging package.
  final LoggingPackage loggingPackage;

  /// The platform directory builder.
  final PlatformDirectory Function({required Platform platform})
      platformDirectory;
}
