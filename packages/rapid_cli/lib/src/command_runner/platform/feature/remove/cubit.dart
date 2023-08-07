import '../../../../utils.dart';
import '../../../base.dart';
import '../../../util/class_name_rest.dart';

/// {@template platform_feature_remove_cubit_command}
/// `rapid <platform> <feature> remove cubit` remove a cubit from a feature of the platform part of a Rapid project.
/// {@endtemplate}
class PlatformFeatureRemoveCubitCommand extends RapidPlatformLeafCommand
    with ClassNameGetter {
  /// {@macro platform_feature_remove_cubit_command}
  PlatformFeatureRemoveCubitCommand(
    this.featureName,
    super.project, {
    required super.platform,
  });

  final String featureName;

  @override
  String get name => 'cubit';

  @override
  String get invocation =>
      'rapid ${platform.name} $featureName remove cubit <name> [arguments]';

  @override
  String get description =>
      'Remove a cubit from $featureName of the ${platform.prettyName} part of a Rapid project.';

  @override
  Future<void> run() {
    final name = super.className;
    final featureName = this.featureName;

    return rapid.platformFeatureRemoveCubit(
      platform,
      name: name,
      featureName: featureName,
    );
  }
}
