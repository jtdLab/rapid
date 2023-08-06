import '../../../../project/platform.dart';
import '../../../../utils.dart';
import '../../../base.dart';
import '../../../util/class_name_rest.dart';

/// {@template platform_feature_add_bloc_command}
/// `rapid <platform> <feature> add bloc` add a bloc to a feature of the platform part of a Rapid project.
/// {@endtemplate}
class PlatformFeatureAddBlocCommand extends RapidLeafCommand
    with ClassNameGetter {
  /// {@macro platform_feature_add_bloc_command}
  PlatformFeatureAddBlocCommand(
    this.platform,
    this.featureName,
    super.project,
  );

  final Platform platform;
  final String featureName;

  @override
  String get name => 'bloc';

  @override
  String get invocation =>
      'rapid ${platform.name} $featureName add bloc <name> [arguments]';

  @override
  String get description =>
      'Add a bloc to $featureName of the ${platform.prettyName} part of a Rapid project.';

  @override
  Future<void> run() {
    final name = super.className;
    final featureName = this.featureName;

    return rapid.platformFeatureAddBloc(
      platform,
      name: name,
      featureName: featureName,
    );
  }
}
