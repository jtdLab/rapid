import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/directory_impl.dart';
import 'package:rapid_cli/src/project/infrastructure_dir/infrastructure_directory.dart';
import 'package:rapid_cli/src/project/infrastructure_dir/infrastructure_package/infrastructure_package.dart';
import 'package:rapid_cli/src/project/project.dart';

class InfrastructureDirectoryImpl extends DirectoryImpl
    implements InfrastructureDirectory {
  InfrastructureDirectoryImpl({
    required Project project,
  })  : _project = project,
        super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_infrastructure',
          ),
        );

  final Project _project;

  @override
  InfrastructurePackageBuilder? infrastructurePackageOverrides;

  @override
  InfrastructurePackage infrastructurePackage({required String name}) =>
      (infrastructurePackageOverrides ?? InfrastructurePackage.new)(
        name: name,
        project: _project,
      );

  @override
  Future<void> addDataTransferObject({
    required String entityName,
    required String domainName,
    required String outputDir,
    required Logger logger,
  }) async {
    final infrastructurePackage = this.infrastructurePackage(name: domainName);
    await infrastructurePackage.addDataTransferObject(
      entityName: entityName,
      outputDir: outputDir,
      logger: logger,
    );
  }

  @override
  Future<void> addServiceImplementation({
    required String name,
    required String domainName,
    required String serviceName,
    required String outputDir,
    required Logger logger,
  }) async {
    final infrastructurePackage = this.infrastructurePackage(name: domainName);
    await infrastructurePackage.addServiceImplementation(
      name: name,
      serviceName: serviceName,
      outputDir: outputDir,
      logger: logger,
    );
  }

  @override
  Future<void> removeDataTransferObject({
    required String name,
    required String domainName,
    required String dir,
    required Logger logger,
  }) async {
    final infrastructurePackage = this.infrastructurePackage(name: domainName);
    await infrastructurePackage.removeDataTransferObject(
      name: name,
      dir: dir,
      logger: logger,
    );
  }

  @override
  Future<void> removeServiceImplementation({
    required String name,
    required String domainName,
    required String serviceName,
    required String dir,
    required Logger logger,
  }) async {
    final infrastructurePackage = this.infrastructurePackage(name: domainName);
    await infrastructurePackage.removeServiceImplementation(
      name: name,
      serviceName: serviceName,
      dir: dir,
      logger: logger,
    );
  }
}
