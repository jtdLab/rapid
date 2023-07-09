/* import 'package:rapid_cli/src/io.dart';
import 'package:rapid_cli/src/project/project.dart';

import '../mock_fs.dart';

/// Creates a mock project at [projectRoot], containing a `melos.yaml` and a
/// set of package folders as described by [packages].
///
/// The returned directory represents the project root.
Directory createProjectFs({
  String projectName = 'test_app',
  String? projectRoot,
  bool setCwdToWorkspace = true,
}) {
  assert(
    IOOverrides.current is MockFs,
    'Mock project can only be created inside a mock filesystem',
  );

  projectRoot = Platform.isWindows ? r'C:\rapid_project' : '/rapid_project';

  // Create a `rapid.yaml`
  _createRapidConfig(
    projectRoot,
    projectName,
  );

  final x = UiPackage(
    projectName: projectName,
    path: path,
    widget: widget,
    themedWidget: themedWidget,
  );
  x.

  if (setCwdToWorkspace) {
    Directory.current = projectRoot;
  }

  return Directory(projectRoot);
}
 */