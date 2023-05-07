import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/directory.dart';
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
  List<DomainPackage>? domainPackagesOverrides;

  @override
  DomainPackage domainPackage({String? name}) =>
      (domainPackageOverrides ?? DomainPackage.new)(
        name: name,
        project: _project,
      );

  @override
  List<DomainPackage> domainPackages() => domainPackagesOverrides ??
      list().whereType<Directory>().map(
        (e) {
          final basename = p.basename(e.path);
          if (!basename.startsWith('${_project.name()}_domain_')) {
            return domainPackage(name: null);
          }

          final name =
              p.basename(e.path).replaceAll('${_project.name()}_domain_', '');
          return domainPackage(name: name);
        },
      ).toList()
    ..sort();
}
