import '../../../utils.dart';
import '../../base.dart';
import '../../util/dart_package_name_rest.dart';

/// {@template platform_remove_feature_command}
/// `rapid <platform> remove feature` remove a feature from the platform part
/// of a Rapid project.
/// {@endtemplate}
class PlatformRemoveFeatureCommand extends RapidPlatformLeafCommand
    with DartPackageNameGetter {
  /// {@macro platform_remove_feature_command}
  PlatformRemoveFeatureCommand(super.project, {required super.platform});

  @override
  String get name => 'feature';

  @override
  List<String> get aliases => ['feat'];

  @override
  String get invocation => 'rapid ${platform.name} remove feature <name>';

  @override
  String get description =>
      'Remove a feature from the ${platform.prettyName} part of a Rapid '
      'project.';

  @override
  Future<void> run() {
    final name = super.dartPackageName;

    return rapid.platformRemoveFeature(
      platform,
      name: name,
    );
  }
}
