import '../../../../utils.dart';
import '../../../base.dart';
import '../../../util/class_name_rest.dart';

/// {@template platform_feature_remove_bloc_command}
/// `rapid <platform> <feature> remove bloc` remove a bloc from a feature of the platform part of a Rapid project.
/// {@endtemplate}
class PlatformFeatureRemoveBlocCommand extends RapidPlatformLeafCommand
    with ClassNameGetter {
  /// {@macro platform_feature_remove_bloc_command}
  PlatformFeatureRemoveBlocCommand(
    this.featureName,
    super.project, {
    required super.platform,
  });

  final String featureName;

  @override
  String get name => 'bloc';

  @override
  String get invocation =>
      'rapid ${platform.name} $featureName remove bloc <name> [arguments]';

  @override
  String get description =>
      'Remove a bloc from $featureName of the ${platform.prettyName} part of a Rapid project.';

  @override
  Future<void> run() {
    final name = super.className;
    final featureName = this.featureName;

    return rapid.platformFeatureRemoveBloc(
      platform,
      name: name,
      featureName: featureName,
    );
  }
}
