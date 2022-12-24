import 'platform.dart';
import 'project.dart';
import 'project_dir.dart';

/// {@template platform_dir}
/// Abstraction of the `packages/<NAME>/<NAME>_<PLATFORM>` dir in a Rapid project.
/// {@endtemplate}
class PlatformDir extends ProjectDir {
  /// {@macro platform_dir}
  PlatformDir(
    this.platform, {
    required Project project,
  }) : super(
          'packages/${project.melosFile.name}/${project.melosFile.name}_${platform.name}',
        );

  final Platform platform;
}
