import '../../../../project/platform.dart';
import '../../../base.dart';
import '../../../util/class_name_rest.dart';
import '../../../util/platform_x.dart';

class PlatformFeatureAddBlocCommand extends RapidLeafCommand
    with ClassNameGetter {
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
      'Adds a bloc to $featureName of the ${platform.prettyName} part of an existing Rapid project.';

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
