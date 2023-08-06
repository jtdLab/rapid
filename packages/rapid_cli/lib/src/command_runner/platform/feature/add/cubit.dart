import '../../../../project/platform.dart';
import '../../../../utils.dart';
import '../../../base.dart';
import '../../../util/class_name_rest.dart';

/// {@template platform_feature_add_cubit_command}
/// `rapid <platform> <feature> add cubit` add a cubit to a feature of the platform part of a Rapid project.
/// {@endtemplate}
class PlatformFeatureAddCubitCommand extends RapidLeafCommand
    with ClassNameGetter {
  /// {@macro platform_feature_add_cubit_command}
  PlatformFeatureAddCubitCommand(
    this.platform,
    this.featureName,
    super.project,
  );

  final Platform platform;
  final String featureName;

  @override
  String get name => 'cubit';

  @override
  String get invocation =>
      'rapid ${platform.name} $featureName add cubit <name> [arguments]';

  @override
  String get description =>
      'Add a cubit to $featureName of the ${platform.prettyName} part of a Rapid project.';

  @override
  Future<void> run() {
    final name = super.className;
    final featureName = this.featureName;

    return rapid.platformFeatureAddCubit(
      platform,
      name: name,
      featureName: featureName,
    );
  }
}
