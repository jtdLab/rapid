import '../../../project/platform.dart';
import '../../base.dart';
import '../../util/dart_package_name_rest.dart';
import '../../util/platform_x.dart';

class PlatformRemoveFeatureCommand extends RapidLeafCommand
    with DartPackageNameGetter {
  PlatformRemoveFeatureCommand(this.platform, super.project);

  final Platform platform;

  @override
  String get name => 'feature';

  @override
  List<String> get aliases => ['feat'];

  @override
  String get invocation => 'rapid ${platform.name} remove feature <name>';

  @override
  String get description =>
      'Removes a feature from the ${platform.prettyName} part of an existing Rapid project.';

  @override
  Future<void> run() {
    final name = super.dartPackageName;

    return rapid.platformRemoveFeature(
      platform,
      name: name,
    );
  }
}
