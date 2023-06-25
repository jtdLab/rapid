import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../../../base.dart';

class PlatformFeatureAddLocalizationCommand extends RapidLeafCommand {
  PlatformFeatureAddLocalizationCommand(
    this.platform,
    this.featureName,
    super.project,
  );

  final Platform platform;
  final String featureName;

  @override
  String get name => 'localization';

  @override
  List<String> get aliases => ['l'];

  @override
  String get invocation =>
      'rapid ${platform.name} $featureName add localization';

  @override
  String get description =>
      'Adds localizations to $featureName of the ${platform.prettyName} part of an existing Rapid project.';

  @override
  Future<void> run() {
    final featureName = this.featureName;

    return rapid.platformFeatureAddLocalization(
      platform,
      featureName: featureName,
    );
  }
}
