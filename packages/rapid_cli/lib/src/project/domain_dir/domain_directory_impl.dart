import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/directory_impl.dart';
import 'package:rapid_cli/src/project/domain_dir/domain_directory.dart';
import 'package:rapid_cli/src/project/domain_dir/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/project.dart';

class DomainDirectoryImpl extends DirectoryImpl implements DomainDirectory {
  DomainDirectoryImpl({
    required Project project,
  })  : _project = project,
        super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_domain',
          ),
        );

  final Project _project;

  @override
  DomainPackageBuilder? domainPackageOverrides;

  @override
  DomainPackage domainPackage({required String name}) =>
      (domainPackageOverrides ?? DomainPackage.new)(
        name: name,
        project: _project,
      );

  @override
  Future<void> addEntity({
    required String name,
    required String domainName,
    required String outputDir,
    required Logger logger,
  }) async {
    final domainPackage = this.domainPackage(name: domainName);
    await domainPackage.addEntity(
      name: name,
      outputDir: outputDir,
      logger: logger,
    );
  }

  @override
  Future<void> addServiceInterface({
    required String name,
    required String domainName,
    required String outputDir,
    required Logger logger,
  }) async {
    final domainPackage = this.domainPackage(name: domainName);
    await domainPackage.addServiceInterface(
      name: name,
      outputDir: outputDir,
      logger: logger,
    );
  }

  @override
  Future<void> addValueObject({
    required String name,
    required String domainName,
    required String outputDir,
    required String type,
    required String generics,
    required Logger logger,
  }) async {
    final domainPackage = this.domainPackage(name: domainName);
    await domainPackage.addValueObject(
      name: name,
      outputDir: outputDir,
      type: type,
      generics: generics,
      logger: logger,
    );
  }

  @override
  Future<void> removeEntity({
    required String name,
    required String domainName,
    required String dir,
    required Logger logger,
  }) async {
    final domainPackage = this.domainPackage(name: domainName);
    await domainPackage.removeEntity(
      name: name,
      dir: dir,
      logger: logger,
    );
  }

  @override
  Future<void> removeServiceInterface({
    required String name,
    required String domainName,
    required String dir,
    required Logger logger,
  }) async {
    final domainPackage = this.domainPackage(name: domainName);
    await domainPackage.removeServiceInterface(
      name: name,
      dir: dir,
      logger: logger,
    );
  }

  @override
  Future<void> removeValueObject({
    required String name,
    required String domainName,
    required String dir,
    required Logger logger,
  }) async {
    final domainPackage = this.domainPackage(name: domainName);
    await domainPackage.removeValueObject(
      name: name,
      dir: dir,
      logger: logger,
    );
  }
}
