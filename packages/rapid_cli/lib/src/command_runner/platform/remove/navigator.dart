import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../../base.dart';
import '../../util/feature_option.dart';

// TODO feature as a param sucks
class PlatformRemoveNavigatorCommand extends RapidLeafCommand
    with FeatureGetter {
  PlatformRemoveNavigatorCommand(this.platform, super.project) {
    argParser
      ..addSeparator('')
      // TODO add hint that its a dart package nameish string but not the full name of the related package
      ..addFeatureOption(
        help: 'The name of the feature the navigator is related to.\n'
            'This must be the name of an existing ${platform.prettyName} feature.',
      );
  }

  final Platform platform;

  @override
  String get name => 'navigator';

  @override
  List<String> get aliases => ['nav'];

  @override
  String get invocation =>
      'rapid ${platform.name} remove navigator [arguments]';

  @override
  String get description =>
      'Remove a navigator from the ${platform.prettyName} part of an existing Rapid project.';

  @override
  Future<void> run() {
    final featureName = super.feature;

    return rapid.platformRemoveNavigator(
      platform,
      featureName: featureName,
    );
  }
}
