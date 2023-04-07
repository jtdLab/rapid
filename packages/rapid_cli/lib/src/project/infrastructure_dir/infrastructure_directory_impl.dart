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
  InfrastructurePackage infrastructurePackage({String? name}) =>
      (infrastructurePackageOverrides ?? InfrastructurePackage.new)(
        name: name,
        project: _project,
      );

  @override
  Future<InfrastructurePackage> addInfrastructurePackage({
    required String name,
  }) async {
    final infrastructurePackage = this.infrastructurePackage(name: name);

    if (infrastructurePackage.exists()) {
      throw RapidException(
        'The sub infrastructure package $name does already exists',
      );
    }

    await infrastructurePackage.create();
    return infrastructurePackage;
  }

  @override
  Future<InfrastructurePackage> removeInfrastructurePackage({
    required String name,
  }) async {
    final infrastructurePackage = this.infrastructurePackage(name: name);

    if (!infrastructurePackage.exists()) {
      throw RapidException(
        'The sub infrastructure package $name does not exist',
      );
    }

    infrastructurePackage.delete();
    return infrastructurePackage;
  }
}