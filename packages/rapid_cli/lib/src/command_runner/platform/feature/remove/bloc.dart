import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/project/platform.dart';

import '../../../base.dart';
import '../../../util/class_name_rest.dart';

class PlatformFeatureRemoveBlocCommand extends RapidLeafCommand
    with ClassNameGetter {
  PlatformFeatureRemoveBlocCommand(
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
      'rapid ${platform.name} $featureName remove bloc <name> [arguments]';

  @override
  String get description =>
      'Removes a bloc from $featureName of the ${platform.prettyName} part of an existing Rapid project.';

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
