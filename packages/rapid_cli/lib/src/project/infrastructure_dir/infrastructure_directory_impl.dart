import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/directory.dart';
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
  List<InfrastructurePackage>? infrastructurePackagesOverrides;

  @override
  InfrastructurePackage infrastructurePackage({String? name}) =>
      (infrastructurePackageOverrides ?? InfrastructurePackage.new)(
        name: name,
        project: _project,
      );

  @override
  List<InfrastructurePackage> infrastructurePackages() =>
      infrastructurePackagesOverrides ??
          list().whereType<Directory>().map(
            (e) {
              final basename = p.basename(e.path);
              if (!basename.startsWith('${_project.name()}_infrastructure_')) {
                return infrastructurePackage(name: null);
              }

              final name = p
                  .basename(e.path)
                  .replaceAll('${_project.name()}_infrastructure_', '');
              return infrastructurePackage(name: name);
            },
          ).toList()
        ..sort();
}
