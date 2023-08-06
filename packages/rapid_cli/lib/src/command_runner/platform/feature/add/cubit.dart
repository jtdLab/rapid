import '../../../../project/platform.dart';
import '../../../base.dart';
import '../../../util/class_name_rest.dart';
import '../../../util/platform_x.dart';

class PlatformFeatureAddCubitCommand extends RapidLeafCommand
    with ClassNameGetter {
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
      'Adds a cubit to $featureName of the ${platform.prettyName} part of an existing Rapid project.';

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
